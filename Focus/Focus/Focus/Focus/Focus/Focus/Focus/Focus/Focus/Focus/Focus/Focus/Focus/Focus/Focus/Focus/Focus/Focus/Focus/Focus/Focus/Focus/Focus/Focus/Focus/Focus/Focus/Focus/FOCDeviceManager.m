//
//  FocusDeviceManager.m
//  Focus
//
//  Created by Jamie Lynch on 30/06/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCDeviceManager.h"
#import "FocusConstants.h"
#import "FOCNotificationModel.h"
#import <Crashlytics/Crashlytics.h>

static const int kPairButton = 1;
static NSString *kStoredPeripheralId = @"StoredPeripheralId";
static const int kProgramCheckInterval = 0.5;
static const double kProgramTimeoutMs = 1000;
static const double kIgnoreInterval = 6000;

@interface FOCDeviceManager ()

@property CBCentralManager* cbCentralManager;
@property CBPeripheral* focusDevice;
@property NSMutableArray *scannedDevices;

@property FOCBluetoothPairManager *bluetoothPairManager;
@property FOCCharacteristicDiscoveryManager *characteristicManager;
@property FOCProgramSyncManager *syncManager;
@property FOCProgramRequestManager *requestManager;
@property FOCNotificationModel *notificationModel;

@property bool isDevicePaired;
@property bool isPlayingProgram;

@property double lastNotificationMs;
@property double ignoreNotificationMs;

@end

@implementation FOCDeviceManager

- (id)init
{
    if (self = [super init]) {
        self.cbCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        [self updateConnectionState:UNKNOWN];
        
        _notificationModel = [[FOCNotificationModel alloc] init];
        _lastNotificationMs = 0;
        _ignoreNotificationMs = 0;
        
        _scannedDevices = [[NSMutableArray alloc] init];
        
        [NSTimer scheduledTimerWithTimeInterval:kProgramCheckInterval target:self selector:@selector(checkProgramPlayState) userInfo:nil repeats:true];
    }
    return self;
}

/**
 * Check whether a program is playing or not every N seconds
 */
- (void)checkProgramPlayState
{
    double ms = [NSDate timeIntervalSinceReferenceDate] * 1000;
    double diff = ms - _lastNotificationMs;
    double ignoreDiff = ms - _ignoreNotificationMs;
    
    if (diff > kProgramTimeoutMs) {
        if (_isPlayingProgram) {
            NSLog(@"Heuristic determined that the Focus device stopped playing a program independently of the app");
            
            // still get notifications for few secs after stopping, these are ignored with flag
            _isPlayingProgram = false;
            [self didAlterProgramState:_isPlayingProgram error:nil];
        }
    }
    else if (diff <= kProgramTimeoutMs && ignoreDiff >= kIgnoreInterval) {
        if (!_isPlayingProgram) {
            NSLog(@"Heuristic determined that the Focus device started playing a program independently of the app %f", ignoreDiff);
            
            _isPlayingProgram = true;
            [self didAlterProgramState:_isPlayingProgram error:nil];
        }
    }
}

#pragma mark - internal API methods

- (void)refreshDeviceState
{
    if (_focusDevice == nil || _focusDevice.state != CBPeripheralStateConnected) {
        CLS_LOG("Refreshing bluetooth scan");
        [self handleBluetoothStateUpdate];
    }
    else if (!_isDevicePaired) {
        CLS_LOG("Attempting device pair prompt");
        [self promptPairingDialog];
    }
    else {
        CLS_LOG("No refresh action required");
    }
}

- (void)closeConnection
{
    if (_focusDevice != nil) {
        CLS_LOG("Closing peripheral connection");
        [_cbCentralManager cancelPeripheralConnection:_focusDevice];
    }
    else {
        CLS_LOG("No peripheral connection available to close");
    }
}

- (void) displayUserErrMessage:(NSString *) title message:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

- (void)playProgram:(FOCDeviceProgramEntity *)program
{
    if ([self isReadyForRequests]) {
        [_requestManager startProgram:program];
    }
    else {
        [self displayNotReadyAlert];
    }
}

- (void)stopProgram:(FOCDeviceProgramEntity *)program
{
    if ([self isReadyForRequests]) {
        [_requestManager stopActiveProgram];
    }
    else {
        [self displayNotReadyAlert];
    }
}

- (void)writeProgram:(FOCDeviceProgramEntity *)program
{
    if ([self isReadyForRequests]) {
        [_requestManager writeProgram:program];
    }
    else {
        [self displayNotReadyAlert];
    }
}

- (bool)isReadyForRequests
{
    return _focusDevice.delegate == _requestManager && _connectionState == CONNECTED;
}

- (void)displayNotReadyAlert
{
    [self displayUserErrMessage:@"Focus not ready" message:@"The device isn't ready yet. Please check it is connected and powered on."];
}

#pragma mark - implementation

/**
 * Attempts to connect to previously known devices, or if none are found, initiates a BLE scan
 */
- (void)connectFocusDevice
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    id storedId = [userDefaults objectForKey:kStoredPeripheralId];
    
    if (storedId != nil) {
        NSLog(@"Attempting connection to previous peripheral %@", storedId);
        
        NSMutableArray *peripheralArray = [[NSMutableArray alloc] init];
        [peripheralArray addObject:[CBUUID UUIDWithString:storedId]];
        
        NSArray *peripherals = [_cbCentralManager retrievePeripheralsWithIdentifiers:peripheralArray];
        
        if (peripherals != nil && [peripherals count] > 0) {
            _focusDevice = peripherals[0];
            [_cbCentralManager connectPeripheral:_focusDevice options:nil];
            [self updateConnectionState:CONNECTING];
        }
        else {
            [self scanForFocusPeripherals];
            [self updateConnectionState:SCANNING];
        }
    }
    else {
        [self updateConnectionState:DISCONNECTED];
    }
}

/**
 * Scans for peripherals with a Focus characteristic filter.
 */
- (void)scanForFocusPeripherals
{
    [self performSelector:@selector(finishDeviceScan) withObject:nil afterDelay:10];
    NSLog(@"BLE peripheral scan initiated");
    
    // reset previous peripherals
    [[[NSUserDefaults alloc] init] setObject:nil forKey:kStoredPeripheralId];
    
    if (self.focusDevice != nil) {
        [_cbCentralManager cancelPeripheralConnection:_focusDevice];
    }
    
    NSMutableArray *desiredServices = [[NSMutableArray alloc] init];
    [desiredServices addObject:[CBUUID UUIDWithString:FOC_SERVICE_UNKNOWN]];
    [self.cbCentralManager scanForPeripheralsWithServices:nil options:nil];
    
    // FIXME should filter!
    
}

/**
 * Cancel scan after X seconds timeout
 */
- (void)finishDeviceScan
{
    if ([_scannedDevices count] == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Scan cancelled" message:@"No devices found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    if (_connectionState == SCANNING) {
        [self cancelScan];
    }
}

- (void)cancelScan
{
    [self.cbCentralManager stopScan];
    NSLog(@"Terminating BLE Scan, initiating connection");
    [self updateConnectionState:DISCONNECTED];
}

- (void)useNewFocusDevice:(CBPeripheral *)peripheral
{
    [self finishDeviceScan];
    self.focusDevice = peripheral;
    
    if (self.focusDevice != nil) {
        [self.cbCentralManager connectPeripheral:self.focusDevice options:nil];
        [self updateConnectionState:CONNECTING];
    }
    else {
        [self updateConnectionState:DISCONNECTED];
    }
}

- (void)updateConnectionState:(FocusConnectionState)state
{
    NSString *stateName;
    
    switch (state) {
        case CONNECTED: stateName = @"Connected"; break;
        case CONNECTING: stateName = @"Connecting"; break;
        case SCANNING: stateName = @"Scanning"; break;
        case DISCONNECTED: stateName = @"Disconnected"; break;
        case DISABLED: stateName = @"Disabled"; break;
        case UNKNOWN: stateName = @"Unknown"; break;
    }
    NSLog(@"Focus connection state changed to '%@'", stateName);
    
    _connectionState = state;
    [_delegate didChangeConnectionState:_connectionState];
    [self updateConnectionText:stateName];
}

- (void)updateConnectionText:(NSString *)text
{
    _connectionText = text;
    [_delegate didChangeConnectionText:_connectionText];
}

/**
 * Disconnects from the peripheral then reconnects, which triggers a pairing request.
 */
- (void)promptPairingDialog
{
    [_bluetoothPairManager checkPairing:_characteristicManager.controlCmdRequest];
    [_cbCentralManager cancelPeripheralConnection:_focusDevice];
    _focusDevice = nil;
    [self handleBluetoothStateUpdate];
}

/**
 * Handles connection/disconnection events of bluetooth, and shows errors to user if required.
 */
- (void)handleBluetoothStateUpdate
{
    if ([_cbCentralManager state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
        [self connectFocusDevice];
    }
    else if ([_cbCentralManager state] == CBCentralManagerStatePoweredOff) {
        [self displayUserErrMessage:@"Bluetooth disabled" message:@"Please turn on bluetooth to control your Focus device."];
        [self updateConnectionState:DISCONNECTED];
    }
    else if ([_cbCentralManager state] == CBCentralManagerStateUnauthorized) {
        [self updateConnectionState:DISCONNECTED];
        [self displayUserErrMessage:@"Bluetooth unauthorised" message:@"Please authorise the bluetooth permission to control your Focus device."];
    }
    else if ([_cbCentralManager state] == CBCentralManagerStateUnsupported) {
        [self updateConnectionState:DISABLED];
        [self displayUserErrMessage:@"Bluetooth unsupported" message:@"Your device does not currently support this Focus device."];
    }
    else if ([_cbCentralManager state] == CBCentralManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
        [self updateConnectionState:DISABLED];
    }
    else {
        NSLog(@"Unknown bluetooth CentralManager update");
        [self updateConnectionState:UNKNOWN];
    }
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager*)central didDiscoverPeripheral:(CBPeripheral*)peripheral advertisementData:(NSDictionary*)advertisementData RSSI:(NSNumber*)RSSI
{
    NSLog(@"Discovered '%@ - %@'", peripheral.name, peripheral.identifier.UUIDString);
    [_scannedDevices addObject:peripheral];
    [_scanningDelegate didDiscoverFocusDevice:peripheral];
}

- (void)centralManager:(CBCentralManager*)central didConnectPeripheral:(CBPeripheral*)peripheral
{
    NSLog(@"Connected to peripheral '%@' with UUID '%@'", peripheral.name, peripheral.identifier.UUIDString);
    
    NSMutableArray *desiredServices = [[NSMutableArray alloc] init];
    [desiredServices addObject:[CBUUID UUIDWithString:FOC_SERVICE_TDCS]];
    
    _focusDevice = peripheral;
    
    _characteristicManager = [[FOCCharacteristicDiscoveryManager alloc] initWithPeripheral:_focusDevice];
    _characteristicManager.delegate = self;
    _focusDevice.delegate = _characteristicManager;
    
    [_focusDevice discoverServices:desiredServices];
    [self updateConnectionState:SCANNING];
}

- (void)centralManagerDidUpdateState:(CBCentralManager*)central
{
    [self handleBluetoothStateUpdate];
}

#pragma mark - CharacteristicDiscoveryDelegate

-(void)didFinishCharacteristicDiscovery:(NSError *)error
{
    NSLog(@"Finished discovering characteristics, beginning pairing check");
    
    _bluetoothPairManager = [[FOCBluetoothPairManager alloc] initWithPeripheral:_focusDevice];
    _focusDevice.delegate = _bluetoothPairManager;

    _bluetoothPairManager.delegate = self;
    [_bluetoothPairManager checkPairing:_characteristicManager.controlCmdRequest];
}

#pragma mark - BluetoothPairingDelegate

- (void)didDiscoverBluetoothPairState:(BOOL)paired error:(NSError *)error
{
    _isDevicePaired = paired;
    
    if (paired) {
        NSLog(@"Devices are paired, initiating program sync");
        [self updateConnectionState:CONNECTED];
        
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
        [userDefaults setObject:_focusDevice.identifier.UUIDString forKey:kStoredPeripheralId];
        
        _syncManager = [[FOCProgramSyncManager alloc] initWithPeripheral:_focusDevice];
        _syncManager.delegate = self;
        _focusDevice.delegate = _syncManager;
        
        FOCCharacteristicDiscoveryManager *cm = _characteristicManager;
        [_syncManager startProgramSync:cm];
        
        [self updateConnectionText:@"Syncing Device"];
    }
    else {
        NSLog(@"Focus device is not paired. Prompting user.");
        [self updateConnectionText:@"Pairing Device"];
        
        [[[UIAlertView alloc] initWithTitle:@"Pair Bluetooth" message:@"The app can't talk to your device without pairing." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Pair", nil] show];
    }
}

#pragma mark - ProgramSyncDelegate

-(void)didFinishProgramSync:(NSError *)error
{
    NSLog(@"Finished program sync, error=%@", error);
    [self updateConnectionState:CONNECTED];
    
    _requestManager = [[FOCProgramRequestManager alloc] initWithPeripheral:_focusDevice];
    _focusDevice.delegate = _requestManager;

    _requestManager.delegate = self;
    _requestManager.cm = _characteristicManager;
    [_requestManager startNotificationListeners:_focusDevice];
}

#pragma mark - ProgramRequestDelegate

- (void)didAlterProgramState:(bool)playing error:(NSError *)error
{
    _isPlayingProgram = playing;
    _ignoreNotificationMs = [NSDate timeIntervalSinceReferenceDate] * 1000;
    
    if (error == nil) {
        [_delegate programStateChanged:playing];
        [self updateConnectionState:_connectionState];
    }
    else {
        [self displayUserErrMessage:@"Program Request Failed" message:@"Please check that the electrodes are connected to the device."];
        NSLog(@"Program state alteration unsuccessful");
    }
}

- (void)didEditProgram:(FOCDeviceProgramEntity *)program success:(bool)success
{
    // TODO should persist in core data
    
    if (success) {
        [_delegate didUpdateProgram:program];
    }
    else {
        [self displayUserErrMessage:@"Edit failed" message:@"Please check the device is connected and powered on."];
    }
}

- (void)didReceiveCurrentNotification:(int)current
{
    _notificationModel.current = current;
    [self handleNotificationText];
}

- (void)didReceiveDurationNotification:(int)duration
{
    _notificationModel.duration = duration;
    [self handleNotificationText];
}

- (void)didReceiveRemainingTimeNotification:(int)remainingTime
{
    _notificationModel.remainingTime = remainingTime;
    [self handleNotificationText];
}

- (void)handleNotificationText
{
    _lastNotificationMs = [NSDate timeIntervalSinceReferenceDate] * 1000;
    
    if (_isPlayingProgram) { // shouldn't show when program isn't playing
        
        int mins = _notificationModel.duration / 60;
        int secs = _notificationModel.duration % 60;
        float current = ((float)_notificationModel.current) / 1000;
        
        NSString *text = [NSString stringWithFormat:@"%02d:%02d - %.1fmA", mins, secs, current];
        [_delegate didChangeConnectionText:text];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == kPairButton) {
        [self promptPairingDialog];
    }
}

@end

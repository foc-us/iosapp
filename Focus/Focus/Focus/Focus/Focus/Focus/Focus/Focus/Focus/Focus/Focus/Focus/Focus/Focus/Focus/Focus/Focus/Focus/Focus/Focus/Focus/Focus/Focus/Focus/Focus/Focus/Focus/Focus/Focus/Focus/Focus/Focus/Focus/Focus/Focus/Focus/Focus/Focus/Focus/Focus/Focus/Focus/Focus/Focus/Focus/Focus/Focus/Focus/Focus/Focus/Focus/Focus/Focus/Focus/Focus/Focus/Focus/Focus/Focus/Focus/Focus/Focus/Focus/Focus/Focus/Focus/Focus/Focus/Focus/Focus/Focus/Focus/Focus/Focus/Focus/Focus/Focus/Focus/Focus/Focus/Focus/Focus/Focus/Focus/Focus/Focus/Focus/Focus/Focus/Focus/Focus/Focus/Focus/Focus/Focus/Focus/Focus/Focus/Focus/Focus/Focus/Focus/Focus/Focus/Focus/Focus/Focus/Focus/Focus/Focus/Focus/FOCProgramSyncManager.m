//
//  MaxProgramCountRequest.m
//  Focus
//
//  Created by Jamie Lynch on 09/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCProgramSyncManager.h"
#import "FOCDeviceProgramEntity.h"
#import "FOCAppDelegate.h"

@interface FOCProgramSyncManager ()

@property Byte lastSubCmd;
@property Byte programCount;
@property Byte currentProgram;

@property NSData* firstDescriptor;
@property NSData* secondDescriptor;

@property NSMutableArray *programArray;

@end

@implementation FOCProgramSyncManager

- (id)initWithPeripheral:(CBPeripheral *)focusDevice
{
    if (self = [super initWithPeripheral:focusDevice]) {
        _programArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startProgramSync:(FOCCharacteristicDiscoveryManager *)cm
{
    NSData *data = [self constructCommandRequest:FOC_CMD_MANAGE_PROGRAMS subCmdId:FOC_SUBCMD_MAX_PROGRAMS];
    _cm = cm;
    
    [self.focusDevice writeValue:data forCharacteristic:_cm.controlCmdRequest type:CBCharacteristicWriteWithResponse];
    _lastSubCmd = FOC_SUBCMD_MAX_PROGRAMS;
    
    NSLog(@"Writing %@", [self loggableCharacteristicName:_cm.controlCmdRequest]);
}

- (void)peripheral:(CBPeripheral*)peripheral didUpdateValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error
{
    [super peripheral:peripheral didUpdateValueForCharacteristic:characteristic error:error];
    
    if (error == nil) {
        if ([FOC_CHARACTERISTIC_CONTROL_CMD_RESPONSE isEqualToString:characteristic.UUID.UUIDString]) {
            [self deserialiseCommandResponse:characteristic]; // read response buffer data
        }
        else if ([FOC_CHARACTERISTIC_DATA_BUFFER isEqualToString:characteristic.UUID.UUIDString]) {
            [self interpretDataBuffer:characteristic];
        }
        else {
            NSLog(@"Program sync manager encountered unknown udpate value characteristic %@", [self loggableCharacteristicName:characteristic]);
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    [super peripheral:peripheral didWriteValueForCharacteristic:characteristic error:error];
    
    if (error == nil) {
        if ([FOC_CHARACTERISTIC_CONTROL_CMD_REQUEST isEqualToString:characteristic.UUID.UUIDString]) {
            
             // read the response buffer
            [peripheral readValueForCharacteristic:_cm.controlCmdResponse];
        }
        else {
            NSLog(@"Program Sync Manager failed to handle update to %@", [self loggableCharacteristicName:characteristic]);
        }
    }
}
    
- (void)interpretCommandResponse:(Byte)cmdId status:(Byte)status data:(const unsigned char *)data characteristic:(CBCharacteristic *)characteristic
{
    if (status == FOC_STATUS_CMD_SUCCESS && FOC_CMD_MANAGE_PROGRAMS == cmdId) { // Handles Program sync callbacks.
        
        if (FOC_SUBCMD_MAX_PROGRAMS == _lastSubCmd) {
            _programCount = data[0];
            
            NSLog(@"========================================");
            NSLog(@"*****Beginning sync of %d programs*****", _programCount);
            
            // Only begin syncing process if there remain unsynced programs
            if (_currentProgram <= _programCount) {
                [self checkCurrentProgramEnabled];
            }
        }
        else if (FOC_SUBCMD_PROG_STATUS == _lastSubCmd) {
            int progStatus = data[0];
            
            if (FOC_PROG_STATUS_VALID == progStatus) {
                [self writeProgramDescriptor:FOC_PROG_DESC_FIRST];
            }
            else {
                NSLog(@"Program %d status is not valid, skipping", _currentProgram);
                _currentProgram++;
                [self checkCurrentProgramEnabled];
            }
        }
        else if (FOC_SUBCMD_READ_PROG == _lastSubCmd) {
            [self readProgramDescriptorBuffer];
        }
    }
    else if (status == FOC_STATUS_CMD_FAILURE) {
        NSLog(@"Command resulted in failure for Command %hhu with characteristic %@", cmdId, [self loggableCharacteristicName:characteristic]);
    }
    else if (status == FOC_STATUS_CMD_UNSUPPORTED) {
        NSLog(@"Command %hhu unsupported for characteristic %@", cmdId, [self loggableCharacteristicName:characteristic]);
    }
    else {
        NSLog(@"Failed to handle control command response %@", cmdId);
    }
}

- (void)interpretCommandResponse:(NSError *)error
{
    [_delegate didFinishProgramSync:
    [[NSError alloc] initWithDomain:FOCUS_ERROR_DOMAIN code:0 userInfo:nil]];
}

/**
 * Interprets the contents of the data buffer. If this is the first descriptor, the second program descriptor
 * will then be requested (and read here)
 */
-(void)interpretDataBuffer:(CBCharacteristic *)characteristic
{
    NSData *data = characteristic.value;
    
    if (_firstDescriptor == nil) { // retrieve second descriptor before proceeding
        _firstDescriptor = data;
        NSLog(@"Retrieving second descriptor.");
        [self writeProgramDescriptor:FOC_PROG_DESC_SECOND];
    }
    else {
        _secondDescriptor = data;
        
        FOCDeviceProgramEntity *deviceProgramEntity = [[FOCDeviceProgramEntity alloc] init];
        [deviceProgramEntity deserialiseDescriptors:_firstDescriptor secondDescriptor:_secondDescriptor];
        deviceProgramEntity.programId = [[NSNumber alloc] initWithInt:_currentProgram];
        
        [_programArray addObject:deviceProgramEntity];
        
        NSLog(@"*****Finished sync for program '%@'*****", deviceProgramEntity.name);
        NSLog(@"========================================");
        
        _currentProgram++;
        [self checkCurrentProgramEnabled]; // continue iterating over available programs
    }
}

/**
 * Initiates the syncing process for one program, which involves the following:
 *
 * 1. Check if program status is valid, if not skip to the next program.
 * 2. Write program descriptor[0] to the data buffer & deserialise contents.
 * 3. Write program descriptor[1] to the data buffer & deserialise contents.
 */
-(void)checkCurrentProgramEnabled
{
    if (_currentProgram < _programCount) {
        _firstDescriptor = nil;
        _secondDescriptor = nil;
        
        NSData *data = [self constructCommandRequest:FOC_CMD_MANAGE_PROGRAMS subCmdId:FOC_SUBCMD_PROG_STATUS];
        
        _lastSubCmd = FOC_SUBCMD_PROG_STATUS;
        
        [self.focusDevice writeValue:data forCharacteristic:_cm.controlCmdRequest type:CBCharacteristicWriteWithResponse];
    }
    else {
        NSLog(@"Finishing program sync, writing to DB!");
        
        for (FOCDeviceProgramEntity *entity in _programArray) {
            if (entity.name != nil && ![entity.name isEqualToString:@""]) {
                NSLog(@"%@", [entity programDebugInfo]);
            }
        }
        
        FOCAppDelegate *delegate = (FOCAppDelegate *) [[UIApplication sharedApplication] delegate];
        [delegate saveSyncedPrograms:_programArray];
        [self.delegate didFinishProgramSync:nil];
    }
}

/**
 * Writes the first program descriptor to the data buffer.
 */
-(void)writeProgramDescriptor:(Byte)progDescId
{
    NSData *data = [self constructCommandRequest:FOC_CMD_MANAGE_PROGRAMS subCmdId:FOC_SUBCMD_READ_PROG progId:_currentProgram progDescId:progDescId];

    _lastSubCmd = FOC_SUBCMD_READ_PROG;
    
    [self.focusDevice writeValue:data forCharacteristic:_cm.controlCmdRequest type:CBCharacteristicWriteWithResponse];
}

/**
 * Reads the program descriptor from the data buffer (assumes a write command has 
 * been called before)
 */
-(void)readProgramDescriptorBuffer
{
    [self.focusDevice readValueForCharacteristic:_cm.dataBuffer];
}

@end

//
//  ProgramRequestManager.m
//  Focus
//
//  Created by Jamie Lynch on 10/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCProgramRequestManager.h"

@interface FOCProgramRequestManager ()

@property bool requestProgramStart;
@property bool requestProgramStop;
@property bool editingProgram;
@property FOCDeviceProgramEntity *program;

@property bool hasSentStartRequest;
@property bool hasWrittenFirstDescriptor;
@property bool hasWrittenSecondDescriptor;

@end

@implementation FOCProgramRequestManager

- (void)startProgram:(FOCDeviceProgramEntity *)program
{
    [self clearState:nil starting:true stopping:false editing:false];
    Byte programId = (Byte) program.programId.intValue;
    
    NSData *data = [self constructCommandRequest:FOC_CMD_MANAGE_PROGRAMS subCmdId:FOC_SUBCMD_START_PROG progId:programId progDescId:FOC_EMPTY_BYTE];
    
    [self.focusDevice writeValue:data forCharacteristic:_cm.controlCmdRequest type:CBCharacteristicWriteWithResponse];
}

- (void)stopActiveProgram
{
    [self clearState:nil starting:false stopping:true editing:false];
    NSLog(@"Requesting program stop");
    
    NSData *data = [self constructCommandRequest:FOC_CMD_MANAGE_PROGRAMS subCmdId:FOC_SUBCMD_STOP_PROG progId:FOC_EMPTY_BYTE progDescId:FOC_EMPTY_BYTE];
    
    [self.focusDevice writeValue:data forCharacteristic:_cm.controlCmdRequest type:CBCharacteristicWriteWithResponse];
}

- (void)writeProgram:(FOCDeviceProgramEntity *)program
{
    
    NSLog(@"Writing program:\n%@", [_program programDebugInfo]);
    
    [self clearState:program starting:false stopping:false editing:true];
    NSLog(@"Request manager got write command");
    
    [self.focusDevice writeValue:[program serialiseFirstDescriptor] forCharacteristic:_cm.dataBuffer type:CBCharacteristicWriteWithResponse];
}

- (void)clearState:(FOCDeviceProgramEntity *)program starting:(bool)starting stopping:(bool)stopping editing:(bool)editing
{
    _program = program;
    _requestProgramStart = starting;
    _requestProgramStop = stopping;
    _editingProgram = editing;
    
    _hasSentStartRequest = false;
    _hasWrittenFirstDescriptor = false;
    _hasWrittenSecondDescriptor = false;
}

- (void)handleStopResponse:(Byte)status
{
    bool playing = !(FOC_STATUS_CMD_SUCCESS == status);
    
    NSError *error = !playing ? nil : [[NSError alloc] initWithDomain:FOCUS_ERROR_DOMAIN code:0 userInfo:nil];
    [_delegate didAlterProgramState:playing error:error];
}

- (void)handleStartResponse:(Byte)status
{
    bool playing = (FOC_STATUS_CMD_SUCCESS == status);
    
    NSError *error = playing ? nil : [[NSError alloc] initWithDomain:FOCUS_ERROR_DOMAIN code:0 userInfo:nil];
        
    [_delegate didAlterProgramState:playing error:error];
    NSLog(@"Received start response, playing=%d", playing);
}

- (void)handleEditResponse:(Byte)status
{
    if (FOC_STATUS_CMD_SUCCESS == status) {
        
        if (!_hasWrittenFirstDescriptor) {
            _hasWrittenFirstDescriptor = true;
            
            // write second descriptor
            [self.focusDevice writeValue:[_program serialiseSecondDescriptor] forCharacteristic:_cm.dataBuffer type:CBCharacteristicWriteWithResponse];
        }
        else if (_hasWrittenFirstDescriptor && !_hasWrittenSecondDescriptor) {
            _hasWrittenSecondDescriptor = true;
            
            // enable program
            Byte programId = (Byte) _program.programId.intValue;
            
            NSData *data = [self constructCommandRequest:FOC_CMD_MANAGE_PROGRAMS subCmdId:FOC_SUBCMD_ENABLE_PROG progId:programId progDescId:FOC_EMPTY_BYTE];
            
            [self.focusDevice writeValue:data forCharacteristic:_cm.controlCmdRequest type:CBCharacteristicWriteWithResponse];
        }
        else {
            [_delegate didEditProgram:_program success:true];
            NSLog(@"Finished editing program!");
        }
    }
    else {
        [_delegate didEditProgram:_program success:false];
        NSLog(@"Failure in program edit");
    }
}

- (void)interpretCommandResponse:(NSError *)error
{
    NSLog(@"Command response error %@", error);
}

- (void)interpretCommandResponse:(Byte)cmdId status:(Byte)status data:(const unsigned char *)data characteristic:(CBCharacteristic *)characteristic
{
    if (FOC_CMD_MANAGE_PROGRAMS == cmdId) {
        
        if (_requestProgramStop) {
            [self handleStopResponse:status];
        }
        else if (_requestProgramStart) {
            [self handleStartResponse:status];
        }
        else if (_editingProgram) {
            [self handleEditResponse:status];
        }
        else {
            NSLog(@"Unknown command response sent to Program Request Manager");
        }
    }
    else {
        NSLog(@"Unrecognised command sent to program request manager");
    }
}

- (void)startNotificationListeners:(CBPeripheral *)focusDevice
{
    [focusDevice setNotifyValue:true forCharacteristic:_cm.actualCurrent];
    [focusDevice setNotifyValue:true forCharacteristic:_cm.activeModeDuration];
    [focusDevice setNotifyValue:true forCharacteristic:_cm.activeModeRemainingTime];
}

#pragma mark CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Updated notification listen state to %hhd for characteristic %@",
          characteristic.isNotifying, [self loggableCharacteristicName:characteristic]);
}

- (void)peripheral:(CBPeripheral*)peripheral didUpdateValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error
{
    [super peripheral:peripheral didUpdateValueForCharacteristic:characteristic error:error];
    
    if ([FOC_CHARACTERISTIC_CONTROL_CMD_RESPONSE isEqualToString:characteristic.UUID.UUIDString]) {
        [self deserialiseCommandResponse:characteristic]; // deserialise response buffer data
    }
    else {
        if ([FOC_CHARACTERISTIC_ACTUAL_CURRENT isEqualToString:characteristic.UUID.UUIDString]) {
            int current = [FOCDeviceProgramEntity getIntegerFromBytes:characteristic.value].intValue;
            [_delegate didReceiveCurrentNotification:current];
        }
        else if ([FOC_CHARACTERISTIC_ACTIVE_MODE_DURATION isEqualToString:characteristic.UUID.UUIDString]) {
            int duration = [FOCDeviceProgramEntity getIntegerFromBytes:characteristic.value].intValue;
            [_delegate didReceiveDurationNotification:duration];
        }
        else if ([FOC_CHARACTERISTIC_ACTIVE_MODE_REMAINING_TIME isEqualToString:characteristic.UUID.UUIDString]) {
            int remainingTime = [FOCDeviceProgramEntity getIntegerFromBytes:characteristic.value].intValue;
            [_delegate didReceiveRemainingTimeNotification:remainingTime];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    [super peripheral:peripheral didWriteValueForCharacteristic:characteristic error:error];
    
    if ([FOC_CHARACTERISTIC_DATA_BUFFER isEqualToString:characteristic.UUID.UUIDString]) {
        Byte progId = _program.programId.intValue;
        Byte descId = !_hasWrittenFirstDescriptor ? FOC_PROG_DESC_FIRST : FOC_PROG_DESC_SECOND;
        
        NSData *data = [self constructCommandRequest:FOC_CMD_MANAGE_PROGRAMS subCmdId:FOC_SUBCMD_WRITE_PROG progId:progId progDescId:descId];
        
        [self.focusDevice writeValue:data forCharacteristic:_cm.controlCmdRequest type:CBCharacteristicWriteWithResponse];
    }
    else if ([FOC_CHARACTERISTIC_CONTROL_CMD_REQUEST isEqualToString:characteristic.UUID.UUIDString]) {
        // check command success & interpret
        [self.focusDevice readValueForCharacteristic:_cm.controlCmdResponse];
    }
    else {
        NSLog(@"Request manager encountered unknown characteristic write");
    }
}

@end

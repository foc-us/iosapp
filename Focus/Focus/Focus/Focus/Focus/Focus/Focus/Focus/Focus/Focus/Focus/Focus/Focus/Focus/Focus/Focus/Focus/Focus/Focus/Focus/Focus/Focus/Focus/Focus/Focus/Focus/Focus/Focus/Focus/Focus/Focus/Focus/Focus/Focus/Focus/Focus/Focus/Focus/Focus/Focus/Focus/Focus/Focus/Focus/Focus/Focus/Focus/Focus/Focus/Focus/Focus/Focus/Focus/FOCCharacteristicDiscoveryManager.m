//
//  FOCPeripheralDelegate.m
//  Focus
//
//  Created by Jamie Lynch on 09/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCCharacteristicDiscoveryManager.h"

#import "FocusConstants.h"

@implementation FOCCharacteristicDiscoveryManager

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral*)peripheral didDiscoverServices:(NSError*)error
{
    [super peripheral:peripheral didDiscoverServices:error];
    
    for (CBService *service in self.focusDevice.services) {
        
        NSMutableArray *desiredCharacteristics = [[NSMutableArray alloc] init];
        [desiredCharacteristics addObject:[CBUUID UUIDWithString:FOC_CHARACTERISTIC_CONTROL_CMD_REQUEST]];
        [desiredCharacteristics addObject:[CBUUID UUIDWithString:FOC_CHARACTERISTIC_CONTROL_CMD_RESPONSE]];
        [desiredCharacteristics addObject:[CBUUID UUIDWithString:FOC_CHARACTERISTIC_DATA_BUFFER]];
        [desiredCharacteristics addObject:[CBUUID UUIDWithString:FOC_CHARACTERISTIC_ACTUAL_CURRENT]];
        [desiredCharacteristics addObject:[CBUUID UUIDWithString:FOC_CHARACTERISTIC_ACTIVE_MODE_DURATION]];
        [desiredCharacteristics addObject:[CBUUID UUIDWithString:FOC_CHARACTERISTIC_ACTIVE_MODE_REMAINING_TIME]];
        
        [self.focusDevice discoverCharacteristics:desiredCharacteristics forService:service];
    }
}

- (void)peripheral:(CBPeripheral*)peripheral didDiscoverCharacteristicsForService:(CBService*)service error:(NSError*)error
{
    [super peripheral:peripheral didDiscoverCharacteristicsForService:service error:error];
    
    if (error == nil) {
        for (CBCharacteristic* characteristic in service.characteristics) {
            
            if ([characteristic.UUID.UUIDString isEqualToString:FOC_CHARACTERISTIC_CONTROL_CMD_REQUEST]) {
                _controlCmdRequest = characteristic;
            }
            else if ([characteristic.UUID.UUIDString isEqualToString:FOC_CHARACTERISTIC_CONTROL_CMD_RESPONSE]) {
                _controlCmdResponse = characteristic;
            }
            else if ([characteristic.UUID.UUIDString isEqualToString:FOC_CHARACTERISTIC_DATA_BUFFER]) {
                _dataBuffer = characteristic;
            }
            else if ([characteristic.UUID.UUIDString isEqualToString:FOC_CHARACTERISTIC_ACTUAL_CURRENT]) {
                _actualCurrent = characteristic;
            }
            else if ([characteristic.UUID.UUIDString isEqualToString:FOC_CHARACTERISTIC_ACTIVE_MODE_DURATION]) {
                _activeModeDuration = characteristic;
            }
            else if ([characteristic.UUID.UUIDString isEqualToString:FOC_CHARACTERISTIC_ACTIVE_MODE_REMAINING_TIME]) {
                _activeModeRemainingTime = characteristic;
            }
            else {
                NSLog(@"Characteristic manager discovered unknown characteristic");
            }
        }
    }
    
    if (_controlCmdRequest != nil && _controlCmdResponse != nil && _dataBuffer != nil) {
        [self.delegate didFinishCharacteristicDiscovery:error];
    }
}

- (void)peripheral:(CBPeripheral*)peripheral didUpdateValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error
{
    [super peripheral:peripheral didUpdateValueForCharacteristic:characteristic error:error];
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    [super peripheral:peripheral didWriteValueForCharacteristic:characteristic error:error];
}


@end

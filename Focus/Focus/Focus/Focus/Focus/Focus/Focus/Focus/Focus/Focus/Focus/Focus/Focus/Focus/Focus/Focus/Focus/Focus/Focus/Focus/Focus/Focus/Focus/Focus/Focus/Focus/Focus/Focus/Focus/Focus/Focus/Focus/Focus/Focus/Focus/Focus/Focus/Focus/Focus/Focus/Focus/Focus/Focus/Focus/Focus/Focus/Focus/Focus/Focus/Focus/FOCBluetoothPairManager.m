//
//  FOCBluetoothPairManager.m
//  Focus
//
//  Created by Jamie Lynch on 14/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCBluetoothPairManager.h"

@interface FOCBluetoothPairManager ()

@property CBCharacteristic *controlCmdRequest;

@end

@implementation FOCBluetoothPairManager

- (void)checkPairing:(CBCharacteristic *)controlCmdRequest
{
    _controlCmdRequest = controlCmdRequest;
    const unsigned char bytes[] = {FOC_CMD_MANAGE_PROGRAMS, FOC_SUBCMD_MAX_PROGRAMS, 0x00, 0x00, 0x00};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    
    [self.focusDevice writeValue:data forCharacteristic:_controlCmdRequest type:CBCharacteristicWriteWithResponse];
    NSLog(@"Checking if bluetooth paired, this may trigger a dialog");
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    [super peripheral:peripheral didWriteValueForCharacteristic:characteristic error:error];
    [_delegate didDiscoverBluetoothPairState:(error==nil) error:error];
}

@end

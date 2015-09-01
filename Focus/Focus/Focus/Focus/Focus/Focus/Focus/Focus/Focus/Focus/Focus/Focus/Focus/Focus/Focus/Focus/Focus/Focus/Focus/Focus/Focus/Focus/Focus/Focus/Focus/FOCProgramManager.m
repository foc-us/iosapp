//
//  FOCProgramManager.m
//  Focus
//
//  Created by Jamie Lynch on 08/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCProgramManager.h"

@implementation FOCProgramManager


- (id)initWithPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic;
{
    if (self = [super init]) {
        _peripheral = peripheral;
        _characteristic = characteristic;
    }
    return self;
}

- (void)requestProgramCount
{
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral*)peripheral didUpdateValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error
{
    NSLog(@"Got program value update %@", characteristic);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    NSLog(@"Got program write update %@", characteristic);
}

@end

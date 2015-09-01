//
//  FOCProgramManager.h
//  Focus
//
//  Created by Jamie Lynch on 08/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreBluetooth;
@import QuartzCore;

@interface FOCProgramManager : NSObject<CBPeripheralDelegate>

@property (readonly) CBCharacteristic *characteristic;
@property (readonly) CBPeripheral *peripheral;

- (id)initWithPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic;
- (void)requestProgramCount;

@end

//
//  FOCBleScanDelegate.h
//  Focus
//
//  Created by Jamie Lynch on 30/06/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

@import CoreBluetooth;

/**
 * Defines callbacks that will be fired when the BLE Scan finds devices
 */
@protocol FOCBleScanDelegate <NSObject>

/**
 * Called whenever a Focus Device is discovered
 */
-(void)didDiscoverFocusDevice:(CBPeripheral* )peripheral;

@end

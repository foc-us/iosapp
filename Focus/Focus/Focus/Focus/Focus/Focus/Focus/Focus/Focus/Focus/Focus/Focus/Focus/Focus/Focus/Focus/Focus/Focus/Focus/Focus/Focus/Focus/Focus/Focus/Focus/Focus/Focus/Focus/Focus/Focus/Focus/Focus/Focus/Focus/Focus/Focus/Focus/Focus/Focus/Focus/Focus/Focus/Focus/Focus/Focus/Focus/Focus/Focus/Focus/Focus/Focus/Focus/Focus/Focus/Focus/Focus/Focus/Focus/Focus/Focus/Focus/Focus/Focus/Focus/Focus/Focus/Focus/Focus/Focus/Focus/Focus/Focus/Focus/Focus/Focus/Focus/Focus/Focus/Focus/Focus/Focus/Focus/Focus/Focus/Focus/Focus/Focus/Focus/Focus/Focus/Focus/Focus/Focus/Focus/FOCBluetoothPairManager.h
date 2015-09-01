//
//  FOCBluetoothPairManager.h
//  Focus
//
//  Created by Jamie Lynch on 14/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FOCBasePeripheralManager.h"
#import "FOCBluetoothPairingDelegate.h"

/**
 * Checks whether the Focus Device is paired to the iOS device, and automatically triggers
 * a pairing dialog if not. This follows the steps of:
 *
 * 1. Writing a Control Command Request to the Focus device.
 * 2. Waiting for a response that the write request was successful.
 *
 * If the write is successful, it is assumed that the devices are paired. Otherwise iOS will provide a dialog
 * requesting that the user enter a PIN, and after a timeout will return an error. This error is assumed
 * to mean that the devices are not paired, and is passed onto the delegate.
 */
@interface FOCBluetoothPairManager : FOCBasePeripheralManager{
    __weak id<FOCBluetoothPairingDelegate> delegate_;
}

/**
 * Initiates a BLE request that checks whether a peripheral device is already paired to the iOS device.
 */
- (void)checkPairing:(CBCharacteristic *)controlCmdRequest;

@property (weak) id <FOCBluetoothPairingDelegate> delegate;

@end

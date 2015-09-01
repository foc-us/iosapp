//
//  BluetoothPairingDelegate.h
//  Focus
//
//  Created by Jamie Lynch on 24/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#ifndef Focus_FOCBluetoothPairingDelegate_h
#define Focus_FOCBluetoothPairingDelegate_h

/**
 * Delegate that provides callbacks for the Bluetooth Pairing process between the iOS app & Focus device
 */
@protocol FOCBluetoothPairingDelegate <NSObject>

/**
 * Called when it is determined whether a bluetooth device is already paired to the device or not.
 */
- (void)didDiscoverBluetoothPairState:(BOOL)paired error:(NSError *)error;

@end

#endif

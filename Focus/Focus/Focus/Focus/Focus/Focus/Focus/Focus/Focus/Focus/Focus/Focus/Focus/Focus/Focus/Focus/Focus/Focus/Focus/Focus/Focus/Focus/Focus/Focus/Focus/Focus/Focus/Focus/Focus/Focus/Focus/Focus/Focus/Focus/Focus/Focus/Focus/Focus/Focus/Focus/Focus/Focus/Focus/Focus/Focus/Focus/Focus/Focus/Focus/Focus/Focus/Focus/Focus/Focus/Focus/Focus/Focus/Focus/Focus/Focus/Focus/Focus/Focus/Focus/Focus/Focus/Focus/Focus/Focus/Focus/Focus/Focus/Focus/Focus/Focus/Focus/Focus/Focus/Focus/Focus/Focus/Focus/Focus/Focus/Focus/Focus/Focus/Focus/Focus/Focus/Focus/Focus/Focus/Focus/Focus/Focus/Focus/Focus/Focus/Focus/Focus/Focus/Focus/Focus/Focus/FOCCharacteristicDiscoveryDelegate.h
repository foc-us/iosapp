//
//  CharacteristicDiscoveryDelegate.h
//  Focus
//
//  Created by Jamie Lynch on 24/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#ifndef Focus_FOCCharacteristicDiscoveryDelegate_h
#define Focus_FOCCharacteristicDiscoveryDelegate_h

/**
 * Delegate which will be called as soon as the required characteristics & services have been discovered on the device
 */
@protocol FOCCharacteristicDiscoveryDelegate <NSObject>

/**
 * Called when all visibile BLE characteristics are discovered from the device.
 */
- (void)didFinishCharacteristicDiscovery:(NSError *) error;

@end

#endif

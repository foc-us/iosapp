//
//  FOCPeripheralDelegate.h
//  Focus
//
//  Created by Jamie Lynch on 09/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FOCBasePeripheralManager.h"
#import "FOCCharacteristicDiscoveryDelegate.h"

/**
 * Delegate which handles the discovery of services & characteristics on the Focus device.
 */
@interface FOCCharacteristicDiscoveryManager : FOCBasePeripheralManager {
    __weak id<FOCCharacteristicDiscoveryDelegate> delegate_;
}

@property (weak) id <FOCCharacteristicDiscoveryDelegate> delegate;

@property (readonly) CBCharacteristic *controlCmdResponse;
@property (readonly) CBCharacteristic *controlCmdRequest;
@property (readonly) CBCharacteristic *dataBuffer;

@property (readonly) CBCharacteristic *actualCurrent;
@property (readonly) CBCharacteristic *activeModeDuration;
@property (readonly) CBCharacteristic *activeModeRemainingTime;

@end
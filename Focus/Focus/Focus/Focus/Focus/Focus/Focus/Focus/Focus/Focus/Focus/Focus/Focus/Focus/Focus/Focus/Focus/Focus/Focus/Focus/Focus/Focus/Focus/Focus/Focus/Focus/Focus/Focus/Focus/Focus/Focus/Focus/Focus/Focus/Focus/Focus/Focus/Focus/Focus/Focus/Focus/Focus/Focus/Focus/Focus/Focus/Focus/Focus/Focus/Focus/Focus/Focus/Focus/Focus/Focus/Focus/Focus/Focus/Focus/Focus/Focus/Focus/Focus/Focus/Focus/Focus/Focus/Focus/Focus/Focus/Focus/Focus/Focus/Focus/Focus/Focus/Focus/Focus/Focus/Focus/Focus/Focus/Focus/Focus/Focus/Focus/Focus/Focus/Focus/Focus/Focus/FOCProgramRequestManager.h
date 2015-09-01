//
//  ProgramRequestManager.h
//  Focus
//
//  Created by Jamie Lynch on 10/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCBasePeripheralManager.h"
#import "FOCDeviceProgramEntity.h"
#import "FOCCharacteristicDiscoveryManager.h"
#import "FOCProgramRequestDelegate.h"

/**
 * Handles requests from the UI to start, stop, and edit programs.
 */
@interface FOCProgramRequestManager : FOCBasePeripheralManager {
    __weak id<FOCProgramRequestDelegate> delegate_;
}

@property (weak) id <FOCProgramRequestDelegate> delegate;
@property FOCCharacteristicDiscoveryManager *cm;

/**
 * Attempt to start the specified program on the device.
 */
- (void)startProgram:(FOCDeviceProgramEntity *)program;

/**
 * Attempt to stop the active program (if any) on the device.
 */
- (void)stopActiveProgram;

/**
 * Attempt to write the program to the device.
 */
- (void)writeProgram:(FOCDeviceProgramEntity *)program;

/**
 * Starts listening for notifications from the Focus device
 */
- (void)startNotificationListeners:(CBPeripheral *)focusDevice;

@end

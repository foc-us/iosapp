//
//  MaxProgramCountRequest.h
//  Focus
//
//  Created by Jamie Lynch on 09/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FOCBasePeripheralManager.h"
#import "FOCCharacteristicDiscoveryManager.h"
#import "FOCProgramSyncDelegate.h"

/**
 * Handles the initial syncing of programs from the Focus Device to the iOS device. This
 * happens as soon as a connection has been established to the Focus Device, and its
 * characteristics have been discovered. After the maximum program count is read, the process
 * follows the logic described below for each program:
 *
 * 1. Check if program status is valid, if not skip to the next program.
 * 2. Send control command response to write program descriptor[0] to the data buffer. On success,
 * read the contents of the data buffer.
 * 
 * 3. Write program descriptor[1] to the data buffer and read as before.
 * 4. Deserialise program descriptors.
 * 5. Move onto next program or notify delegate that sync has finished.
 */
@interface FOCProgramSyncManager : FOCBasePeripheralManager {
    __weak id<FOCProgramSyncDelegate> delegate_;
}

@property (weak) id <FOCProgramSyncDelegate> delegate;
@property (readonly) FOCCharacteristicDiscoveryManager *cm;

/**
 * Initialises the program sync with the given characteristics.
 */
- (void)startProgramSync:(FOCCharacteristicDiscoveryManager *)cm;

@end

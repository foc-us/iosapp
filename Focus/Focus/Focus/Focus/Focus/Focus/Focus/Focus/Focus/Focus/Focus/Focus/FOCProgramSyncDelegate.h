//
//  ProgramSyncDelegate.h
//  Focus
//
//  Created by Jamie Lynch on 24/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#ifndef Focus_FOCProgramSyncDelegate_h
#define Focus_FOCProgramSyncDelegate_h

/**
 * Delegate for callbacks when Bluetooth syncing of programs finishes
 */
@protocol FOCProgramSyncDelegate <NSObject>

/**
 * Called when a Program Sync between the iOS app and Focus device has finished.
 */
- (void)didFinishProgramSync:(NSError *) error;

@end

#endif

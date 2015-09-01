//
//  ProgramRequestDelegate.h
//  Focus
//
//  Created by Jamie Lynch on 24/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#ifndef Focus_FOCProgramRequestDelegate_h
#define Focus_FOCProgramRequestDelegate_h

/**
 * Defines callbacks that update the UI in response to changes in the program state
 */
@protocol FOCProgramRequestDelegate <NSObject>

/**
 * Called when a program either starts playing or is stopped on the Focus device.
 */
- (void)didAlterProgramState:(bool)playing error:(NSError *)error;

/**
 * Called when an edit request for a program is completed or fails.
 */
- (void)didEditProgram:(FOCDeviceProgramEntity *)program success:(bool)success;

/**
 * Called when the Focus device updates its current value via a notification.
 */
- (void)didReceiveCurrentNotification:(int)current;

/**
 * Called when the Focus device updates the duration value of a program via a notification.
 */
- (void)didReceiveDurationNotification:(int)duration;

/**
 * Called when the Focus device updates the remaining time of a program via a notification.
 */
- (void)didReceiveRemainingTimeNotification:(int)remainingTime;

@end

#endif

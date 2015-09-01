//
//  FocusDeviceApi.h
//  Focus
//
//  Created by Jamie Lynch on 30/06/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCDeviceProgramEntity.h"
#import "FOCNotificationModel.h"
#import "FocusConnectionState.h"

/**
 * Defines callbacks that will be fired when the Focus device state changes.
 * Responders should update the UI as necessary.
 */
@protocol FOCDeviceStateDelegate <NSObject>

/**
 * Called when the connection state of the Focus device to the app changes, allowing the UI
 * to response.
 */
- (void)didChangeConnectionState: (FocusConnectionState)connectionState;

/**
 * Called when the connection text that should be displayed by the UI changes due to
 * updates on the Focus device state
 */
- (void)didChangeConnectionText: (NSString *)connectionText;

/**
 * Called when the play state of a program changes on the device.
 */
- (void)programStateChanged:(bool)playing;

/**
 * Called when a program state was updated.
 */
- (void)didUpdateProgram:(FOCDeviceProgramEntity *)program;

@end

//
//  FocusConnectionState.h
//  Focus
//
//  Created by Jamie Lynch on 24/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#ifndef Focus_FocusConnectionState_h
#define Focus_FocusConnectionState_h

/**
 * The current state of the Focus Device
 */
typedef NS_ENUM(NSInteger, FocusConnectionState) {
    
    /**
     * The app is connected to the Focus device and is ready for commands.
     */
    CONNECTED,
    
    /**
     * The app is establishing a connection to the device.
     */
    CONNECTING,
    
    /**
     * The app is searching for BLE peripherals.
     */
    SCANNING,
    
    /**
     * The app is disconnected from the Focus device.
     */
    DISCONNECTED,
    
    /**
     * Bluetooth is disabled on the iOS device.
     */
    DISABLED,
    
    /**
     * The app state is currently unknown, and will be updated shortly.
     */
    UNKNOWN
};

#endif

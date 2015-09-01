//
//  ProgramMode.h
//  Focus
//
//  Created by Jamie Lynch on 24/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#ifndef Focus_ProgramMode_h
#define Focus_ProgramMode_h

/**
 * The possible program modes for the Focus device.
 */
typedef NS_ENUM(int, ProgramMode) {
    
    /**
     * Direct current
     */
    DCS,
    
    /**
     * Alternating current
     */
    ACS,
    
    /**
     * Random
     */
    RNS,
    
    /**
     * Pulse
     */
    PCS
};

#endif

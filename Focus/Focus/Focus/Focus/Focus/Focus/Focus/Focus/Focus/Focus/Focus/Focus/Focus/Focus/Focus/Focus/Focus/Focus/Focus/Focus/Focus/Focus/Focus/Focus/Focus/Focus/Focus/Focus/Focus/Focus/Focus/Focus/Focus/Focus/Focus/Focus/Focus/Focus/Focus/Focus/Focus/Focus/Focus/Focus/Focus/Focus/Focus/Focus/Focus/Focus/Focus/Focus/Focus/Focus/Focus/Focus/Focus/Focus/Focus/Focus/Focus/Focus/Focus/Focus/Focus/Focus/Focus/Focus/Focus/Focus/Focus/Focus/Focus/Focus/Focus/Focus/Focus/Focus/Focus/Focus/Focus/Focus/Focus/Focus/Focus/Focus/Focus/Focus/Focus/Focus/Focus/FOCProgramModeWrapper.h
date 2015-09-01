//
//  FOCProgramModeWrapper.h
//  Focus
//
//  Created by Jamie Lynch on 15/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FOCDeviceProgramEntity.h"

/**
 * Wrapper class which contains a ProgramMode enum value.
 */
@interface FOCProgramModeWrapper : NSObject

-(id)initWithMode:(ProgramMode) mode;

@property (readonly) ProgramMode mode;

@end

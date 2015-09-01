//
//  FOCProgramModeWrapper.m
//  Focus
//
//  Created by Jamie Lynch on 15/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCProgramModeWrapper.h"

@implementation FOCProgramModeWrapper

-(id)initWithMode:(ProgramMode) mode
{
    if (self = [super init]) {
        _mode = mode;
    }
    return self;
}

@end

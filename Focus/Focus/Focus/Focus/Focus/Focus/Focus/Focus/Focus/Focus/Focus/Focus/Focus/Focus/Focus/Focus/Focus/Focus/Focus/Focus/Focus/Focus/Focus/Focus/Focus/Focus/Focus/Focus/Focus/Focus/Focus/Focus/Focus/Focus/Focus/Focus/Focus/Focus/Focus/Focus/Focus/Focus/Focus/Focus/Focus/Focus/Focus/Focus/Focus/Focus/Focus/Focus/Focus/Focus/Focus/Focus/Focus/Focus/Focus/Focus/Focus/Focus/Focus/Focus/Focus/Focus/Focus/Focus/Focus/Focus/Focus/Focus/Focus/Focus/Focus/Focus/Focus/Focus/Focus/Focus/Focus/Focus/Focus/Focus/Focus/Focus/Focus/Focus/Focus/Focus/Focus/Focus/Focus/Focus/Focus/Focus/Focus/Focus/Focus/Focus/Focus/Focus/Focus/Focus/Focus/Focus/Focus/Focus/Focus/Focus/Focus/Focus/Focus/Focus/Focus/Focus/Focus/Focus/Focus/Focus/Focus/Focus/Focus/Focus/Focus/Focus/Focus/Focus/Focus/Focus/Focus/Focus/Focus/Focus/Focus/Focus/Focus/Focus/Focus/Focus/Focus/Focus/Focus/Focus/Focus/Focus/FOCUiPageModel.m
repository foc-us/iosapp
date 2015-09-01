//
//  FOCUiPageModel.m
//  Focus
//
//  Created by Jamie Lynch on 17/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCUiPageModel.h"

@implementation FOCUiPageModel

- (id)initWithProgram:(FOCDeviceProgramEntity *)program
{
    if (self = [super init]) {
        _program = program;
    }
    return self;
}

@end

//
//  FOCNotificationModel.m
//  Focus
//
//  Created by Jamie Lynch on 21/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCNotificationModel.h"

@implementation FOCNotificationModel

- (id)init
{
    if (self = [super init]) {
        _current = 0;
        _duration = 0;
        _remainingTime = 0;
    }
    return self;
}

@end

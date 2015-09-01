//
//  FOCNotificationModel.h
//  Focus
//
//  Created by Jamie Lynch on 21/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A model which stores the values of the most recent notifications received from
 * the focus device.
 */
@interface FOCNotificationModel : NSObject

@property int current;
@property int duration;
@property int remainingTime;

@end

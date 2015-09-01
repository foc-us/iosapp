//
//  FOCDurationPickerDelegate.h
//  Focus
//
//  Created by Jamie Lynch on 25/08/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionSheetPicker.h"


@interface FOCDurationPickerDelegate : NSObject<ActionSheetCustomPickerDelegate>

typedef void(^TimeDurationDoneBlock)(int minuteIndex, int secondIndex);

- (id)initWithIndices:(int)minutesIndex secondsIndex:(int)secondsIndex doneBlock:(TimeDurationDoneBlock)doneBlock;

@end

//
//  FOCDurationPickerDelegate.m
//  Focus
//
//  Created by Jamie Lynch on 25/08/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCDurationPickerDelegate.h"
#import "FOCDurationAttributeSetting.h"

@interface FOCDurationPickerDelegate ()

@property (nonatomic, copy) TimeDurationDoneBlock doneBlock;
@property NSArray *labelsMinutes;
@property NSArray *labelsSeconds;
@property int indexSeconds;
@property int indexMinutes;

@end

@implementation FOCDurationPickerDelegate

- (id)initWithIndices:(int)minutesIndex secondsIndex:(int)secondsIndex doneBlock:(TimeDurationDoneBlock)doneBlock
{
    if (self = [super init]) {
        _labelsMinutes = [FOCDurationAttributeSetting labelsForMinutes];
        _labelsSeconds = [FOCDurationAttributeSetting labelsForSeconds];
        _indexSeconds = secondsIndex;
        _indexMinutes = minutesIndex;
        _doneBlock = doneBlock;
    }
    return self;
}

- (void)configurePickerView:(UIPickerView *)pickerView
{
    // Override default and hide selection indicator
    pickerView.showsSelectionIndicator = NO;
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    _doneBlock(_indexMinutes, _indexSeconds);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component) {
        case 0: return [_labelsMinutes count];
        case 1: return [_labelsSeconds count];
        default:break;
    }
    return 0;
}

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return pickerView.frame.size.width / 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0: return _labelsMinutes[(NSUInteger) row];
        case 1: return _labelsSeconds[(NSUInteger) row];
        default:break;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            _indexMinutes = row;
            return;
            
        case 1:
            _indexSeconds = row;
            return;
        default:break;
    }
}

@end

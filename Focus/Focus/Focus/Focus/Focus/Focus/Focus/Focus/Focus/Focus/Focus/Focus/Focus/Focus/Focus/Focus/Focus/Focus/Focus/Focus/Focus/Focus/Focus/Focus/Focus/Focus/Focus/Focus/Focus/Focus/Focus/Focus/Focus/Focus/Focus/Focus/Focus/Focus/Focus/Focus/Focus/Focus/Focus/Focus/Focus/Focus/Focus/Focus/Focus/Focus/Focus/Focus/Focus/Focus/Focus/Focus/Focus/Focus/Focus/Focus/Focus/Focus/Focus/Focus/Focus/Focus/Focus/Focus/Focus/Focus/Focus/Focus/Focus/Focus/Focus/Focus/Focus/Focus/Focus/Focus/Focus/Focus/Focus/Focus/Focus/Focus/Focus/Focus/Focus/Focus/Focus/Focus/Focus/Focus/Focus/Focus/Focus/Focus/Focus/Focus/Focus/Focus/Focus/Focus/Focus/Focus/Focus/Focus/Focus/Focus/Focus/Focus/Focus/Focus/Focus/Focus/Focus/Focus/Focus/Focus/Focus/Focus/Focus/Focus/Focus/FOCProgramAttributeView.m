//
//  FOCProgramAttributeView.m
//  Focus
//
//  Created by Jamie Lynch on 16/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCProgramAttributeView.h"
#import "FOCPaddedLabel.h"
#import "FOCColorMap.h"

static NSString *kAttrDarkDisabled = @"#FF707070";
static NSString *kAttrDarkDefault = @"#CC404040";
static NSString *kAttrDarkPressed = @"#EE404040";
static NSString *kAttrLightDefault = @"#CCFFFFFF";
static NSString *kAttrLightPressed = @"#EEFFFFFF";

static const float kLabelWeighting = 0.63;
static const float kFontSize = 11.0;

@interface FOCProgramAttributeView ()

@property UIColor *colorDarkDefault;
@property UIColor *colorDarkPressed;
@property UIColor *colorDarkDisabled;
@property UIColor *colorLightDefault;
@property UIColor *colorLightPressed;

@property FOCPaddedLabel *keyLabel;
@property FOCPaddedLabel *valueLabel;
@property bool displayFadedText;

@end

@implementation FOCProgramAttributeView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _colorDarkDefault = [FOCColorMap colorFromString:kAttrDarkDefault];
        _colorLightDefault = [FOCColorMap colorFromString:kAttrLightDefault];
        
        _colorDarkPressed = [FOCColorMap colorFromString:kAttrDarkPressed];
        _colorLightPressed = [FOCColorMap colorFromString:kAttrLightPressed];
        
        _colorDarkDisabled = [FOCColorMap colorFromString:kAttrDarkDisabled];
        
        int width = self.frame.size.width;
        int height = self.frame.size.height;
        int valueStart = width * kLabelWeighting;
        
        CGRect keyFrame = CGRectMake(0, 0, valueStart, height);
        CGRect valueFrame = CGRectMake(valueStart, 0, width - valueStart, height);
        
        _keyLabel = [[FOCPaddedLabel alloc] initWithFrame:keyFrame];
        _valueLabel = [[FOCPaddedLabel alloc] initWithFrame:valueFrame];
        
        _keyLabel.font = [UIFont systemFontOfSize:kFontSize];
        _valueLabel.font = [UIFont systemFontOfSize:kFontSize];
        
        _valueLabel.textAlignment = NSTextAlignmentCenter;

        [self setViewColorState:false];
        
        [self addSubview:_keyLabel];
        [self addSubview:_valueLabel];
    }
    return self;
}

- (void)didTouchDown:(id)sender
{
    [self setViewColorState:true];
}

- (void)didTouchUpInside:(id)sender
{
    [self setViewColorState:false];
}

- (void)didTouchUpOutside:(id)sender
{
    [self setViewColorState:false];
}

- (void)setViewColorState:(bool)pressed
{
    _valueLabel.textColor = [UIColor blackColor];
    _keyLabel.textColor = pressed ? _colorLightPressed : _colorLightDefault;
    _keyLabel.backgroundColor = pressed ? _colorDarkPressed : _colorDarkDefault;
    _valueLabel.backgroundColor = pressed ? _colorLightPressed : _colorLightDefault;
    
    if (!pressed) {
        _valueLabel.textColor = _displayFadedText ? _colorDarkDisabled : [UIColor blackColor];
    }
    else {
        _valueLabel.textColor = _colorDarkPressed;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setViewColorState:true];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setViewColorState:false];
}

- (void)updateModel:(FOCDisplayAttributeModel *) model
{
    _keyLabel.text = model.attrLabel;
    _valueLabel.text = model.attrValue;
    _displayFadedText = [model.attrValue isEqualToString:@"OFF"];
    [self setViewColorState:false];
}

@end

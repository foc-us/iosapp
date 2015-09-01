//
//  FOCPaddedLabel.m
//  Focus
//
//  Created by Jamie Lynch on 15/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCPaddedLabel.h"

static const int kPadding = 4;

@interface FOCPaddedLabel ()

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end

@implementation FOCPaddedLabel

- (id)initWithFrame:(CGRect)frame
{   
    if (self = [super initWithFrame:frame]) {
        self.edgeInsets = UIEdgeInsetsMake(kPadding, kPadding, kPadding, kPadding);
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end

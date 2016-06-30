//
//  SideDrawerSectionHeaderView.m
//  AddressBook_07
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "SideDrawerSectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface SideDrawerSectionHeaderView ()
@property (nonatomic, strong) UILabel * label;
@end
@implementation SideDrawerSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor colorWithRed:210./255.0
                                                 green:213.0/255.0
                                                  blue:215.0/255.0
                                                 alpha:1.0]];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.bounds)-28,CGRectGetWidth(self.bounds)-30, 22)];
        
        
        if([[UIFont class] respondsToSelector:@selector(preferredFontForTextStyle:)]){
            [self.label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]];
        }
        else {
            [self.label setFont:[UIFont boldSystemFontOfSize:12.0]];
        }
        
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self.label setTextColor:[UIColor colorWithRed:53.0/255.0
                                                 green:66.0/255.0
                                                  blue:79.0/255.0
                                                 alpha:1.0]];
        [self.label setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin];
        [self addSubview:self.label];
        [self setClipsToBounds:NO];
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    [self.label setText:[self.title uppercaseString]];
}

-(void)drawRect:(CGRect)rect{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * lineColor = [UIColor colorWithRed:94.0/255.0
                                          green:97.0/255.0
                                           blue:99.0/255.0
                                          alpha:1.0];
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    
    CGContextSetLineWidth(context, 1.0);
    
    CGContextMoveToPoint(context, CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds)-.5); //start at this point
    
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds)-.5); //draw to this point
    
    CGContextStrokePath(context);
}

@end

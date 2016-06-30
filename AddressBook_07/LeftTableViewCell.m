//
//  LeftTableViewCell.m
//  AddressBook_07
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "LeftTableViewCell.h"

@implementation LeftTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryCheckmarkColor:[UIColor whiteColor]];
        
        UIView * backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        [backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        UIColor * backgroundColor;
        backgroundColor = [UIColor colorWithRed:232.0/255.0
                                          green:236.0/255.0
                                           blue:238.0/255.0
                                          alpha:1.0];
        [backgroundView setBackgroundColor:backgroundColor];
        
        [self setBackgroundView:backgroundView];
        
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setTextColor:[UIColor
                                      colorWithRed:40.0/255.0
                                      green:43.0/255.0
                                      blue:53.0/255.0
                                      alpha:1.0]];
    }
    return self;
}

-(void)updateContentForNewContentSize{
    if([[UIFont class] respondsToSelector:@selector(preferredFontForTextStyle:)]){
        [self.textLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    }
    else {
        [self.textLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    }
}


@end

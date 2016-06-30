//
//  MessageTableViewCell.m
//  AddressBook_07
//
//  Created by mac on 16/3/12.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)noteBtnAction:(UIButton *)sender
{
    NSLog(@"发短信");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.str]];
    [[UIApplication sharedApplication] openURL:url];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  MessageTableViewCell.h
//  AddressBook_07
//
//  Created by mac on 16/3/12.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iPhoneImg;
@property (weak, nonatomic) IBOutlet UILabel *callName;
@property (weak, nonatomic) IBOutlet UILabel *callNum;
@property (weak, nonatomic) IBOutlet UIButton *noteBtn;
@property (nonatomic,strong) NSString *str;

@end

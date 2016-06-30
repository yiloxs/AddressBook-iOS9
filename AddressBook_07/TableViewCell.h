//
//  TableViewCell.h
//  AddressBook_07
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (nonatomic, strong) UIColor * accessoryCheckmarkColor;
@property (nonatomic, strong) UIColor * disclosureIndicatorColor;

-(void)updateContentForNewContentSize;
@end

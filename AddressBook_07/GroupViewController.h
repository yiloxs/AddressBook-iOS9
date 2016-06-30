//
//  GroupViewController.h
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/4/19.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "MainViewController.h"

@interface GroupViewController : MainViewController
@property(nonatomic,strong)NSArray *groupArray;
@property(nonatomic,strong)NSString *groupName;
@property(nonatomic,strong)CNMutableGroup *group;
@property(nonatomic,strong)NSMutableArray *addContactsArr;
@end

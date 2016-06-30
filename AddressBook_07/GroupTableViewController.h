//
//  GroupTableViewController.h
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/4/19.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupTableViewController : UITableViewController<MFMessageComposeViewControllerDelegate>
@property(nonatomic,strong)NSMutableArray *groupArr;
@end

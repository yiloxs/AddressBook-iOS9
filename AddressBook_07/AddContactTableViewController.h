//
//  AddContactTableViewController.h
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/4/13.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddContactTableViewController : UITableViewController
{
    BOOL editing;
    NSInteger phoneInt;
    NSMutableArray *arr;
}
@property(nonatomic,strong)CNMutableContact *addContact;
@end

//
//  ContactInformationEditingTableViewController.h
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/4/13.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactInformationEditingTableViewController : UITableViewController
{
    NSInteger editingPhoneInt;
    NSMutableArray *savePhoneArr;
}
@property(nonatomic,strong)CNMutableContact *editContact;
@property(nonatomic,strong)CNMutableContact *saveContact;
@end

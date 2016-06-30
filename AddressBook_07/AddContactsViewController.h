//
//  AddContactsViewController.h
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/4/21.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddContactsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    NSArray *myContactArr;
    BOOL bl;
}
@property(nonatomic,strong) NSMutableArray *sortKeysArr;
@property(nonatomic,strong)NSMutableDictionary *dataSectionDataDic;
@property(nonatomic,strong)NSMutableArray *allKeysArray;
@property (nonatomic,strong) UITableView * myTableView;



@property (nonatomic, strong)  UIBarButtonItem *editButton;
@property (nonatomic, strong)  UIBarButtonItem *cancelButton;
@property (nonatomic, strong)  UIBarButtonItem *deleteButton;
@property (nonatomic, strong)  UIButton *editBtn;
@property (nonatomic, strong)  UIButton *cancelBtn;
@property (nonatomic, strong)  UIButton *deleteBtn;

@property (nonatomic, strong)  UIBarButtonItem  *backBarBtn;
@property (nonatomic, strong)  UIButton         *backBtn;

@property(nonatomic,strong)NSMutableArray *dataArray;

- (void)updateButtonsToMatchTableState;
- (void)dataHanding:(NSMutableArray *)arr;
@property(nonatomic,strong)CNMutableGroup *addContactsGroup;
@end

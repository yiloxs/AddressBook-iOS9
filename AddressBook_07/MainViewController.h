//
//  MainViewController.h
//  AddressBook_07
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,UISearchResultsUpdating,UIActionSheetDelegate>
{
    NSArray *myContactArr;
    BOOL bl;
}
@property (nonatomic,copy)void(^GetDerailsWithIndex)(MainViewController *mvc,NSMutableArray *derailsArr);
//@property (nonatomic,copy)void(^GetContact)(MainViewController *mvc,CNMutableContact *contact);
@property(nonatomic,strong) NSMutableArray *sortKeysArr;
@property(nonatomic,strong)NSMutableDictionary *dataSectionDataDic;
@property(nonatomic,strong)NSMutableArray *allKeysArray;
@property (nonatomic,strong) UITableView * myTableView;

//searchController
@property (strong, nonatomic)  UISearchController *searchController;

//数据源
@property (strong,nonatomic) NSMutableArray  *dataList;

@property (strong,nonatomic) NSMutableArray  *searchList;

@property (nonatomic, strong)  UIBarButtonItem *editButton;
@property (nonatomic, strong)  UIBarButtonItem *cancelButton;
@property (nonatomic, strong)  UIBarButtonItem *deleteButton;
@property (nonatomic, strong)  UIBarButtonItem *addButton;
@property (nonatomic, strong)  UIButton *editBtn;
@property (nonatomic, strong)  UIButton *cancelBtn;
@property (nonatomic, strong)  UIButton *deleteBtn;
@property(nonatomic,strong)NSMutableArray *dataArray;

- (void)updateButtonsToMatchTableState;
- (void)dataHanding:(NSMutableArray *)arr;
@end

//
//  MainViewController.m
//  AddressBook_07
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "MainViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "DataManager.h"
#import "SegmentView.h"
#import "MainTableViewCell.h"
#import "DerailsTableViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.sortKeysArr = [[NSMutableArray alloc] init];
    self.dataSectionDataDic = [[NSMutableDictionary  alloc] init];
    self.allKeysArray = [[NSMutableArray alloc] init];
    
    self.dataList = [[NSMutableArray alloc] init];
    self.searchList = [[NSMutableArray alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];
    
    AuthorizationManager *manager = [[AuthorizationManager alloc] init];
    [manager GrantedPermission];
    [manager setGetPersonBlock:^(AuthorizationManager *manager, NSMutableArray *arr)
     {
         self.dataList =[arr mutableCopy];
         self.dataArray =[arr mutableCopy];
         [self dataHanding:self.dataArray];
         [self.myTableView reloadData];
     }];
    
}
- (void)viewDidLoad {
    
    UIColor * barColor = [UIColor
                          colorWithRed:247.0/255.0
                          green:249.0/255.0
                          blue:250.0/255.0
                          alpha:1.0];
    [self.navigationController.navigationBar setBarTintColor:barColor];
    
    
    
    UIView *backView = [[UIView alloc] init];
    [backView setBackgroundColor:[UIColor colorWithRed:255.0/255.0
                                                 green:255.0/255.0
                                                  blue:255.0/255.0
                                                 alpha:1.0]];
    
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.myTableView setDelegate:self];
    [self.myTableView setDataSource:self];
    [self.view addSubview:self.myTableView];
    [self.myTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.myTableView setBackgroundView:backView];
    
    //导航栏按钮

    self.editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.editBtn.frame =CGRectMake(0, 0, 30, 30);
    [self.editBtn setTitle:@"编辑" forState:normal];
    [self.editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    self.editButton = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.cancelBtn.frame =CGRectMake(0, 0, 30, 30);
    [self.cancelBtn setTitle:@"取消" forState:normal];
    [self.cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton = [[UIBarButtonItem alloc] initWithCustomView:self.cancelBtn];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.deleteBtn.frame =CGRectMake(0, 0, 60, 30);
    [self.deleteBtn setTitle:@"删除" forState:normal];
    [self.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteButton = [[UIBarButtonItem alloc] initWithCustomView:self.deleteBtn];
    
    
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    
    NSArray *actionButtonItems = @[self.editButton,self.addButton];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    self.myTableView.allowsMultipleSelectionDuringEditing = YES;
    [self updateButtonsToMatchTableState];
    
    
    //创建UISearchController
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    _searchController.delegate = self;
    _searchController.searchResultsUpdater= self;
    
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    _searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
    _searchController.obscuresBackgroundDuringPresentation = NO;
    //隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = NO;
    
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    [_searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    // 添加 searchbar 到 headerview
    self.myTableView.tableHeaderView = _searchController.searchBar;
    [super viewDidLoad];
    [self.myTableView reloadData];
    
}
- (void)dataHanding:(NSMutableArray *)arr
{
    self.sortKeysArr =[[DataManager getDicWithData:arr] objectForKey:@"key"];
    self.dataSectionDataDic =[[DataManager getDicWithData:arr] objectForKey:@"dic"];
    self.allKeysArray = [[DataManager getDicWithData:arr] objectForKey:@"allkey"];
    [self.myTableView reloadData];
}
#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    [self updateDeleteButtonTitle];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
    }
    return cell;
}


#pragma mark - Action methods

- (void)editAction:(id)sender
{
    [self.myTableView setEditing:YES animated:YES];
     bl =YES;
    [self.myTableView reloadData];
    [self updateButtonsToMatchTableState];
}

- (void)cancelAction:(id)sender
{
    [self.myTableView setEditing:NO animated:YES];
     bl =NO;
    [self.myTableView reloadData];
    [self updateButtonsToMatchTableState];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // The user tapped one of the OK/Cancel buttons.
    if (buttonIndex == 0)
    {
        // Delete what the user selected.
        NSArray *selectedRows = [self.myTableView indexPathsForSelectedRows];
        BOOL deleteSpecificRows = selectedRows.count > 0;
        if (deleteSpecificRows)
        {
            // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
            NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
            CNMutableContact *contact =[[CNMutableContact alloc] init];
            
            for (NSIndexPath *selectionIndex in selectedRows)
            {
                [indicesOfItemsToDelete addIndex:selectionIndex.row];
               contact= [[self.dataArray objectAtIndex:selectionIndex.row] mutableCopy];
                CNSaveRequest *deleteRequest = [[CNSaveRequest alloc]init];
                CNContactStore *store = [[CNContactStore alloc]init];
                //删除联系人
                [deleteRequest deleteContact:contact];
                
                NSError *error=nil;
                [store executeSaveRequest:deleteRequest error:&error];
            }
            [self.dataArray removeObjectsAtIndexes:indicesOfItemsToDelete];
            [self.myTableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            
            for (int i=0;i<self.dataArray.count;i++)
            {
                CNMutableContact *contact =[[CNMutableContact alloc] init];
                contact= [[self.dataArray objectAtIndex:i] mutableCopy];
                CNSaveRequest *deleteRequest = [[CNSaveRequest alloc]init];
                CNContactStore *store = [[CNContactStore alloc]init];
                //删除联系人
                [deleteRequest deleteContact:contact];
                
                NSError *error=nil;
                [store executeSaveRequest:deleteRequest error:&error];
            }
            [self.dataArray removeAllObjects];
            [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        [self.myTableView setEditing:NO animated:YES];
        bl =NO;
        [self updateButtonsToMatchTableState];
        [self dataHanding:self.dataArray];
        [self.myTableView reloadData];
    }
}

- (void)deleteAction:(id)sender
{
    // Open a dialog with just an OK button.
    NSString *actionTitle;
    if (([[self.myTableView indexPathsForSelectedRows] count] == 1)) {
        actionTitle = @"你确定要删除这些联系人吗?";
    }
    else
    {
        actionTitle =@"你确定要删除全部这些联系人吗?";
    }
    
    NSString *cancelTitle = @"取消";
    NSString *okTitle =@"确认";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle
                                                             delegate:self
                                                    cancelButtonTitle:cancelTitle
                                               destructiveButtonTitle:okTitle
                                                    otherButtonTitles:nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    // Show from our table view (pops up in the middle of the table).
    [actionSheet showInView:self.view];
}

- (void)addAction:(id)sender
{
    
}


#pragma mark - Updating button state

- (void)updateButtonsToMatchTableState
{
    if (self.myTableView.editing)
    {
        NSArray *actionButtonItems1 = @[self.cancelButton,self.addButton];
        self.navigationItem.rightBarButtonItems = actionButtonItems1;
        [self updateDeleteButtonTitle];
        
        NSArray *actionButtonItems2 = @[self.cancelButton,self.deleteButton];
        self.navigationItem.rightBarButtonItems = actionButtonItems2;
    }
    else
    {
        NSArray *actionButtonItems2 = @[self.cancelButton,self.addButton];
        self.navigationItem.rightBarButtonItems = actionButtonItems2;
        if (self.dataArray.count > 0)
        {
            self.editButton.enabled = YES;
        }
        else
        {
            self.editButton.enabled = YES;
        }
        NSArray *actionButtonItems3 = @[self.editButton,self.addButton];
        self.navigationItem.rightBarButtonItems = actionButtonItems3;
    }
    
}

- (void)updateDeleteButtonTitle
{
    NSArray *selectedRows = [self.myTableView indexPathsForSelectedRows];
    
    BOOL allItemsAreSelected = selectedRows.count == self.dataArray.count;
    BOOL noItemsAreSelected = selectedRows.count == 0;
    
    if (allItemsAreSelected || noItemsAreSelected)
    {
        [self.deleteBtn setTitle:@"删除全部"forState:UIControlStateNormal];
    }
    else
    {
        NSString *titleFormatString =@"删除";
        [self.deleteBtn setTitle:[NSString stringWithFormat:titleFormatString, selectedRows.count] forState:UIControlStateNormal];
    }
}
//测试UISearchController的执行过程

- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"didPresentSearchController");
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController
{
    NSLog(@"presentSearchController");
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    self.searchList = [self.dataList mutableCopy];
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }

    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    for (NSString *searchString in searchItems) {
        
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
//      CNContact
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"_familyName"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        // friendId field matching
        
        lhs = [NSExpression expressionForKeyPath:@"_givenName"];
        rhs = [NSExpression expressionForConstantValue:searchString];
        finalPredicate = [NSComparisonPredicate
                          predicateWithLeftExpression:lhs
                          rightExpression:rhs
                          modifier:NSDirectPredicateModifier
                          type:NSContainsPredicateOperatorType
                          options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
//        ((CNPhoneNumber *)(tempConact.phoneNumbers.lastObject.value)).stringValue;
        
//        NSMutableArray *groupIdArr = [self.groupArr valueForKey:@"_identifier"];
//        NSMutableArray *groupNameArr = [self.groupArr valueForKey:@"_name"];
//        NSPredicate *p =[CNContact predicateForContactsInGroupWithIdentifier:groupIdArr[indexPath.row]];
//        NSArray *arra =[store unifiedContactsMatchingPredicate:p keysToFetch:@[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey] error:nil];
        
//        NSArray *phoneArray = [[self.searchList valueForKey:@"_phoneNumbers"] mutableCopy];
//        
//        for (int i=0; i<phoneArray.count; i++)
//        {
//            NSMutableArray *phoneArr =[[NSMutableArray alloc] init];
//            phoneArr= [phoneArray objectAtIndex:i];
//            
//            for (int j=0; j<phoneArray.count; j++)
//            {
//                
//                NSLog(@"%@",((CNPhoneNumber *)[phoneArr objectAtIndex:j]).stringValue);
//                
//            }
//            
//            //NSArray *phoneA = [phoneArr valueForKey:@"_labelVzaluePair"];
//            //CNLabeledValue *labValue =[phoneArr objectAtIndex:i];
//           // NSString *phoneStr = [[phoneA objectAtIndex:i] stringValue];
//            
//        }
        
        
        
        // at this OR predicate to our master AND predicate
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    // match up the fields of the Product object
    NSCompoundPredicate *finalCompoundPredicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    self.searchList = [[self.searchList filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    //刷新表格
    [self.myTableView reloadData];
    NSLog(@"------%@",[[self.searchList filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy]);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end

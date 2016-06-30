//
//  AddContactsViewController.m
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/4/21.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "AddContactsViewController.h"
#import "MainTableViewCell.h"
@interface AddContactsViewController ()

@end

@implementation AddContactsViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.sortKeysArr = [[NSMutableArray alloc] init];
    self.dataSectionDataDic = [[NSMutableDictionary  alloc] init];
    self.allKeysArray = [[NSMutableArray alloc] init];
    
  
    self.dataArray = [[NSMutableArray alloc] init];
    
    AuthorizationManager *manager = [[AuthorizationManager alloc] init];
    [manager GrantedPermission];
    [manager setGetPersonBlock:^(AuthorizationManager *manager, NSMutableArray *arr)
     {
         self.dataArray =[arr mutableCopy];
         [self dataHanding:self.dataArray];
         [self.myTableView reloadData];
     }];
    
    
}
- (void)viewDidLoad {
    
    [self.myTableView reloadData];
    
    
    
    
    
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
    [self.deleteBtn setTitle:@"添加" forState:normal];
    [self.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteButton = [[UIBarButtonItem alloc] initWithCustomView:self.deleteBtn];
    
    
    
    NSArray *actionButtonItems = @[self.editButton];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    self.myTableView.allowsMultipleSelectionDuringEditing = YES;
    [self updateButtonsToMatchTableState];
    
    
}
- (void)dataHanding:(NSMutableArray *)arr
{
    self.sortKeysArr =[[DataManager getDicWithData:arr] objectForKey:@"key"];
    self.dataSectionDataDic =[[DataManager getDicWithData:arr] objectForKey:@"dic"];
    self.allKeysArray = [[DataManager getDicWithData:arr] objectForKey:@"allkey"];
}
#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    [self updateDeleteButtonTitle];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateButtonsToMatchTableState];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
    }
    CNContact *tempConact = self.dataArray[indexPath.row];
    
    
    NSString *phone = ((CNPhoneNumber *)(tempConact.phoneNumbers.lastObject.value)).stringValue;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",tempConact.familyName,tempConact.givenName];
    cell.detailTextLabel.text =phone;
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
    if (buttonIndex == 0)
    {
        NSArray *selectedRows = [self.myTableView indexPathsForSelectedRows];
        BOOL deleteSpecificRows = selectedRows.count > 0;
        
        CNMutableContact *contact =[[CNMutableContact alloc] init];
        if (deleteSpecificRows)
        {
            NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
            
            
            for (NSIndexPath *selectionIndex in selectedRows)
            {
                [indicesOfItemsToDelete addIndex:selectionIndex.row];
                contact= [[self.dataArray objectAtIndex:selectionIndex.row] mutableCopy];
                CNSaveRequest *deleteRequest = [[CNSaveRequest alloc]init];
                CNContactStore *store = [[CNContactStore alloc]init];
                //添加联系人
                [deleteRequest addMember:contact toGroup:_addContactsGroup.mutableCopy];
                
                NSError *error=nil;
                [store executeSaveRequest:deleteRequest error:&error];
            }
        }
        else
        {
            for (int i=0; i<self.dataArray.count; i++)
            {
                contact= [self.dataArray[i] mutableCopy];
                CNSaveRequest *deleteRequest = [[CNSaveRequest alloc]init];
                CNContactStore *store = [[CNContactStore alloc]init];
                //添加全部联系人
                [deleteRequest addMember:contact toGroup:_addContactsGroup.mutableCopy];
                
                NSError *error=nil;
                [store executeSaveRequest:deleteRequest error:&error];
            }


        }
        
        // Exit editing mode after the deletion.
        [self.myTableView setEditing:NO animated:YES];
        bl =NO;
        [self updateButtonsToMatchTableState];
    }
}

- (void)deleteAction:(id)sender
{
    // Open a dialog with just an OK button.
    NSString *actionTitle;
    if (([[self.myTableView indexPathsForSelectedRows] count] == 1)) {
        actionTitle = @"你确定要添加这些联系人吗?";
    }
    else
    {
        actionTitle =@"你确定要添加全部这些联系人吗?";
    }
    
    NSString *cancelTitle = @"Cancel";
    NSString *okTitle =@"OK";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle
                                                             delegate:self
                                                    cancelButtonTitle:cancelTitle
                                               destructiveButtonTitle:okTitle
                                                    otherButtonTitles:nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    // Show from our table view (pops up in the middle of the table).
    [actionSheet showInView:self.view];
}


#pragma mark - Updating button state

- (void)updateButtonsToMatchTableState
{
    if (self.myTableView.editing)
    {
        // Show the option to cancel the edit.
        NSArray *actionButtonItems1 = @[self.cancelButton];
        self.navigationItem.rightBarButtonItems = actionButtonItems1;
        //self.navigationItem.rightBarButtonItem = self.cancelButton;
        
        [self updateDeleteButtonTitle];
        
        // Show the delete button.
        NSArray *actionButtonItems2 = @[self.cancelButton,self.deleteButton];
        self.navigationItem.rightBarButtonItems = actionButtonItems2;
        //self.navigationItem.leftBarButtonItem = self.deleteButton;
    }
    else
    {
        // Not in editing mode.
        //self.navigationItem.leftBarButtonItem = self.addButton;
        NSArray *actionButtonItems2 = @[self.cancelButton];
        self.navigationItem.rightBarButtonItems = actionButtonItems2;
        // Show the edit button, but disable the edit button if there's nothing to edit.
        if (self.dataArray.count > 0)
        {
            self.editButton.enabled = YES;
        }
        else
        {
            self.editButton.enabled = YES;
        }
        NSArray *actionButtonItems3 = @[self.editButton];
        self.navigationItem.rightBarButtonItems = actionButtonItems3;
        //self.navigationItem.rightBarButtonItem = self.editButton;
    }
    
}

- (void)updateDeleteButtonTitle
{
    // Update the delete button's title, based on how many items are selected
    NSArray *selectedRows = [self.myTableView indexPathsForSelectedRows];
    
    BOOL allItemsAreSelected = selectedRows.count == self.dataArray.count;
    BOOL noItemsAreSelected = selectedRows.count == 0;
    
    if (allItemsAreSelected || noItemsAreSelected)
    {
        [self.deleteBtn setTitle:@"添加全部"forState:UIControlStateNormal];
    }
    else
    {
        NSString *titleFormatString =@"添加";
        [self.deleteBtn setTitle:[NSString stringWithFormat:titleFormatString, selectedRows.count] forState:UIControlStateNormal];
    }
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

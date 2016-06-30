//
//  GroupViewController.m
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/4/19.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "GroupViewController.h"
#import "MainTableViewCell.h"
#import "DerailsTableViewController.h"
#import "AddContactsViewController.h"
@interface GroupViewController ()

@end

@implementation GroupViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.dataArray = [self.groupArray mutableCopy];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =self.groupName;
    self.dataList =[self.groupArray mutableCopy];
    
}

- (void)addAction:(id)sender
{
    AddContactsViewController *acvc = [[AddContactsViewController alloc] init];
    acvc.addContactsGroup = self.group ;
    [self.navigationController pushViewController:acvc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active)
    {
        return self.searchList.count;
    }
    else
    {
        return self.dataArray.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
    }
    if (self.searchController.active)
    {
        CNContact *tempConact = self.searchList[indexPath.row];
        
        
        NSString *phone = ((CNPhoneNumber *)(tempConact.phoneNumbers.lastObject.value)).stringValue;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",tempConact.familyName,tempConact.givenName];
        cell.detailTextLabel.text =phone;
        
    }
    else{
        
        CNContact *tempConact = self.dataArray[indexPath.row];
        
        
        NSString *phone = ((CNPhoneNumber *)(tempConact.phoneNumbers.lastObject.value)).stringValue;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",tempConact.familyName,tempConact.givenName];
        cell.detailTextLabel.text =phone;
    }
    return cell;
}

//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateButtonsToMatchTableState];
    if (bl==NO)
    {
        CNMutableContact *contact=[[CNMutableContact alloc] init];
        
       
        if (self.searchController.active)
        {
            contact = self.searchList[indexPath.row];
            
        }
        else
        {
            contact = self.dataArray[indexPath.row];
        }
        self.searchController.active=NO;
        DerailsTableViewController *dtvc = [[DerailsTableViewController alloc] init];
        if(contact)
        {
            dtvc.derailsContact=[contact mutableCopy];
        }
        [self.navigationController pushViewController:dtvc animated:YES];
    }
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // The user tapped one of the OK/Cancel buttons.
    if (buttonIndex == 0)
    {
        // Delete what the user selected.
        NSArray *selectedRows = [self.myTableView indexPathsForSelectedRows];
        BOOL deleteSpecificRows = selectedRows.count > 0;
        CNMutableContact *contact =[[CNMutableContact alloc] init];
        if (deleteSpecificRows)
        {
            // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
            NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
            
            
            for (NSIndexPath *selectionIndex in selectedRows)
            {
                [indicesOfItemsToDelete addIndex:selectionIndex.row];
                contact= [[self.dataArray objectAtIndex:selectionIndex.row] mutableCopy];
                CNSaveRequest *deleteRequest = [[CNSaveRequest alloc]init];
                CNContactStore *store = [[CNContactStore alloc]init];
                //删除联系人
                [deleteRequest removeMember:contact fromGroup:self.group];
                
                NSError *error=nil;
                [store executeSaveRequest:deleteRequest error:&error];
            }
            // Delete the objects from our data model.
           
            [self.dataArray removeObjectsAtIndexes:indicesOfItemsToDelete];
            
            // Tell the tableView that we deleted the objects
            [self.myTableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            for (int i=0; i<self.dataArray.count; i++)
            {
                contact= [self.dataArray[i] mutableCopy];
                CNSaveRequest *deleteRequest = [[CNSaveRequest alloc]init];
                CNContactStore *store = [[CNContactStore alloc]init];
                //删除联系人
                [deleteRequest removeMember:contact fromGroup:self.group];
                
                NSError *error=nil;
                [store executeSaveRequest:deleteRequest error:&error];
            }
            // Delete everything, delete the objects from our data model.
            [self.dataArray removeAllObjects];
            
            // Tell the tableView that we deleted the objects.
            // Because we are deleting all the rows, just reload the current table section
            [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        // Exit editing mode after the deletion.
        [self.myTableView setEditing:NO animated:YES];
        bl =NO;
        [self updateButtonsToMatchTableState];
        [self dataHanding:self.dataArray];
        [self.myTableView reloadData];
    }
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    // 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了删除");
        
        
        
        NSArray *arr = [self.dataSectionDataDic objectForKey:self.sortKeysArr[indexPath.section]];
        CNMutableContact *contact=[[CNMutableContact alloc] init];
        contact = [arr[indexPath.row] mutableCopy];
        
        // 1. 更新数据
        
        [[self.dataSectionDataDic objectForKey:self.sortKeysArr[indexPath.section]] removeObjectAtIndex:indexPath.row];
        
        CNSaveRequest *deleteRequest = [[CNSaveRequest alloc]init];
        CNContactStore *store = [[CNContactStore alloc]init];
        //删除联系人
        [deleteRequest deleteContact:contact];
        
        NSError *error=nil;
        [store executeSaveRequest:deleteRequest error:&error];
        
        
        // 2. 更新UI
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
    
    return @[deleteRowAction];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

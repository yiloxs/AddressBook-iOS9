//
//  ContactsViewController.m
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/4/19.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "ContactsViewController.h"
#import "MainTableViewCell.h"
#import "AddContactTableViewController.h"
#import "DerailsTableViewController.h"

#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    //抽屉按钮
    [self setupLeftMenuButton];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"所有联系人";
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void)addAction:(id)sender
{
    AddContactTableViewController *actvc = [[AddContactTableViewController alloc] init];
    [self.navigationController pushViewController:actvc animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //NSLog(@"sortKeysArr.count   %lu",(unsigned long)self.sortKeysArr.count);
    if (self.searchController.active)
    {
        return 1;
    }
    else if (bl==YES)
    {
        return 1;
    }
    else
    {
        return self.sortKeysArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active)
    {
        return self.searchList.count;
    }
    else if (bl==YES)
    {
        return self.dataArray.count;
    }
    else
    {
        NSString *key = self.sortKeysArr.count>0 ? self.sortKeysArr[section]:@"";
        NSArray *arr = [self.dataSectionDataDic objectForKey:key];
        //NSLog(@"arr.count   %lu",(unsigned long)arr.count);
        return arr.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    else if (bl==YES)
    {
        CNContact *tempConact = self.dataArray[indexPath.row];
        
        
        NSString *phone = ((CNPhoneNumber *)(tempConact.phoneNumbers.lastObject.value)).stringValue;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",tempConact.familyName,tempConact.givenName];
        cell.detailTextLabel.text =phone;
    }
    else{
        NSMutableArray *arr =[self.dataSectionDataDic objectForKey:self.sortKeysArr[indexPath.section]];
        CNContact *tempConact = arr[indexPath.row];
        
        
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
        NSArray *arr = [self.dataSectionDataDic objectForKey:self.sortKeysArr[indexPath.section]];
        CNMutableContact *contact=[[CNMutableContact alloc] init];
        
        if (self.searchController.active)
        {
            contact = self.searchList[indexPath.row];
        }
        else
        {
            contact = arr[indexPath.row];
        }
        self.searchController.active=NO;
        DerailsTableViewController *dtvc = [[DerailsTableViewController alloc] init];
        if(contact)
        {
            dtvc.derailsContact=contact;
        }
        [self.navigationController pushViewController:dtvc animated:YES];
    }
    
    
}

//区名
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.searchController.active)
    {
        return nil;
    }
    else if (bl==YES)
    {
        return nil;
    }
    else 
    {
        NSString *key = [self.allKeysArray objectAtIndex:section];
        //NSLog(@"key   %@",key);
        return key;
    }
    
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //NSLog(@"sortKeysArr   %@",self.sortKeysArr);
    if (self.searchController.active) {
        return nil;
    }
    else if (bl==YES)
    {
        return nil;
    }
    else{
        return self.sortKeysArr;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    //NSLog(@"[sortKeysArr indexOfObject:title]    %lu",(unsigned long)[self.sortKeysArr indexOfObject:title]);
    if (self.searchController.active) {
        return 1;
    }
    else if (bl==YES)
    {
        return 1;
    }
    else{
        return [self.sortKeysArr indexOfObject:title];
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
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
@end

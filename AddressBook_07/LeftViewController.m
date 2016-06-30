//
//  LeftViewController.m
//  AddressBook_07
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "LeftViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerController.h"

#import "ContactsViewController.h"
#import "GroupTableViewController.h"

#import "LeftTableViewCell.h"
#import "SideDrawerSectionHeaderView.h"
#import "BackupViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"菜单";
    self.drawerWidths = @[@(160),@(200),@(240),@(280),@(320)];
    //阴影效果
    [self.mm_drawerController setShowsShadow:YES];
    //抽屉关闭时的动画
    [self FullCloseAnimation];
    //打开和关闭抽屉的手势(默认全部打开)
    
    //打开抽屉是否能与中心视图交互
    self.mm_drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeNone;
    
    //打开抽屉后pan手势 抽屉拉伸效果(默认开启)
    self.mm_drawerController.shouldStretchDrawer=YES;
    //抽屉宽度
    [self.mm_drawerController
     setMaximumLeftDrawerWidth:[self.drawerWidths[2] floatValue]
     animated:YES
     completion:^(BOOL finished) {
         NSLog(@"设置抽屉宽度为320");
     }];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    UIColor * tableViewBackgroundColor;
    tableViewBackgroundColor = [UIColor colorWithRed:210.0/255.0
                                               green:213.0/255.0
                                                blue:215.0/255.0
                                               alpha:1.0];
    [self.tableView setBackgroundColor:tableViewBackgroundColor];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:225.0/255.0
                                                  green:225.0/255.0
                                                   blue:225.0/255.0
                                                  alpha:1.0]];
    
    UIColor * barColor = [UIColor colorWithRed:201.0/255.0
                                         green:204.0/255.0
                                          blue:206.0/255.0
                                         alpha:1.0];
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
        [self.navigationController.navigationBar setBarTintColor:barColor];
    }
    else {
        [self.navigationController.navigationBar setTintColor:barColor];
    }
    
    
    NSDictionary *navBarTitleDict;
    UIColor * titleColor = [UIColor colorWithRed:55.0/255.0
                                           green:70.0/255.0
                                            blue:77.0/255.0
                                           alpha:1.0];
    navBarTitleDict = @{NSForegroundColorAttributeName:titleColor};
    [self.navigationController.navigationBar setTitleTextAttributes:navBarTitleDict];
    
    
}
//抽屉关闭动画
-(void)FullCloseAnimation
{
    ContactsViewController * center = [[ContactsViewController alloc] init];
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:center];
    
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    switch (section) {
        case 0:
            return 2;
        case 1:
            return 1;
            
        default:
            return 0;
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return @"联系人&群组";
        case 1:
            return @"工具";
        default:
            return nil;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SideDrawerSectionHeaderView * headerView;
    headerView =  [[SideDrawerSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 30.0)];
    [headerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [headerView setTitle:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[LeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
    }
    //[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    switch (indexPath.section)
    {
        case 0:
            if(indexPath.row == 0)
            {
                [cell.textLabel setText:@"群组"];
                [cell.imageView setImage:[UIImage imageNamed:@"menu_groups@2x"]];
            }
            else if(indexPath.row == 1)
            {
                [cell.textLabel setText:@"联系人"];
                [cell.imageView setImage:[UIImage imageNamed:@"menu_contacts@2x"]];
            }
            break;

        case 1:
        {
            switch (indexPath.row)
            {

                case 0:
                {
                    [cell.textLabel setText:@"联系人备份"];
                    [cell.imageView setImage:[UIImage imageNamed:@"menu_contacts_backup@2x"]];
                }
                    break;

                default:
                    break;
            }
            break;
        }

        default:
            break;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    GroupTableViewController *gtvc = [[GroupTableViewController alloc] init];
                    UINavigationController * cen = (UINavigationController*)self.mm_drawerController.centerViewController;
                    [cen pushViewController:gtvc animated:YES];
                    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                    }];
                    
                    break;
                }
                case 1:
                {
                    ContactsViewController *cvc = [[ContactsViewController alloc] init];
                    UINavigationController * cen = (UINavigationController*)self.mm_drawerController.centerViewController;
                    [cen pushViewController:cvc animated:YES];
                    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                    }];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    BackupViewController *bvc = [[BackupViewController alloc] init];
                    UINavigationController * cen = (UINavigationController*)self.mm_drawerController.centerViewController;
                    [cen pushViewController:bvc animated:YES];
                    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                    }];
                    break;
                }
                    
            }
        }
            
        default:
            break;
    }
}
@end

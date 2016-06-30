//
//  DerailsTableViewController.m
//  AddressBook_07
//
//  Created by mac on 16/3/12.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "DerailsTableViewController.h"
#import "DerailsTableViewCell.h"
#import "SideDrawerSectionHeaderView.h"

#import "MessageTableViewCell.h"
#import "PacketTableViewCell.h"
#import "DeleteTableViewCell.h"
#import "MainViewController.h"

#import "ContactInformationEditingTableViewController.h"

@interface DerailsTableViewController ()

@end

@implementation DerailsTableViewController
-(void)viewWillAppear:(BOOL)animated
{
     [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //CNContactViewController * con = [CNContactViewController viewControllerForContact:_derailsContact];
//    CNContactViewController * con = [CNContactViewController viewControllerForUnknownContact:_derailsContact];
//    [self presentViewController:con animated:YES completion:nil];
    
    
    //self.derailsContact =[[CNMutableContact alloc] init];
    
    

    
    //    MainViewController *mvc = [[MainViewController alloc] init];
    //    [mvc setGetContact:^(MainViewController *mvc, CNMutableContact *contact)
    //    {
    //        NSLog(@"-----%@",contact);
    //        self.derailsContact =contact;
    //    }];
    
    
    UIView *backView = [[UIView alloc] init];
    
    [backView setBackgroundColor:[UIColor colorWithRed:248.0/255.0
                                                 green:248.0/255.0
                                                  blue:248.0/255.0
                                                 alpha:1.0]];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView setBackgroundView:backView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DerailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"derailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"maessageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PacketTableViewCell" bundle:nil] forCellReuseIdentifier:@"packetCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DeleteTableViewCell" bundle:nil] forCellReuseIdentifier:@"deleteCell"];
    //导航栏按钮
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame =CGRectMake(0, 0, 30, 30);
    [btn setTitle:@"编辑" forState:normal];
    [btn addTarget:self action:@selector(editing) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editingItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = editingItem;
}
- (void)editing
{
    ContactInformationEditingTableViewController *cietvc = [[ContactInformationEditingTableViewController alloc] init];
    cietvc.editContact =self.derailsContact;
    [self.navigationController pushViewController:cietvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
        case 1:
            return self.derailsContact.phoneNumbers.count;
        case 2:
            return 1;
        case 3:
            return 1;
        case 4:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section==0)
    {
        DerailsTableViewCell *derailsCell = [tableView dequeueReusableCellWithIdentifier:@"derailsCell" forIndexPath:indexPath];
        if (derailsCell.derailsImg.image ==nil)
        {
            derailsCell.derailsImg.image = [UIImage imageNamed:@"contact_icon"];
        }
        else
        {
            derailsCell.derailsImg.image = [UIImage imageWithData:self.derailsContact.imageData];
        }
        NSString *name = [NSString stringWithFormat:@"%@   %@",self.derailsContact.familyName,self.derailsContact.givenName];
        derailsCell.nameLab.text = name;
        return derailsCell;
    }

   else if (indexPath.section==1)
    {
        MessageTableViewCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"maessageCell" forIndexPath:indexPath];
        //NSString *phone = ((CNPhoneNumber *)(_derailsContact.phoneNumbers.lastObject.value)).stringValue;
        
        messageCell.callName.text  =@"Phone";
        messageCell.callNum.text=((CNPhoneNumber *)self.derailsContact.phoneNumbers[indexPath.row].value).stringValue;
        messageCell.str=((CNPhoneNumber *)self.derailsContact.phoneNumbers[indexPath.row].value).stringValue;
        return messageCell;
    }
    
    else if (indexPath.section == 2)
    {
        PacketTableViewCell *packetCell = [tableView dequeueReusableCellWithIdentifier:@"packetCell" forIndexPath:indexPath];
        packetCell.packetName.text=@"家人";
        return packetCell;
    }
    else if (indexPath.section ==3)
    {
        DeleteTableViewCell *deleteCell = [tableView dequeueReusableCellWithIdentifier:@"deleteCell" forIndexPath:indexPath];
        return deleteCell;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
         NSLog(@"打电话");
        
           NSString *phoneStr =((CNPhoneNumber *)self.derailsContact.phoneNumbers[indexPath.row].value).stringValue;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneStr]];
            [[UIApplication sharedApplication] openURL:url];
    }
    else if(indexPath.section==2)
    {
        NSLog(@"群组");
    }
    else if(indexPath.section==3)
    {
        NSLog(@"删除");
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"你确认要删除该联系人吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果选中的是取消，那么就返回，不做任何操作
    if (0==buttonIndex)
    {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    //删除联系人
    CNMutableContact *contact =[self.derailsContact mutableCopy];
    CNSaveRequest *deleteRequest = [[CNSaveRequest alloc]init];
    CNContactStore *store = [[CNContactStore alloc]init];
    [deleteRequest deleteContact:contact];
    NSError *error=nil;
    [store executeSaveRequest:deleteRequest error:&error];
    if (![store executeSaveRequest:deleteRequest error:&error]) {
        if (error)
        {
            NSLog(@"error = %@", error.description);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        return 100;
    }
    else
    {
        return 44;
    }
}

@end

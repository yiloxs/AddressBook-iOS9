//
//  GroupTableViewController.m
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/4/19.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "GroupTableViewController.h"
#import "GroupTableViewCell.h"
#import "GroupViewController.h"

#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
@interface GroupTableViewController ()

@end

@implementation GroupTableViewController
-(void)viewWillAppear:(BOOL)animated
{
    CNContactStore * store = [[CNContactStore alloc]init];
    
    self.groupArr=[NSMutableArray arrayWithArray:[store groupsMatchingPredicate:nil error:nil]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"群组";
    
    //抽屉按钮
    [self setupLeftMenuButton];
    
    

    [self.tableView registerNib:[UINib nibWithNibName:@"GroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"groupCell"];
    
    //导航栏按钮
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroupBtnItem)];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn.frame =CGRectMake(0, 0, 30, 30);
//    [btn setTitle:@"编辑" forState:normal];
//    [btn addTarget:self action:@selector(editingGroup) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *editingItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    
//    NSArray *actionButtonItems = @[editingItem,addItem];
    self.navigationItem.rightBarButtonItem=addItem;
}
-(void)addGroupBtnItem
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"新建群组" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
}
//2.修改数据，完成刷新操作
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //1.修改模型
     //如果选中的是取消，那么就返回，不做任何操作
     if (0==buttonIndex)
     {
         return;
     }
    //拿到当前弹窗中的文本数据（已经修改后的数据）
    UITextField *textField=[alertView textFieldAtIndex:0];
    CNMutableGroup *group = [[CNMutableGroup alloc] init];
    if (textField.text.length == 0)
    {
        return;
    }
    else
    {
        group.name=textField.text;
    // 1. 更新数据
    
    
        CNSaveRequest *addRequest = [[CNSaveRequest alloc]init];
        CNContactStore *store = [[CNContactStore alloc]init];
    //添加分组
    
        [addRequest addGroup:group toContainerWithIdentifier:0];
        [store executeSaveRequest:addRequest error:nil];
        [self.tableView reloadData];
    
  
    //重新获取数据
    self.groupArr=[NSMutableArray arrayWithArray:[store groupsMatchingPredicate:nil error:nil]];
    [self.tableView reloadData];
    }

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
 
    NSMutableArray *groupNameArr = [self.groupArr valueForKey:@"_name"];
    cell.textLabel.text = groupNameArr[indexPath.row];
    return cell;

 }
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CNContactStore * store = [[CNContactStore alloc]init];
    NSMutableArray *groupIdArr = [self.groupArr valueForKey:@"_identifier"];
    NSMutableArray *groupNameArr = [self.groupArr valueForKey:@"_name"];
    NSPredicate *p =[CNContact predicateForContactsInGroupWithIdentifier:groupIdArr[indexPath.row]];
    NSArray *arra =[store unifiedContactsMatchingPredicate:p keysToFetch:@[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey] error:nil];
    GroupViewController *gvc = [[GroupViewController alloc] init];
    gvc.groupArray=[arra mutableCopy];
    gvc.groupName = groupNameArr[indexPath.row];
    gvc.group = [self.groupArr[indexPath.row] mutableCopy];
    [self.navigationController pushViewController:gvc animated:YES];
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    // 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了删除");
        CNMutableGroup *group = [[CNMutableGroup alloc] init];
        group = [self.groupArr[indexPath.row] mutableCopy];
        // 1. 更新数据
        [self.groupArr removeObjectAtIndex:indexPath.row];
        
        CNSaveRequest *deleteRequest = [[CNSaveRequest alloc]init];
        CNContactStore *store = [[CNContactStore alloc]init];
        //删除分组
        
        [deleteRequest deleteGroup:group];
        [store executeSaveRequest:deleteRequest error:nil];
        
        
        // 2. 更新UI
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"群发短信" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了群发短信");
        CNContactStore * store = [[CNContactStore alloc]init];
        NSMutableArray *groupIdArr = [self.groupArr valueForKey:@"_identifier"];
        NSPredicate *p =[CNContact predicateForContactsInGroupWithIdentifier:groupIdArr[indexPath.row]];
        NSArray *arra =[store unifiedContactsMatchingPredicate:p keysToFetch:@[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey] error:nil];
        CNContact *contact = [[CNContact alloc] init];
        NSMutableArray *phoneArr = [[NSMutableArray alloc] init];
        for (int i=0; i<arra.count; i++)
        {
            contact =[arra objectAtIndex:i];
            [phoneArr addObject:((CNPhoneNumber *)(contact.phoneNumbers.lastObject.value)).stringValue];
        }
        
        [self showMessageView:phoneArr];
    }];
    rowAction.backgroundColor=[UIColor blueColor];
    
    return @[deleteRowAction,rowAction];
    
}
-(void)showMessageView:(NSArray *)phones
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}


//MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    switch(result){
        caseMessageComposeResultSent:
            //信息传送成功
            
            break;
        caseMessageComposeResultFailed:
            //信息传送失败
            break;
        caseMessageComposeResultCancelled:
            //信息被用户取消传送
            break;
        default:
            break;
    }
}
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

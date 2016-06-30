//
//  AddContactTableViewController.m
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/4/13.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "AddContactTableViewController.h"
#import "AddDerailsTableViewCell.h"
#import "AddPhoneTableViewCell.h"
@interface AddContactTableViewController ()

@end

@implementation AddContactTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView setEditing:YES animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"新建联系人";
    _addContact = [[CNMutableContact alloc] init];
    arr= [[NSMutableArray alloc] init];
    phoneInt =1;
    UIView *backView = [[UIView alloc] init];
    
    [backView setBackgroundColor:[UIColor colorWithRed:248.0/255.0
                                                 green:248.0/255.0
                                                  blue:248.0/255.0
                                                 alpha:1.0]];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView setBackgroundView:backView];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AddDerailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"addDerailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddPhoneTableViewCell" bundle:nil] forCellReuseIdentifier:@"addPhoneCell"];
    
    editing=YES;
    //导航栏按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame =CGRectMake(0, 0, 30, 30);
    [btn setTitle:@"保存" forState:normal];
    [btn addTarget:self action:@selector(editing) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = deleteItem;
}
- (void)editing
{
    [self.view endEditing:YES];
    //初始化方法
    if (_addContact.givenName ==nil&&_addContact.familyName==nil&&_addContact.phoneNumbers==nil)
    {
        NSLog(@"信息为空!");
    }
    else{
        
        CNSaveRequest * saveRequest = [[CNSaveRequest alloc]init];
        //添加联系人
        [saveRequest addContact:_addContact toContainerWithIdentifier:nil];
        CNContactStore * store = [[CNContactStore alloc]init];
        [store executeSaveRequest:saveRequest error:nil];
    }
}
-  (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)  {
        return NO;  /*第一行不能进行编辑*/
    }
    else if(indexPath.section==1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /** 不同的行, 可以设置不同的编辑样式, 编辑样式是一个枚举类型 */
    if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            return UITableViewCellEditingStyleInsert;
        }
        else
        {
           return UITableViewCellEditingStyleDelete;
        }
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}
- (void)tableView :(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        /**   点击 删除 按钮的操作 */
        if (editingStyle == UITableViewCellEditingStyleDelete) { /**< 判断编辑状态是删除时. */
            
            /** 1. 更新数据源(数组): 根据indexPaht.row作为数组下标, 从数组中删除数据. */
            //[self.arr removeObjectAtIndex:indexPath.row];
            phoneInt = phoneInt-1;
            /** 2. TableView中 删除一个cell. */
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
        
        /** 点击 +号 图标的操作. */
        if (editingStyle == UITableViewCellEditingStyleInsert&&phoneInt<=2) { /**< 判断编辑状态是插入时. */
            /** 1. 更新数据源:向数组中添加数据. */
            phoneInt = phoneInt+1;
            
            /** 2. TableView中插入一个cell. */
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
    }
   
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
            return phoneInt;
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
        AddDerailsTableViewCell *addDerailsCell = [tableView dequeueReusableCellWithIdentifier:@"addDerailsCell" forIndexPath:indexPath];
        if (addDerailsCell.addImageBtn.imageView.image ==nil)
        {
            addDerailsCell.addImageBtn.imageView.image = [UIImage imageNamed:@"contact_icon"];
        }
        else
        {
            //调用相册图片
        }
        [addDerailsCell.addFamilyNameTextField addTarget:self action:@selector(addFamilyNameTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        [addDerailsCell.addGivenNameTextField addTarget:self action:@selector(addGivenNameTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        
        return addDerailsCell;
    }
    
    else if (indexPath.section==1)
    {
        
            AddPhoneTableViewCell *addPhoneCell = [tableView dequeueReusableCellWithIdentifier:@"addPhoneCell" forIndexPath:indexPath];
            addPhoneCell.addPhoneTextField.tag =phoneInt;
            [addPhoneCell.addPhoneTextField addTarget:self action:@selector(addPhoneTextFieldEditChanged:) forControlEvents:UIControlEventEditingDidEnd];
            return addPhoneCell;
        
    }
    
    
    return cell;
}

//获取输入的手机号
- (void)addPhoneTextFieldEditChanged:(UITextField *)textField

{
    
    if (textField.tag==1)
    {
        CNLabeledValue *numberiPhone = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:textField.text]];
        [arr addObject:numberiPhone];
        
    }
     if (textField.tag==2)
    {
        CNLabeledValue *mobileiPhone = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:textField.text]];
        [arr addObject:mobileiPhone];
    }
     if (textField.tag==3)
    {
        CNLabeledValue *mainiPhone = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMain value:[CNPhoneNumber phoneNumberWithStringValue:textField.text]];
        [arr addObject:mainiPhone];
    }
    _addContact.phoneNumbers=arr;

}
//获取输入的姓
-(void)addFamilyNameTextFieldEditChanged:(UITextField *)textField
{
    _addContact.familyName = textField.text;
}
//获取输入的名
-(void)addGivenNameTextFieldEditChanged:(UITextField*)textField
{
    _addContact.givenName =textField.text;
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

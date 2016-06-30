//
//  ContactInformationEditingTableViewController.m
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/4/13.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "ContactInformationEditingTableViewController.h"
#import "EditingDerailsTableViewCell.h"
#import "EditMessageTableViewCell.h"
#import "AddTableViewCell.h"
@interface ContactInformationEditingTableViewController ()

@end

@implementation ContactInformationEditingTableViewController
//-(void)viewWillAppear:(BOOL)animated
//{
//    /*使tableView出于编辑状态*/
//    [self.tableView setEditing:YES animated:YES];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    editingPhoneInt=10;
    _saveContact = [self.editContact mutableCopy];
    savePhoneArr = [[NSMutableArray alloc] init];
    UIView *backView = [[UIView alloc] init];
    
    [backView setBackgroundColor:[UIColor colorWithRed:248.0/255.0
                                                 green:248.0/255.0
                                                  blue:248.0/255.0
                                                 alpha:1.0]];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView setBackgroundView:backView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EditingDerailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"editDerailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EditMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"editMaessageCell"];
    
    //导航栏按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame =CGRectMake(0, 0, 30, 30);
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editingItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = editingItem;
}

//-  (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section==0)  {
//        return NO;  /*第一行不能进行编辑*/
//    }
//    else if(indexPath.section==1)
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    /** 不同的行, 可以设置不同的编辑样式, 编辑样式是一个枚举类型 */
//    if (indexPath.section == 1)
//    {
//        if(indexPath.row == 0)
//        {
//            return UITableViewCellEditingStyleInsert;
//        }
//        else
//        {
//            return UITableViewCellEditingStyleDelete;
//        }
//    }
//    else
//    {
//        return UITableViewCellEditingStyleDelete;
//    }
//}
//- (void)tableView :(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 1)
//    {
//        /**   点击 删除 按钮的操作 */
//        if (editingStyle == UITableViewCellEditingStyleDelete)
//        { /**< 判断编辑状态是删除时. */
//            
//            /** 1. 更新数据源(数组): 根据indexPaht.row作为数组下标, 从数组中删除数据. */
//            //[self.arr removeObjectAtIndex:indexPath.row];
//            editingPhoneInt = editingPhoneInt-1;
//            /** 2. TableView中 删除一个cell. */
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
//        }
//        if (indexPath.row==1)
//        {
//            /** 点击 +号 图标的操作. */
//            if (editingStyle == UITableViewCellEditingStyleInsert&&editingPhoneInt<=11)
//            { /**< 判断编辑状态是插入时. */
//                /** 1. 更新数据源:向数组中添加数据. */
//                editingPhoneInt = editingPhoneInt+1;
//                
//                /** 2. TableView中插入一个cell. */
//                [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                
//            }
//        }
//        
//    }
//    
//}
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
        
            return self.editContact.phoneNumbers.count;

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
        EditingDerailsTableViewCell *editingDerailsCell = [tableView dequeueReusableCellWithIdentifier:@"editDerailsCell" forIndexPath:indexPath];
        if (editingDerailsCell.editImageBtn.imageView.image ==nil)
        {
            editingDerailsCell.editImageBtn.imageView.image = [UIImage imageNamed:@"contact_icon"];
        }
        else
        {
            editingDerailsCell.editImageBtn.imageView.image = [UIImage imageWithData:self.editContact.imageData];
        }
        editingDerailsCell.editGivenNameTextField.text =self.editContact.givenName;
        editingDerailsCell.editFamilyNameTextField.text = self.editContact.familyName;
        
        
        [editingDerailsCell.editGivenNameTextField addTarget:self action:@selector(editingGivenNameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [editingDerailsCell.editFamilyNameTextField addTarget:self action:@selector(editingFamilyNameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        return editingDerailsCell;
    }
    
    else if (indexPath.section==1)
    {
        int i=10;
        EditMessageTableViewCell *editMessageCell = [tableView dequeueReusableCellWithIdentifier:@"editMaessageCell" forIndexPath:indexPath];
        editMessageCell.editPhoneTextField.tag =i;
        editMessageCell.editPhoneTextField.text=((CNPhoneNumber *)self.editContact.phoneNumbers[indexPath.row].value).stringValue;
        [editMessageCell.editPhoneTextField addTarget:self action:@selector(editingPhoneTextFieldChanged:) forControlEvents:UIControlEventEditingDidEnd];
        return editMessageCell;
       
    }
    
    
    return cell;
}
//获取输入的手机号
- (void)editingPhoneTextFieldChanged:(UITextField *)textField
{
    
    if (textField.tag==10)
    {
        CNLabeledValue *numberiPhone = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:textField.text]];
        NSLog(@"%@",numberiPhone);
        [savePhoneArr addObject:numberiPhone];
        
    }
    if (textField.tag==11)
    {
        
        CNLabeledValue *mobileiPhone = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:textField.text]];
        NSLog(@"%@",mobileiPhone);
        [savePhoneArr addObject:mobileiPhone];
    }
    if (textField.tag==12)
    {
        CNLabeledValue *mainiPhone = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMain value:[CNPhoneNumber phoneNumberWithStringValue:textField.text]];
        NSLog(@"%@",mainiPhone);
        [savePhoneArr addObject:mainiPhone];
    }
    _saveContact.phoneNumbers=savePhoneArr;
    
}
-(void)editingFamilyNameTextFieldChanged:(UITextField *)textField
{
    //编辑联系人名
    NSLog(@"%@",textField.text);
    _saveContact.familyName = textField.text;
}
-(void)editingGivenNameTextFieldChanged:(UITextField *)textField
{
    //编辑联系人姓
    NSLog(@"%@",textField.text);
    _saveContact.givenName = textField.text;
}
- (void)edit
{
    [self.view endEditing:YES];
    
//    let updatedContact = contact.mutableCopy()
//    let newEmail = CNLabeledValue(label: CNLabelHome,
//                                  value: "john@example.com")
//    updatedContact.emailAddresses.append(newEmail)
//    let saveRequest = CNSaveRequest()
//    saveRequest.updateContact(updatedContact)
//    try store.executeSaveRequest(saveRequest)
    
    CNSaveRequest * saveRequest = [[CNSaveRequest alloc]init];
    
    NSLog(@"%@",_saveContact);
    //更新联系人
    [saveRequest updateContact:_saveContact];
    CNContactStore * store = [[CNContactStore alloc]init];
    NSError *error=nil;
    [store executeSaveRequest:saveRequest error:&error];
    if (![store executeSaveRequest:saveRequest error:&error])
    {
        if (error)
        {
            NSLog(@"error = %@", error.description);
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        NSLog(@"打电话");
    }
    else if(indexPath.section==2)
    {
        NSLog(@"群组");
    }
    else if(indexPath.section==3)
    {
        NSLog(@"删除");
    }
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

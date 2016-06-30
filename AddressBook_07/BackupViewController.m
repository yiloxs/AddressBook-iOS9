//
//  BackupViewController.m
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/5/25.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "BackupViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

#import "RestoreTableViewController.h"
#import "AuthorizationManager.h"
@interface BackupViewController ()

@end

@implementation BackupViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    //抽屉按钮
    [self setupLeftMenuButton];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    AuthorizationManager *manager = [[AuthorizationManager alloc] init];
    [manager GrantedPermission];
    [manager setGetPersonBlock:^(AuthorizationManager *manager, NSMutableArray *arr)
     {
         contactSArr =(NSArray*)[arr copy];
     }];
    contactSArr =[[NSArray alloc] init];
    self.title=@"备份&还原";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backupContacts:(UIButton *)sender
{
    //获取系统时间
    NSDate * senddate=[NSDate date];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"HHmmss"];
    
    NSString * locationString=[dateformatter stringFromDate:senddate];
    //获取系统时间
    
    NSCalendar * cal=[NSCalendar currentCalendar];
    
    NSUInteger unitFlags=NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    
    NSInteger year=[conponent year];
    
    NSInteger month=[conponent month];
    
    NSInteger day=[conponent day];
    
    NSString * nsDateString= [NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
    dateStr =[NSString stringWithFormat:@"%@%@",nsDateString,locationString];
    NSString *str = [NSString stringWithFormat:@"系统将根据您的联系人列表备份到以下文件:%@.vcf",dateStr];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}
- (IBAction)restoreContacts:(UIButton *)sender
{
    RestoreTableViewController *rtvc=[[RestoreTableViewController alloc] init];
    [self.navigationController pushViewController:rtvc animated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果选中的是取消，那么就返回，不做任何操作
    if (0==buttonIndex)
    {
        return;
        
    }
    else
    {
        //备份
        [self testRun];
    }
}
-(void)testRun {
    //读取本地电话本
    
    
    if(contactSArr) {
        //存储vcf文件到本地路径
        NSString* filePath = [self saveVCF:contactSArr];
        NSLog(@"%@",filePath);
//        if(filePath) {
//            //从本地路径读取vcf文件
//            [self loadVCF:filePath];
//        }
    }
}

-(NSString*)saveVCF:(NSArray *)contacts {
    NSString *str = @"";
    NSData *vcards =([CNContactVCardSerialization dataWithContacts:(contacts) error:nil]);
    
    str = [[NSString alloc] initWithData:vcards encoding:NSUTF8StringEncoding];
    
    NSLog(@"save vcf str %@",str);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *folderPath = [paths objectAtIndex:0];
    NSString *filePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.vcf",dateStr]];
    [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return filePath;
}

-(void)loadVCF:(NSString*)filePath {
    
    NSString* str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"load vcf str %@",str);
    
    NSData *vcardData = ([str dataUsingEncoding:NSUTF8StringEncoding]);
    //ABRecordRef ref = ABAddressBookCopyDefaultSource((__bridge ABAddressBookRef)(store));
    
    //NSArray *contacts = ABPersonCreatePeopleInSourceWithVCardRepresentation(ref, vcardData);
    NSArray *contacts =[CNContactVCardSerialization contactsWithData:vcardData error:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

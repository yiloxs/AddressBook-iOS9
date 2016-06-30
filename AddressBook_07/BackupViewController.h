//
//  BackupViewController.h
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/5/25.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackupViewController : UIViewController
{
    NSString *dateStr;
    NSArray *contactSArr;
}
@property(nonatomic,strong)NSString *path;
@end

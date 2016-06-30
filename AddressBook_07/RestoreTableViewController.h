//
//  RestoreTableViewController.h
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/5/26.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RestoreTableViewController : UITableViewController<UIDocumentInteractionControllerDelegate>
{
    NSMutableArray *filePathArray;
    NSFileManager *localFileManager;
    
}
@property(nonatomic,strong)NSString *filePath;
@property(nonatomic,strong)UIDocumentInteractionController *documentController;;
@end

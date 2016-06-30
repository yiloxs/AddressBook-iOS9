//
//  AuthorizationManager.h
//  AddressBook_07
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorizationManager : NSObject
@property(nonatomic,copy)void(^getPersonBlock)(AuthorizationManager *manager,NSMutableArray *personArr);
-(void)GrantedPermission;
@end

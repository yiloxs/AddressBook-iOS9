//
//  AuthorizationManager.m
//  AddressBook_07
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "AuthorizationManager.h"

@implementation AuthorizationManager
-(void)GrantedPermission
{
    NSMutableArray *contactArr = [[NSMutableArray alloc] init];
    CNContactStore *cStore = [[CNContactStore alloc]init];
    [cStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted)
        {
            NSError *error =nil;
            CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactIdentifierKey,CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPreviousFamilyNameKey,CNContactNameSuffixKey,CNContactImageDataKey,CNContactThumbnailImageDataKey,CNContactImageDataAvailableKey,CNContactPhoneNumbersKey, [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],[CNContactViewController descriptorForRequiredKeys]]];
            request.predicate=nil;
            [cStore enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact *contact, BOOL *stop)
             {
                 [contactArr addObject:contact];
                 if (error)
                 {
                     NSLog(@"获取信息错误:%@",error);
                 }
             }];
            if (_getPersonBlock)
            {
                _getPersonBlock(self,contactArr);
            }
        }
        else
        {
            NSLog(@"授权失败!");
        }
        
        if(error)
        {
            NSLog(@"授权错误信息:%@",error);
        }
    }];
}





@end

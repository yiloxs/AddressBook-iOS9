//
//  DataManager.m
//  AddressBook_07
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
+(NSDictionary*)getDicWithData:(NSArray*)dataArr
{
    
    NSMutableDictionary * dataSectionDataDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *allKeysArray = [[NSMutableArray alloc] init];
    
    for (CNContact *model in dataArr)
    {
        NSString *sectionKey = @"";
        
        
        /**
         *  将姓名转换成拼音,并取名字拼音的首字母 ,得不到拼音首字母的归类至?
         */
        NSString *pingYinName = [self transformMandarinToLatin:model.familyName];
        sectionKey =  pingYinName.length>0?[pingYinName substringToIndex:1]:@"?";
        
        /**
         *  将首字母转换成大写
         */
        sectionKey = [sectionKey uppercaseString];
        
        NSMutableArray *sectionArray = [dataSectionDataDic objectForKey:sectionKey];
        
        
        if (sectionArray == nil)
        {
            [allKeysArray addObject:sectionKey];
            sectionArray = [[NSMutableArray alloc] init];
            [dataSectionDataDic setObject:sectionArray forKey:sectionKey];
        }
        [sectionArray addObject:model];
    }
    
    NSArray *sortKeysArr = [allKeysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:sortKeysArr,@"key",dataSectionDataDic,@"dic",allKeysArray,@"allkey",nil];
    return dic;
}

+ (NSString*) transformMandarinToLatin:(NSString *)string {
    if ([string length]==0) return string;
    
    NSMutableString *preString = [string mutableCopy];
    CFStringTransform((CFMutableStringRef)preString, NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)preString, NULL,kCFStringTransformStripDiacritics, NO);
    if ([[(NSString *)string substringToIndex:1] compare:@"长"] ==NSOrderedSame) {
        [preString replaceCharactersInRange:NSMakeRange(0, 5)withString:@"chang"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"沈"] ==NSOrderedSame) {
        [preString replaceCharactersInRange:NSMakeRange(0, 4)withString:@"shen"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"厦"] ==NSOrderedSame) {
        [preString replaceCharactersInRange:NSMakeRange(0, 3)withString:@"xia"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"地"] ==NSOrderedSame) {
        [preString replaceCharactersInRange:NSMakeRange(0, 3)withString:@"di"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"重"] ==NSOrderedSame) {
        [preString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
    return preString;
}
@end

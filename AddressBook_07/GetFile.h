//
//  GetFile.h
//  AddressBook_07
//
//  Created by 闫凌宵 on 16/5/31.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetFile : NSObject
/**
 *  @brief  获得指定目录下，指定后缀名的文件列表
 *
 *  @param  type    文件后缀名
 *  @param  dirPath     指定目录
 *
 *  @return 文件名列表
 */
+(NSArray *) getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath;
@end

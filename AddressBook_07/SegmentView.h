//
//  SegmentView.h
//  AddressBook_07
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentView : UIView
/**
 *  创建一个弹出下拉控件
 *
 *  @param frame      尺寸
 *  @param selectData 选择控件的数据源
 *  @param action     点击回调方法
 *  @param animate    是否动画弹出
 */
+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSMutableArray *)selectData
                                       images:(NSMutableArray *)images
                                       action:(void(^)(NSInteger index))action
                                     animated:(BOOL)animate;

/**
 *  手动隐藏
 */
+ (void)hiden;
@end

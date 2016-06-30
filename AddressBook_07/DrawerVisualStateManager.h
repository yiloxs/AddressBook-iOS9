//
//  DrawerVisualStateManager.h
//  AddressBook_07
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 hngydx. All rights reserved.
//
//单例类
#import <Foundation/Foundation.h>
#import "MMDrawerVisualState.h"
typedef NS_ENUM(NSInteger, DrawerAnimationType){
    DrawerAnimationTypeNone,
    DrawerAnimationTypeSlide,
    DrawerAnimationTypeSlideAndScale,
    DrawerAnimationTypeSwingingDoor,
    DrawerAnimationTypeParallax,
};
@interface DrawerVisualStateManager : NSObject
@property (nonatomic,assign) DrawerAnimationType leftDrawerAnimationType;

+ (DrawerVisualStateManager *)sharedManager;

-(MMDrawerControllerDrawerVisualStateBlock)drawerVisualStateBlockForDrawerSide:(MMDrawerSide)drawerSide;@end

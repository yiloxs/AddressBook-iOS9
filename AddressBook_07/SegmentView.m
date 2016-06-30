//
//  SegmentView.m
//  AddressBook_07
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "SegmentView.h"
#define  LeftView 10.0f
#define  TopToView 10.0f
@interface  SegmentView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSArray *selectData;
@property (nonatomic,copy) void(^action)(NSInteger index);
@property (nonatomic,copy) NSArray * imagesData;
@end



SegmentView * backgroundView;
UITableView * tableView;
@implementation SegmentView
- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSMutableArray *)selectData
                                       images:(NSMutableArray *)images
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate
{
    if (backgroundView != nil) {
        [SegmentView hiden];
    }
    UIWindow *win = [[[UIApplication sharedApplication] windows] lastObject];
    
    backgroundView = [[SegmentView alloc] initWithFrame:win.bounds];
    backgroundView.action = action;
    //backgroundView.imagesData = images ;
    backgroundView.selectData = selectData;
    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0.1];
    [win addSubview:backgroundView];
    
    // TAB
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(  [UIScreen mainScreen].bounds.size.width - 60 , 60.0 -  15.0 * selectData.count , frame.size.width, 30 * selectData.count) style:0];
    tableView.dataSource = backgroundView;
    //    tableView.transform =  CGAffineTransformMakeScale(0.5, 0.5);
    tableView.delegate = backgroundView;
    tableView.layer.cornerRadius = 10.0f;
    // 定点
    tableView.layer.anchorPoint = CGPointMake(1.0, 0);
    tableView.transform =CGAffineTransformMakeScale(0.0001, 0.0001);
    
    tableView.rowHeight = 30;
    [win addSubview:tableView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    //    tableView.layer.anchorPoint = CGPointMake(100, 64);
    
    
    if (animate == YES) {
        backgroundView.alpha = 0;
        //        tableView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 70, frame.size.width, 40 * selectData.count);
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 0.5;
            tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
}
+ (void)tapBackgroundClick
{
    [SegmentView hiden];
}
+ (void)hiden
{
    if (backgroundView != nil) {
        
        [UIView animateWithDuration:0.3 animations:^{
            //            UIWindow * win = [[[UIApplication sharedApplication] windows] firstObject];
            //            tableView.frame = CGRectMake(win.bounds.size.width - 35 , 64, 0, 0);
            tableView.transform = CGAffineTransformMakeScale(0.000001, 0.0001);
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
            [tableView removeFromSuperview];
            tableView = nil;
            backgroundView = nil;
        }];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"SegmentTableViewSelectIdentifier";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:Identifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:Identifier];
    }
    
    
    cell.imageView.image = [UIImage imageNamed:self.imagesData[indexPath.row]];
    cell.textLabel.text = _selectData[indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:10]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.action) {
        self.action(indexPath.row);
    }
    [SegmentView hiden];
}

#pragma mark 绘制三角形
//- (void)setNeedsDisplay
//
//{
//
//    //    [colors[serie] setFill];
//    // 设置背景色
//    [[UIColor whiteColor] set];
//    //拿到当前视图准备好的画板
//
//    CGContextRef  context = UIGraphicsGetCurrentContext();
//
//    //利用path进行绘制三角形
//
//    CGContextBeginPath(context);//标记
//    CGFloat location = [UIScreen mainScreen].bounds.size.width;
//    CGContextMoveToPoint(context,
//                         location -  LeftView - 10, 70);//设置起点
//
//    CGContextAddLineToPoint(context,
//                            location - 2*LeftView - 10 ,  60);
//
//    CGContextAddLineToPoint(context,
//                            location - TopToView * 3 - 10, 70);
//
//    CGContextClosePath(context);//路径结束标志，不写默认封闭
//
//    [[UIColor whiteColor] setFill];  //设置填充色
//
//    [[UIColor whiteColor] setStroke]; //设置边框颜色
//
//    CGContextDrawPath(context,
//                      kCGPathFillStroke);//绘制路径path
//
//    //    [self setNeedsDisplay];
//}



@end

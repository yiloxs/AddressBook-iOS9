//
//  TableViewCell.m
//  AddressBook_07
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "TableViewCell.h"
@interface DisclosureIndicator : UIView
@property (nonatomic, strong) UIColor * color;
@end

@implementation DisclosureIndicator
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor clearColor]];
        [self setColor:[UIColor whiteColor]];
    }
    return self;
}
@end

@interface CustomCheckmark : UIControl
@property (nonatomic, strong) UIColor * color;
@end
@implementation CustomCheckmark

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:NO];
    }
    return self;
}
@end
@implementation TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryCheckmarkColor:[UIColor whiteColor]];
        [self setDisclosureIndicatorColor:[UIColor whiteColor]];
        [self updateContentForNewContentSize];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}
- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    [super setAccessoryType:accessoryType];
    if(accessoryType == UITableViewCellAccessoryCheckmark){
        CustomCheckmark * customCheckmark = [[CustomCheckmark alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [customCheckmark setColor:self.accessoryCheckmarkColor];
        [self setAccessoryView:customCheckmark];
    }
    else if(accessoryType == UITableViewCellAccessoryDisclosureIndicator){
        DisclosureIndicator * di = [[DisclosureIndicator alloc] initWithFrame:CGRectMake(0, 0, 10, 14)];
        [di setColor:self.disclosureIndicatorColor];
        [self setAccessoryView:di];
    }
    else {
        [self setAccessoryView:nil];
    }
}

-(void)prepareForReuse{
    [super prepareForReuse];
    [self updateContentForNewContentSize];
}

-(void)updateContentForNewContentSize{
    
}
- (void)awakeFromNib
{
    // Initialization code
}



@end

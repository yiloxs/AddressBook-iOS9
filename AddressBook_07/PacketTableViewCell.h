//
//  PacketTableViewCell.h
//  AddressBook_07
//
//  Created by mac on 16/3/12.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PacketTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *packetImg;
@property (weak, nonatomic) IBOutlet UILabel *packetLab;
@property (weak, nonatomic) IBOutlet UILabel *packetName;

@end

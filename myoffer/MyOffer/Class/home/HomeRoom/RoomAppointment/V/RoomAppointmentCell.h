//
//  RoomAppointmentCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/9.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYLXGroup.h"
@interface RoomAppointmentCell : UITableViewCell
@property(nonatomic,strong)WYLXGroup *item;
@property(nonatomic,strong)NSArray *items;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;

+ (instancetype)cellWithTableview:(UITableView *)tableView;

@end

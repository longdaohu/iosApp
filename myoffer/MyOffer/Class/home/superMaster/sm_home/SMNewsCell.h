//
//  SMNewsCell.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMNewsCell : UITableViewCell

typedef void(^SMNewsCellBlock)(NSString *message_id,BOOL show_push);

@property(nonatomic,strong)NSArray *newsGroup;

@property(nonatomic,copy)SMNewsCellBlock actionBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end

//
//  ServiceProtocalSectionHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/31.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceProtocalItem.h"

typedef void(^sprotocalSectionBlock)(void);
@interface ServiceProtocalSectionHeaderView : UIView
@property(nonatomic,copy)sprotocalSectionBlock actionBlock;
@property(nonatomic,strong)ServiceProtocalItem *item;

+ (instancetype)tableView:(UITableView *)tableView sectionViewWithProtocalItem:(ServiceProtocalItem *)item;

@end

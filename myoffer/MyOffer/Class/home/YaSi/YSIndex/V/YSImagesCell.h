//
//  YSImagesCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/29.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YasiCatigoryItemModel;

@interface YSImagesCell : UITableViewCell
@property(nonatomic,assign)NSInteger current_index;
@property(nonatomic,strong)YasiCatigoryItemModel *item;


@end

//
//  YsCatigoryItemCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YasiCatigoryItemModel;

@interface YsCatigoryItemCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property(nonatomic,strong)YasiCatigoryItemModel *item;
@property(nonatomic,assign)BOOL cell_selected;

@end

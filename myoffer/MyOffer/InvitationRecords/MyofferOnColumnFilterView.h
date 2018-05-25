//
//  MyofferOnColumnFilterView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyofferOnColumnFilterView : UIView
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,assign)CGFloat topView_h;
@property(nonatomic,copy)void(^filterBlock)(NSInteger tb_tag,NSInteger index_row);

@end

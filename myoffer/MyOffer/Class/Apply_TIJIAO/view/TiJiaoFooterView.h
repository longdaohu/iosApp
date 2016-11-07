//
//  TiJiaoFooterView.h
//  myOffer
//
//  Created by xuewuguojie on 16/4/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TiJiaoFooterView;
@protocol TiJiaoFooterViewDelegate <NSObject>
-(void)TiJiaoFooterView:(TiJiaoFooterView *)footerView didClick:(UIButton *)sender;
@end

@interface TiJiaoFooterView : UIView
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIButton *descriptionBtn;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,weak)id<TiJiaoFooterViewDelegate> delegate;

+ (instancetype)footerViewWithContent:(NSString *)content;

@end

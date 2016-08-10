//
//  XWGJBanView.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BanViewBlock)(UIButton *);
@interface XWGJBanView : UIView
//按钮背景View
@property(nonatomic,strong)UIView  *SelectView;

@property(nonatomic,strong)UIButton  *lastBtn;
//蓝色图片
@property(nonatomic,strong)UIImageView  *FocusView;

@property(nonatomic,copy)BanViewBlock actionBlock;

@property(nonatomic,strong)NSArray *itemImages;

-(void)selectBtnClick:(UIButton *)sender;

@end

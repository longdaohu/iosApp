//
//  TiJiaoFooterView.h
//  myOffer
//
//  Created by xuewuguojie on 16/4/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TiJiaoFooterViewBlock)(UIButton *sender);

@interface TiJiaoFooterView : UIView
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)TiJiaoFooterViewBlock actionBlock;

+ (instancetype)footerWithContent:(NSString *)content actionBlock:(TiJiaoFooterViewBlock)actionBlock;

@end

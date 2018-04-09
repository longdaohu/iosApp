//
//  serviceProtocolVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/9.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceItemFrame.h"

typedef NS_ENUM(NSInteger,protocolViewType) {
    protocolViewTypeDefault = 0,
    protocolViewTypeList,
    protocolViewTypeHtml
};

@interface serviceProtocolVC : UIViewController
@property(nonatomic,strong)ServiceItemFrame *itemFrame;
@property(nonatomic,assign)protocolViewType type;
/*
 * showProtocalViw 显示
 * HidenProtocalView 不显示
 */
//- (void)protocalShow:(BOOL)show;
//- (void)productDescriptionShow:(BOOL)show;

- (void)pageWithHiden:(BOOL)hiden;

@end


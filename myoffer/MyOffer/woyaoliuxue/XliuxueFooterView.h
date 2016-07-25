//
//  XliuxueFooterView.h
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FooterButtonTypePipei,
    FooterButtonTypeLiuxue
} FooterButtonType;



@class XliuxueFooterView;
@protocol XliuxueFooterViewDelegate <NSObject>
-(void)liuxueFooterView:(XliuxueFooterView *)footerView didClick:(FooterButtonType)type;

@end

@interface XliuxueFooterView : UIView
@property(nonatomic,weak)id<XliuxueFooterViewDelegate> delegate;
+(instancetype)footerView;

@end

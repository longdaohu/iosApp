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
typedef void(^WYLXfooterBlock)(UIButton *sender);
@interface WYLXFooterView : UIView
@property(nonatomic,copy)WYLXfooterBlock actionBlock;
+(instancetype)footerViewWithBlock:(WYLXfooterBlock)actionBlock;

@end

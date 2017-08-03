//
//  SMHotSectionFooterView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/24.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SMHotSectionFooterBlock)();
@interface SMHotSectionFooterView : UIView

@property(nonatomic,copy)NSString *moreTitle;

@property(nonatomic,strong)UIColor *moreColor;

@property(nonatomic,strong)UIColor *moreTitleColor;

@property(nonatomic,copy)SMHotSectionFooterBlock actionBlock;

+ (instancetype)footerWithTitle:(NSString *)title action:(SMHotSectionFooterBlock)action;

@end

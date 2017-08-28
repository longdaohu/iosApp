//
//  UpgradeTipsView.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UpgradeTipsViewBlock)();
@interface UpgradeFooterView : UIView
//提示字符串
@property(nonatomic,copy)NSString *tipStr;

@property(nonatomic,copy)UpgradeTipsViewBlock actionBlock;

+ (instancetype)footViewWithContent:(NSString *)content;

@end

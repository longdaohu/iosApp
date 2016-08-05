//
//  UpgradeTipsView.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UpgradeTipsViewBlock)();
@interface UpgradeTipsView : UIView
@property(nonatomic,copy)NSString *tipStr;                  //提示字符串
@property(nonatomic,assign)CGFloat contentHeigt;            //提示框高
@property(nonatomic,copy)UpgradeTipsViewBlock actionBlock;
@end

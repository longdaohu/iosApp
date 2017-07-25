//
//  HomeSectionHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XUButton.h"

typedef void(^HomeSectionHeaderViewBlock)();
@interface HomeSectionHeaderView : UIView
@property(nonatomic,copy)HomeSectionHeaderViewBlock actionBlock;
@property(nonatomic,copy)NSString *accessory_title;
@property(nonatomic,assign)CGFloat contentFontSize;

//更多按钮隐藏
- (void)arrowButtonHiden:(BOOL)hiden;

+(instancetype)sectionHeaderViewWithTitle:(NSString *)title;

@end

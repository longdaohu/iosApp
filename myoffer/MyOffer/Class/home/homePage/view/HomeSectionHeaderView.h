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
@property (strong, nonatomic) UIButton *moreBtn;
+(instancetype)sectionHeaderViewWithTitle:(NSString *)title;
- (void)moreButtonHidenNo;

@end

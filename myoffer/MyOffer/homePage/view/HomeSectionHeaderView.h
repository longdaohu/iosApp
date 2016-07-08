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
@property (strong, nonatomic) UILabel *TitleLab;
@property (strong, nonatomic)XUButton  *moreBtn;
@property(nonatomic,copy)HomeSectionHeaderViewBlock actionBlock;
+(instancetype)view;

@end

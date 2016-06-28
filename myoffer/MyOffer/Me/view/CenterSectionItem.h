//
//  CenterSectionItem.h
//  myOffer
//
//  Created by xuewuguojie on 16/6/20.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CenterSectionItemBlock)(UIButton *sender);
@interface CenterSectionItem : UIView
@property(nonatomic,copy)CenterSectionItemBlock actionBlack;
@property(nonatomic,copy)NSString *count;
+(instancetype)viewWithIcon:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle;
@end

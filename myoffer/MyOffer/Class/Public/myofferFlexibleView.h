//
//  myofferFlexibleView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/8/8.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^flexViewBlock)(CGFloat image_hight);
@interface myofferFlexibleView : UIView

@property(nonatomic,copy)NSString *image_url;
@property(nonatomic,copy)NSString *image_name;
@property(nonatomic,strong)UIImageView *coverView;


+ (instancetype)flexibleViewWithFrame:(CGRect)frame;

- (void)flexWithContentOffsetY:(CGFloat)offsetY;

@end

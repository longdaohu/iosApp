//
//  RoomNavigationView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/14.
//  Copyright © 2018年 UVIC. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface RoomNavigationView : UIView

@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)UIView *rightView;
@property(nonatomic,assign)CGFloat  alpha_height;
@property(nonatomic,strong)void(^acitonBlock)(BOOL isBackButton);

+ (instancetype)nav;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end


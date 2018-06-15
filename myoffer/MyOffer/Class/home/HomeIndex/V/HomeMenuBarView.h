//
//  HomeMenuBarView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/14.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMenuBarView : UIView
@property(nonatomic,strong)NSArray *titles;
//+ (instancetype)menuInitWithFrame:(CGRect)frame clickButton:(void(^)(NSInteger index))click;
+ (instancetype)menuInitWithTitles:(NSArray *)titles clickButton:(void(^)(NSInteger index))click;

- (void)initFirstResponse;
- (void)menuDidScrollWithScrollView:(UIScrollView *)scrollView;
- (void)menuDidDidEndDeceleratingWithScrollView:(UIScrollView *)scrollView;

@end

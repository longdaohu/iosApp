//
//  RoomBannerView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/9/20.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomBannerView : UIView
@property(nonatomic,copy)void(^actionBlock)(NSInteger index);
- (void)makeBannerWithImages:(NSArray *)imageGroup bannerSize:(CGSize)itemSize;

@end

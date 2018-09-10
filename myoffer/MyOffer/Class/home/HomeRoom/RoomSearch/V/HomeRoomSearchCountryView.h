//
//  HomeRoomSearchCountryView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/6.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeRoomSearchCountryView : UIView
@property(nonatomic,assign,readonly)BOOL coverIsHiden;
@property(nonatomic,strong)void(^actionBlock)(NSDictionary *item);
- (void)show;
- (void)hide;

@end

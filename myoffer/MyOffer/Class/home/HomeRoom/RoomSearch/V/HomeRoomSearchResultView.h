//
//  HomeRoomSearchResultView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/15.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeRoomSearchResultView : UIView

+ (instancetype)viewWithHidenCompletion:(void (^)(BOOL finished))completion;

@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)void(^actionBlock)(NSString *item_id);
- (void)show;
- (void)hide;

@end


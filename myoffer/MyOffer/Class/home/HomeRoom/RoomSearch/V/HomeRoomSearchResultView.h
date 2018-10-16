//
//  HomeRoomSearchResultView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/15.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomSearchResultItemModel.h"

@interface HomeRoomSearchResultView : UIView
@property(nonatomic,strong)NSArray *items;
//当前搜索页是否显示
@property(nonatomic,assign,readonly)BOOL state;
@property(nonatomic,strong)void(^actionBlock)(RoomSearchResultItemModel *);

+ (instancetype)resultView;
- (void)show;
- (void)hide;
- (void)showError:(NSString *)error;
- (void)clearAllData;

@end


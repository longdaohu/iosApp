//
//  TKChatListView.h
//  EduClass
//
//  Created by admin on 2018/6/6.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKBaseView.h"
@interface TKOldChatListView : UIView

//- (id)initWithFrame:(CGRect)frame chatController:(NSString *)chatController;

- (instancetype)initWithFrame:(CGRect)frame userRole:(UserType)role;

- (void)reloadData;

//接收聊天消息
- (void)messageReceived:(NSString *)message
                 fromID:(NSString *)peerID
              extension:(NSDictionary *)extension;

- (void)hideKeyBorand;
@end

//
//  TKChatView.h
//  EduClass
//
//  Created by lyy on 2018/4/27.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKBaseView.h"

@interface TKChatView : TKBaseView

- (id)initWithFrame:(CGRect)frame chatController:(NSString *)chatController;

- (void)reloadData;
//接收聊天消息
- (void)messageReceived:(NSString *)message
                 fromID:(NSString *)peerID
              extension:(NSDictionary *)extension;


@end

//
//  TKOldChatToolView.h
//  EduClass
//
//  Created by admin on 2018/6/6.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKEmotionTextView.h"

@protocol TKOldChatToolViewDelegate <NSObject>

- (void)chatToolViewDidBeginEditing:(UITextView *)textView;
- (void)sendMessage:(NSString *)message;

@end

@interface TKOldChatToolView : UIView

@property (nonatomic, strong) TKEmotionTextView *inputField;//输入框

@property (nonatomic, weak) id<TKOldChatToolViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame isDistance:(BOOL)isDistance;
@end

//
//  TKNavView.h
//  EduClass
//
//  Created by lyy on 2018/4/19.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef BOOL(^classoverBlock)(void);

@interface TKNavView : UIView

@property (nonatomic, copy) void(^leaveButtonBlock)();
@property (nonatomic, copy) void(^classoverBlock)();

@property (nonatomic, copy) void(^classBeginBlock)();

- (instancetype)initWithFrame:(CGRect)frame aParamDic:(NSDictionary *)aParamDic;

- (void)setTitle:(NSString *)title;
- (void)setTime:(NSTimeInterval)time;
- (void)showDeviceInfo;

- (void)refreshUI:(BOOL)add;
- (void)setHandButtonState:(BOOL)isHandup;

@end

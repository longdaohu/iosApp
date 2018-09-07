//
//  TKMaskView.h
//  EduClass
//
//  Created by lyy on 2018/4/24.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKMaskView : UIView

/** *  当前的用户 */
@property(strong,nonatomic)TKRoomUser *_Nullable iRoomUser;
/** *  是否分屏 */
@property(assign,nonatomic)BOOL isSplit;

@property (nonatomic, assign) NSInteger iVideoViewTag;
@property (nonatomic, strong) UILabel *nameLabel;//用户名称
@property (nonatomic, strong) UIButton *trophyButton;//奖杯
@property (nonatomic, strong) UIImageView *handImageView;//举手
@property (nonatomic, strong) UIButton *muteButton;//音频展示按钮

- (instancetype)initWithFrame:(CGRect)frame aVideoRole:(EVideoRole)aVideoRole;

- (void)endInBackGround:(BOOL)isInBackground;
//更改用户名
- (void)changeName:(NSString *)name;
//关闭视频
- (void)closeVideo;
//打开视频
- (void)openVideo;

- (void)refreshUI;


- (void)refreshRaiseHandUI:(NSDictionary *)dict;

-(void)refreshVolume:(NSDictionary *)dict;
@end

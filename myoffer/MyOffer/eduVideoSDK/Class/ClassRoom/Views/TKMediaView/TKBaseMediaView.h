//
//  TKBaseMediaView.h
//  EduClassPad
//
//  Created by ifeng on 2017/8/29.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKMediaDocModel,TKProgressSlider;
@interface TKBaseMediaView : UIView

@property (nonatomic, assign) BOOL hasVideo;//是否有视频
//初始化媒体文件
- (instancetype)initWithMediaPeerID:(NSString *)peerId
                   extensionMessage:(NSDictionary *)extensionMessage
                              frame:(CGRect)frame;
//初始化屏幕共享
- (instancetype)initScreenShare:(CGRect)frame;
//初始化电影共享
- (instancetype)initFileShare:(CGRect)frame;

- (void)insertViewToScrollView:(UIView *)view;

-(void)seekProgressToPos:(NSTimeInterval)value;

- (void)update:(NSTimeInterval)current total:(NSTimeInterval)total;

-(void)updatePlayUI:(BOOL)star;

//加载白板
- (void)loadWhiteBoard;
//删除
- (void)hiddenVideoWhiteBoard;
//删除
- (void)deleteWhiteBoard;

//设置播放层级关系
- (void)setVideoViewToBack;

//播放mp4时loading页面
- (void)loadLoadingView;

//播放mp4时hidden页面
- (void)hiddenLoadingView;
@end

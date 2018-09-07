//
//  TKDocControlView.m
//  EduClass
//
//  Created by lyy on 2018/4/20.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKWBControlView.h"
#import "TKEduSessionHandle.h"

#define ThemeKP(args) [@"ClassRoom.TKTabbarView." stringByAppendingString:args]
#define buttonCount 4

@interface TKWBControlView()
{
    CGFloat buttonWidth;
}


@end

@implementation TKWBControlView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _largeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:_largeButton];
        _largeButton.sakura.image(ThemeKP(@"common_icon_large"),UIControlStateNormal);
        _largeButton.sakura.image(ThemeKP(@"common_icon_large_unclickable"),UIControlStateDisabled);
        _largeButton.selected = NO;
        [_largeButton addTarget:self action:@selector(largeButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        _smallButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_smallButton];
        _smallButton.sakura.image(ThemeKP(@"common_icon_small"),UIControlStateNormal);
        _smallButton.sakura.image(ThemeKP(@"common_icon_small_unclickable"),UIControlStateDisabled);
        _smallButton.selected = NO;
        [_smallButton addTarget:self action:@selector(smallButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_fullScreenButton];
        _fullScreenButton.sakura.image(ThemeKP(@"common_icon_full_screen_large"),UIControlStateNormal);
        _fullScreenButton.sakura.image(ThemeKP(@"common_icon_full_screen_small"),UIControlStateSelected);
        _fullScreenButton.selected = [TKEduSessionHandle shareInstance].iIsFullState;
        _fullScreenButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_fullScreenButton addTarget:self action:@selector(fullScreenButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        _remarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_remarkButton];
        _remarkButton.sakura.image(ThemeKP(@"common_icon_remark"),UIControlStateNormal);
        _remarkButton.sakura.image(ThemeKP(@"common_icon_remark_selected"),UIControlStateSelected);
        _remarkButton.selected = NO;
        _remarkButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_remarkButton addTarget:self action:@selector(remarkButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return self;
}

- (void)largeButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    [[TKEduSessionHandle shareInstance].whiteBoardManager enlargeWhiteboard];
    
}

- (void)smallButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    [[TKEduSessionHandle shareInstance].whiteBoardManager narrowWhiteboard];
    
}

- (void)layoutSubviews{
    
    buttonWidth = self.frame.size.width/buttonCount;
    
    _largeButton.frame = CGRectMake(0, 0, buttonWidth, self.frame.size.height);

    _smallButton.frame = CGRectMake(buttonWidth, 0, buttonWidth, self.frame.size.height);
    
    _fullScreenButton.frame = CGRectMake(buttonWidth*2, 0, buttonWidth, self.frame.size.height);
    
    _remarkButton.frame = CGRectMake(buttonWidth*3, 0, buttonWidth, self.frame.size.height);

}

- (void)remarkButtonClick:(UIButton *)sender{
    if (sender.selected) {
        sender.selected = NO;
        [[TKEduSessionHandle shareInstance].whiteBoardManager closeDocumentRemark];
    }else{
        sender.selected = YES;
        [[TKEduSessionHandle shareInstance].whiteBoardManager openDocumentRemark];
        
    }
}
- (void)fullScreenButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:sChangeWebPageFullScreen object:@(sender.selected)];
    
    // 上课 发布信令
    if ([TKEduSessionHandle shareInstance].isClassBegin
        &&
        [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].coursewareFullSynchronize
        &&
        [TKEduSessionHandle shareInstance].roomMgr.localUser.role == TKUserType_Teacher
        ) {
        
        //    fullScreenType:'stream_media' , //courseware_file:表示课件全屏，stream_media：表示MP4全屏
        //    needPictureInPictureSmall:是否需要启用视频在右下角，现在都设置为true
        if (sender.selected) {
            
            [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:sWBFullScreen
                                                                 ID:sWBFullScreen
                                                                 To:sTellAll
                                                               Data:@{
                                                                      @"fullScreenType" :@"courseware_file",
                                                                      sneedPictureInPictureSmall: @(sender.selected)
                                                                      }
                                                               Save:true
                                                    AssociatedMsgID:nil
                                                   AssociatedUserID:nil
                                                            expires:0
                                                         completion:nil];
        }
        else {
            
            
            [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sWBFullScreen
                                                                 ID:sWBFullScreen
                                                                 To:sTellAll
                                                               Data:@{} completion:^(NSError *error) {
                                                                   
                                                               }];
        }
        
       
        
    }
}





-(void)dealloc{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

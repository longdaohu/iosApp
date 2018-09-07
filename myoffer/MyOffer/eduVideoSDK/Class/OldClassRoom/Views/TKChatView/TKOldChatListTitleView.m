//
//  TKOldChatListTitleView.m
//  EduClass
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKOldChatListTitleView.h"
#import "TKEduSessionHandle.h"
#import "TKEduRoomProperty.h"
#define ThemeKP(args) [@"ClassRoom.TKChatViews." stringByAppendingString:args]


@interface TKOldChatListTitleView()
@property (nonatomic, strong) UILabel *lblTitle;
@end
@implementation TKOldChatListTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
       
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.frame = CGRectMake(0,
                                     0,
                                     self.width,
                                     self.height);
        _lblTitle.text = [NSString stringWithFormat:@"%@:%@",MTLocalized(@"Label.roomid"), [TKEduSessionHandle shareInstance].iRoomProperties.iRoomId];
        
        // 样式
        _lblTitle.sakura.textColor(ThemeKP(@"chatListTitleTextColor"));
        _lblTitle.sakura.font(ThemeKP(@"chatListTitleTextFont"));
        _lblTitle.layer.sakura.borderColor(ThemeKP(@"chatListTitleBorderColor"));
        
        _lblTitle.layer.cornerRadius  = self.height / 2;
        _lblTitle.layer.masksToBounds = YES;
        _lblTitle.layer.borderWidth   = 0.5;
        
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        
        
        [self addSubview:_lblTitle];
    }
    return self;
}

//- (void)layoutSubviews {
//
//
//
//}









@end

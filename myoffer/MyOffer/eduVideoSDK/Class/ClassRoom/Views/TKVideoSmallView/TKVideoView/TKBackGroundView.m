//
//  TKBackGroundView.m
//  EduClassPad
//
//  Created by lyy on 2017/11/28.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKBackGroundView.h"
#import "TKMacro.h"

#define ThemeKP(args) [@"ClassRoom.TKVideoView." stringByAppendingString:args]

@interface TKBackGroundView()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *promptLabel;


@end
@implementation TKBackGroundView



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _backView = [[UIView alloc]init];
        _backView.sakura.backgroundColor(ThemeKP(@"videoInBackColor"));
        _backView.sakura.alpha(ThemeKP(@"videoInBackAlpha"));
        [self addSubview:_backView];
        
        _promptLabel = [[UILabel alloc]init];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.numberOfLines = 0;
        _promptLabel.sakura.textColor(ThemeKP(@"videoInBackTitleColor"));
        _promptLabel.text = MTLocalized(@"State.isInBackGround");
        [self addSubview:_promptLabel];
        
        
        
        
    }
    return self;
}

- (void)layoutSubviews{
    self.backView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.promptLabel.frame =  CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
}

- (void)setContent:(NSString *)content {
    self.promptLabel.text = content;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

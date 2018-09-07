//
//  TKClassTimeView.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/8.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKClassTimeView.h"

#import "TKUtil.h"
static const CGFloat sTimeWithViewCap = 5;
static const CGFloat sColonWidth = 10;
static const CGFloat sPromButtonWidth = 79;
static const CGFloat sPromButtonHeigh = 34;


/*
 
 PromptTypeStartReady1Minute,  //距离上课还有1分钟,White 249,249,249
 PromptTypeStartPass1Minute,   //超过上课时间,White 249,249,249,blue:78,100,196
 PromptTypeEnd3Minute,         //距离下课还3分钟,Yellow 155,136 58
 PromptTypeEndPass,             //超时,Red 215 0 0
 PromptTypeEndPass5Minute,     //超时5分钟,Red
 PromptTypeEndPass2Minute     //超时2分钟,Red,
 
 */

#define ThemeKP(args) [@"ClassRoom.TKNavView." stringByAppendingString:args]


@interface TKClassTimeView ()
@property (nonatomic,retain)UILabel *iHourLabel;
@property (nonatomic,retain)UILabel *iMinuteLabel;
@property (nonatomic,retain)UILabel *iSecondLabel;
@property (nonatomic,retain)UILabel *iColonLabel;
@property (nonatomic,retain)UILabel *iColon2Label;
@property (nonatomic, assign) NSTimeInterval iLocalTime;
@property (nonatomic,strong)UIView *iPromptView;
@property (nonatomic,strong)UIButton *iPromptViewButton;
@property (nonatomic,retain)UILabel *iPromptLabel;

@property (nonatomic,assign)NSTimeInterval iTimePrompt;
@property (nonatomic,assign)PromptType iPromptType;
@property (nonatomic, strong) NSTimer *iClassReadyTimetimer;


@end

@implementation TKClassTimeView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView:frame];
    }
    return  self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
       
    }
    return self;
}
-(void)initView:(CGRect)aFrame{
    _iLocalTime = 0;
    CGFloat tMinWidth =CGRectGetHeight(aFrame)>CGRectGetWidth(aFrame)?CGRectGetWidth(aFrame):CGRectGetHeight(aFrame);
    
    
    CGFloat tHeight = tMinWidth-sTimeWithViewCap*2;
    CGFloat tWidth = tHeight + 8;
    //最小是5
    if (tMinWidth < sTimeWithViewCap*2) {
        tWidth = tMinWidth;
    }
    _iHourLabel = ({
    
        UILabel *tHourLabel = [[UILabel alloc]initWithFrame:CGRectMake(sTimeWithViewCap, sTimeWithViewCap, tWidth, tHeight)];
        tHourLabel.textColor      =  RGBACOLOR_PromptWhite;
        tHourLabel.text = @"00";
        tHourLabel.textAlignment = NSTextAlignmentCenter;
        tHourLabel.backgroundColor = RGBCOLOR(38, 38, 38);
        [TKUtil setCornerForView:tHourLabel];
        tHourLabel;
    
        
    });
    
    [self addSubview:_iHourLabel];
    _iColonLabel = ({
        
        UILabel *tColonLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iHourLabel.frame), CGRectGetMinY(_iHourLabel.frame), sColonWidth, tHeight)];
        tColonLabel.text = @":";
        tColonLabel.textAlignment = NSTextAlignmentCenter;
        tColonLabel.textColor      =  RGBACOLOR_PromptWhite;
        tColonLabel.backgroundColor = [UIColor clearColor];
        
        tColonLabel;
        
        
    });
     [self addSubview:_iColonLabel];
    _iMinuteLabel = ({
        
        UILabel *tMinuteLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iColonLabel.frame), CGRectGetMinY(_iHourLabel.frame), tWidth, tHeight)];
        tMinuteLabel.textColor      =  RGBACOLOR_PromptWhite;
        tMinuteLabel.text = @"00";
        tMinuteLabel.textAlignment = NSTextAlignmentCenter;
        tMinuteLabel.backgroundColor = RGBCOLOR(38, 38, 38);
        [TKUtil setCornerForView:tMinuteLabel];
        tMinuteLabel;
        
        
    });
    [self addSubview:_iMinuteLabel];
    _iColon2Label = ({
        
        UILabel *tColon2Label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iMinuteLabel.frame), CGRectGetMinY(_iHourLabel.frame), sColonWidth, tHeight)];
        tColon2Label.textColor      =  RGBACOLOR_PromptWhite;//RGBCOLOR(217, 217, 217);
        tColon2Label.backgroundColor = [UIColor clearColor];
        tColon2Label.text = @":";
        tColon2Label.textAlignment = NSTextAlignmentCenter;
        [TKUtil setCornerForView:tColon2Label];
        tColon2Label;
        
        
    });
    [self addSubview:_iColon2Label];
    
    _iSecondLabel = ({
        
        UILabel *tSecondLabel = [[UILabel alloc] initWithFrame: CGRectMake(_iColon2Label.rightX,
                                 CGRectGetMinY(_iHourLabel.frame), tWidth, tHeight)];
        tSecondLabel.textColor      =  RGBACOLOR_PromptWhite;//RGBCOLOR(217, 217, 217);
        tSecondLabel.backgroundColor = RGBCOLOR(30, 30, 30);
        tSecondLabel.text = @"00";
        tSecondLabel.textAlignment = NSTextAlignmentCenter;
        [TKUtil setCornerForView:tSecondLabel];
       

        
         tSecondLabel;
    });
   [self addSubview:_iSecondLabel];

}

-(void)setToZeroTime {
    _iHourLabel.text   = @"00";
    _iMinuteLabel.text = @"00";
    _iSecondLabel.text = @"00";
}

-(void)setClassTime:(NSTimeInterval)aLocalTime{
    
//    _iLocalTime = aLocalTime;
//    NSString * H = @"0";
//    NSString * M = @"0";
//    NSString * S = @"0";
//    long temps = aLocalTime;
//    //long temps = 1;
//    long tempm = temps / 60;
//    long temph = tempm / 60;
//    long sec = temps - tempm * 60;
//    tempm = tempm - temph * 60;
//    H = temph == 0 ? @"00" : temph >= 10 ? [NSString stringWithFormat:@"%@",@(temph)] : [NSString stringWithFormat:@"0%@",@(temph)];
//    M = tempm == 0 ? @"00" : tempm >= 10 ? [NSString stringWithFormat:@"%@",@(tempm)] : [NSString stringWithFormat:@"0%@",@(tempm)];
//    S = sec == 0 ? @"00" : sec >= 10 ? [NSString stringWithFormat:@"%@",@(sec)] : [NSString stringWithFormat:@"0%@",@(sec)];
    
    NSString * H = @"0";
    NSString * M = @"0";
    NSString * S = @"0";
    long temps = aLocalTime;
    //long temps = 1;
    long tempm = temps / 60;
    long temph = tempm / 60;
    long sec = temps - tempm * 60;
    tempm = tempm - temph * 60;
    H = temph == 0 ? @"00" : temph >= 10 ? [NSString stringWithFormat:@"%@",@(temph)] : [NSString stringWithFormat:@"0%@",@(temph)];
    M = tempm == 0 ? @"00" : tempm >= 10 ? [NSString stringWithFormat:@"%@",@(tempm)] : [NSString stringWithFormat:@"0%@",@(tempm)];
    S = sec == 0 ? @"00" : sec >= 10 ? [NSString stringWithFormat:@"%@",@(sec)] : [NSString stringWithFormat:@"0%@",@(sec)];
    
    _iHourLabel.text   = H;
    _iMinuteLabel.text = M;
    _iSecondLabel.text = S;
}
//79 *34 type == -1 设置错误 1.aPromptTime==0 只是单纯的设置颜色 2.aPromptTime>0 设置timer

-(void)showPromte:(PromptType)aPromptType aPassEndTime:(int)aPassEndTime aPromptTime:(int)aPromptTime{
    
    if (aPromptType<0) {
        [self hidePromptView];
        return;
    }
    //如果在计时，则什么也不做
    if (_iTimePrompt) return;
  
    long tempm   = aPassEndTime / 60;
    BOOL tIsNeedPrompButton = (aPromptType != PromptTypeEndPass5Minute) && aPromptTime;
  
    CGFloat tMinHigh =CGRectGetHeight(self.frame)>CGRectGetWidth(self.frame)?CGRectGetWidth(self.frame):CGRectGetHeight(self.frame);
    if (_iPromptView) {
        [_iPromptView removeFromSuperview];
    }
    
    _iPromptView  = ({
        UIView *tView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iSecondLabel.frame)+sTimeWithViewCap, sTimeWithViewCap, CGRectGetWidth(self.frame)-CGRectGetMaxX(_iSecondLabel.frame)-2*sTimeWithViewCap, tMinHigh-2*sTimeWithViewCap)];
        tView.backgroundColor = RGBCOLOR(0, 0, 0);
        tView;
        
    });
   
    if (_iPromptLabel) {
        [_iPromptLabel removeFromSuperview];
    }
    
    _iPromptLabel = ({
        UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(sTimeWithViewCap, 0, CGRectGetWidth(_iPromptView.frame)-CGRectGetWidth(_iPromptViewButton.frame)-sTimeWithViewCap*3, CGRectGetHeight(_iPromptView.frame))];
        tLabel.textAlignment = NSTextAlignmentLeft;

        tLabel.textColor = RGBACOLOR_PromptWhite;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@""];
        
        switch (aPromptType) {
            case PromptTypeStartReady1Minute:
            {
                if ((aPromptTime)) {
                    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", MTLocalized(@"Prompt.ClassToBegin")]];
                    if ([TKUtil isEnglishLanguage]) {
                        [str addAttribute:NSForegroundColorAttributeName value:RGBACOLOR_PromptYellow range:NSMakeRange(24, 1)];
                        
                    }else{
                        [str addAttribute:NSForegroundColorAttributeName value:RGBACOLOR_PromptYellow range:NSMakeRange(8, 1)];
                    }
                    
                }
               
                [self PromptColor:RGBACOLOR_PromptWhite];
                break;
            }
            case PromptTypeStartPass1Minute:
            {
                if (aPromptTime) {
                    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", MTLocalized(@"Prompt.timeoutStart.one"),@(tempm), MTLocalized(@"Prompt.timeoutStart.two")]];
                    NSInteger tBit  = [TKUtil numberBit:tempm];
                    
                    if ([TKUtil isEnglishLanguage]) {
                        [str addAttribute:NSForegroundColorAttributeName value:RGBACOLOR_PromptYellow range:NSMakeRange(8, tBit)];
                    }else{
                        //颜色 设置
                        [str addAttribute:NSForegroundColorAttributeName value:RGBACOLOR_PromptYellow range:NSMakeRange(3, tBit)];
                    }
                    
                }
               
                [self PromptColor:RGBACOLOR_PromptWhite];
                
                break;
            }
            case PromptTypeEndWill1Minute:
            {
                if (aPromptTime) {
                    str = [[NSMutableAttributedString alloc] initWithString:MTLocalized(@"Prompt.EndClass1M")];
                    if ([TKUtil isEnglishLanguage]) {
                        [str addAttribute:NSForegroundColorAttributeName value:RGBACOLOR_PromptYellow range:NSMakeRange(10, 1)];
                    }
                    else{
                        [str addAttribute:NSForegroundColorAttributeName value:RGBACOLOR_PromptYellow range:NSMakeRange(6, 1)];
                    }
                    
                }
               
                [self PromptColor:RGBACOLOR_PromptYellow];
                break;
            }
            case PromptTypeEndPass:
            {
             
                [self PromptColor:RGBACOLOR_PromptRed];
                break;
            }
            case PromptTypeEndPass5Minute:
            {
                if (aPromptTime) {
                    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%@‘)", MTLocalized(@"Prompt.RoomToBeClosed"), @(aPromptTime)]];
                }
               
                [self PromptColor:RGBACOLOR_PromptRed];
                break;
            }
            case PromptTypeEndPass3Minute:
            {
                if (aPromptTime) {
                    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 3 %@ 2 %@", MTLocalized(@"Prompt.timeoutReadyEnd.one"), MTLocalized(@"Prompt.timeoutReadyEnd.two"), MTLocalized(@"Prompt.timeoutReadyEnd.three")]];
                    //颜色 设置
                    if ([TKUtil isEnglishLanguage]) {
                        
                        [str addAttribute:NSForegroundColorAttributeName value:RGBACOLOR_PromptBlue range:NSMakeRange(14, 1)];
                        [str addAttribute:NSForegroundColorAttributeName value:RGBACOLOR_PromptBlue range:NSMakeRange(76, 1)];
                    }else{
                        [str addAttribute:NSForegroundColorAttributeName value:RGBACOLOR_PromptBlue range:NSMakeRange(5, 1)];
                        [str addAttribute:NSForegroundColorAttributeName value:RGBACOLOR_PromptBlue range:NSMakeRange(15, 1)];
                    }
                    
                }
                [self PromptColor:RGBACOLOR_PromptRed];
                break;
            }
                
            default:
                break;
        }
        
        tLabel.attributedText    = str;
        tLabel.font = TKFont(14);
        CGFloat tWidth =  [TKUtil widthForTextString:str.string height:CGRectGetHeight(_iPromptLabel.frame) fontSize:14];
        [TKUtil setWidth:tLabel To:tWidth];
        tLabel;
        
    });
   
    [TKUtil setWidth:_iPromptView To:sPromButtonWidth*tIsNeedPrompButton+3*sTimeWithViewCap+CGRectGetWidth(_iPromptLabel.frame)];
    [TKUtil setCornerForView:_iPromptView];
    
    if (_iPromptViewButton) {
        [_iPromptViewButton removeFromSuperview];
    }
    //适配飞博
    //!_iPromptViewButton ?:[_iPromptViewButton removeFromSuperview];
  
    if (!aPromptTime) {
        return;
    }
    _iTimePrompt = aPromptTime;
    _iPromptViewButton = ({
    
        UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tButton.backgroundColor = RGBACOLOR_PromptBlue;
        tButton.frame = CGRectMake(CGRectGetWidth(_iPromptView.frame)-sPromButtonWidth-sTimeWithViewCap, (CGRectGetHeight(_iPromptView.frame)-(CGRectGetHeight(_iPromptView.frame)>sPromButtonHeigh?sPromButtonHeigh:CGRectGetHeight(_iPromptView.frame)))/2, sPromButtonWidth*tIsNeedPrompButton,CGRectGetHeight(_iPromptView.frame)>sPromButtonHeigh?sPromButtonHeigh:CGRectGetHeight(_iPromptView.frame) );
         [tButton setTitle:[NSString stringWithFormat:@"%@%@‘", MTLocalized(@"Button.remindKnow"), @(aPromptTime)] forState:UIControlStateNormal];
        [tButton addTarget:self action:@selector(hidePromptView) forControlEvents:UIControlEventTouchUpInside];
        tButton.titleLabel.font = TKFont(10);
        
        [TKUtil setCornerForView:tButton];
        tButton;
    
    });
    
   
    _iClassReadyTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                             target:self
                                                           selector:@selector(changePromptTime)
                                                           userInfo:nil
                                                            repeats:YES];
    
    [self startClassReadyTimer];

    [_iPromptView addSubview:_iPromptViewButton];
    [_iPromptView addSubview:_iPromptLabel];
    [self addSubview:_iPromptView];
    _iPromptType = aPromptType;
   
   
   
}
-(void)hidePromptView{
    _iPromptView.hidden = YES;
    _iPromptView = nil;
    [self invalidateClassReadyTime];
    
}
-(void)invalidateClassReadyTime{
    if (_iClassReadyTimetimer) {
        [_iClassReadyTimetimer invalidate];
        _iTimePrompt      = 0;
        _iClassReadyTimetimer = nil;
    }
}

-(void)startClassReadyTimer{
   
    [_iClassReadyTimetimer setFireDate:[NSDate date]];
}
-(void)changePromptTime{
    if (_iTimePrompt==0) {
        [self hidePromptView];
        return;
    }
    if (_iPromptType == PromptTypeEndPass5Minute) {
       NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@‘", MTLocalized(@"Prompt.timeoutEnd"),@(_iTimePrompt)]];
        _iPromptLabel.attributedText = str;
        
    }else{
         [_iPromptViewButton setTitle:[NSString stringWithFormat:@"%@%@‘", MTLocalized(@"Button.remindKnow"), @(_iTimePrompt)] forState:UIControlStateNormal];
    }
    _iTimePrompt--;
    
}
-(void)PromptColor:(UIColor *)aColor{
    _iHourLabel.textColor = aColor;
    _iMinuteLabel.textColor = aColor;
    _iSecondLabel.textColor = aColor;
    _iColonLabel.textColor = aColor;
    _iColon2Label.textColor = aColor;
}
@end

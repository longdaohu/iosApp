//
//  XWshareView.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#import "ShareButton.h"
#import "XWGJShareView.h"
#import "FXBlurView.h"
@interface XWGJShareView ()

//@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UILabel *TitleLab;
@property(nonatomic,strong)UIView  *ShareBgView;
@property(nonatomic,strong)UIButton  *CancelBtn;
@property(nonatomic,strong)UIButton *cover;
@property(nonatomic,strong)UIView *bgView;

@end

@implementation XWGJShareView
+ (instancetype)shareView{
    
    XWGJShareView  *ShareView = [[XWGJShareView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT)];

    [[UIApplication sharedApplication].keyWindow addSubview:ShareView];

    return ShareView;
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.cover =[[UIButton alloc] init];
        self.cover.backgroundColor =[UIColor blackColor];
        [self.cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchDown];
        self.cover.alpha = 0;
        [self addSubview:self.cover];
        CGFloat coverX = 0;
        CGFloat coverY = 0;
        CGFloat coverW = XSCREEN_WIDTH;
        CGFloat coverH = XSCREEN_HEIGHT;
        self.cover.frame = CGRectMake(coverX, coverY, coverW, coverH);
        
        
        self.bgView =[[UIView alloc] init];
        self.bgView.backgroundColor =[UIColor colorWithWhite:1 alpha:0.96];
        [self addSubview:self.bgView];
        CGFloat bgX = 0;
        CGFloat bgY = XSCREEN_HEIGHT;
        CGFloat bgW = XSCREEN_WIDTH;
        CGFloat bgH = XSCREEN_WIDTH;
        self.bgView.frame = CGRectMake(bgX, bgY, bgW, bgH);
        
        
        self.TitleLab = [[UILabel alloc] init];
        self.TitleLab.text = GDLocalizedString(@"About_shareTitle");
        self.TitleLab.textAlignment = NSTextAlignmentCenter;
        self.TitleLab.textColor = XCOLOR_BLACK;
        [self.bgView  addSubview:self.TitleLab];
        CGFloat titleX = 0;
        CGFloat titleY = 0;
        CGFloat titleW = self.bounds.size.width;
        CGFloat titleH = self.bounds.size.width *0.2;
        self.TitleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);

        
        self.ShareBgView =[[UIView  alloc] init];
       [self.bgView addSubview:self.ShareBgView];
        CGFloat shareBgX = 15;
        CGFloat shareBgY = CGRectGetMaxY(self.TitleLab.frame);
        CGFloat shareBgW = self.bounds.size.width - 30;
        CGFloat shareBgH = 2  * shareBgW * 0.25;
        self.ShareBgView.frame = CGRectMake(shareBgX, shareBgY, shareBgW, shareBgH);
        
        
        ShareButton *XEIXIN= [ShareButton myShareButtonWithNormalTitle:GDLocalizedString(@"About_shareweixin") seletedTitle:GDLocalizedString(@"About_shareweixin")  normalImage:@"share_weixin" seletedImage:@"share_weixinPress" actionType:1];
        [XEIXIN addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:XEIXIN];
        
        ShareButton *Friend= [ShareButton myShareButtonWithNormalTitle:GDLocalizedString(@"About_sharefrend")  seletedTitle:GDLocalizedString(@"About_sharefrend")  normalImage:@"share_Friend" seletedImage:@"share_FriendPress" actionType:2];
        [Friend addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:Friend];
        
        
        ShareButton *QQ= [ShareButton myShareButtonWithNormalTitle:@"QQ" seletedTitle:@"QQ" normalImage:@"share_QQ" seletedImage:@"share_QQPress" actionType:3];
        [QQ addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:QQ];
        
        ShareButton *QQRoom  = [ShareButton myShareButtonWithNormalTitle:GDLocalizedString(@"About_shareZoom")  seletedTitle:GDLocalizedString(@"About_shareZoom") normalImage:@"share_QQRoom" seletedImage:@"share_QQRoomPress" actionType:4];
        [QQRoom addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:QQRoom];

        ShareButton *WEIBO  = [ShareButton myShareButtonWithNormalTitle:GDLocalizedString(@"About_shareWeibo") seletedTitle:GDLocalizedString(@"About_shareWeibo") normalImage:@"share_weibo" seletedImage:@"share_weiboPress" actionType:5];
        [WEIBO addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:WEIBO];
        
        ShareButton *EMAIL  = [ShareButton myShareButtonWithNormalTitle:@"Email" seletedTitle:@"Email" normalImage:@"share_mail" seletedImage:@"share_mailPress" actionType:6];
        [EMAIL addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:EMAIL];

        
        ShareButton *COPY  = [ShareButton myShareButtonWithNormalTitle:GDLocalizedString(@"About_shareCopy") seletedTitle:GDLocalizedString(@"About_shareCopy")  normalImage:@"share_copy" seletedImage:@"share_copyPress" actionType:7];
        [COPY addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:COPY];
        
        ShareButton *MORE  = [ShareButton myShareButtonWithNormalTitle:GDLocalizedString(@"About_shareMore") seletedTitle:GDLocalizedString(@"About_shareMore") normalImage:@"share_More" seletedImage:@"share_MorePress" actionType:8];
        [MORE addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:MORE];
      
        CGFloat itemw = shareBgW * 0.25;
        CGFloat top = 0;
        CGFloat itemh = itemw;
        for (int index = 0 ; index < 8 ; index++) {
            ShareButton *item =(ShareButton *)self.ShareBgView.subviews[index];
            CGFloat itemx = (index% 4 + 1) + index % 4 * itemw;
            CGFloat itemy = top + (itemh)*( index / 4);
            
            item.frame = CGRectMake(itemx, itemy, itemw, itemh);
        }

        
        self.CancelBtn = [[UIButton alloc] init];
        self.CancelBtn.tag = 9;
        self.CancelBtn.layer.cornerRadius = 5;
        self.CancelBtn.layer.masksToBounds = YES;
        [self.CancelBtn setTitle:GDLocalizedString(@"Potocol-Cancel") forState:UIControlStateNormal];
        self.CancelBtn.titleLabel.font = [UIFont systemFontOfSize:16 + XPERCENT];
        [self.CancelBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
        self.CancelBtn.backgroundColor = XCOLOR_LIGHTGRAY;
        [self.CancelBtn addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.CancelBtn];
        CGFloat cancelX = 40;
        CGFloat cancelY = CGRectGetMaxY(self.ShareBgView.frame) +20;
        CGFloat cancelW = self.bounds.size.width - cancelX * 2;
        CGFloat cancelH = 50;
        self.CancelBtn.frame = CGRectMake(cancelX, cancelY, cancelW, cancelH);
        
        
     }
    return self;
}



-(void)share:(UIButton *)sender
{
    
    [self ShareButton:sender hiden:YES];
    
}


-(void)coverClick:(UIButton *)sender
{

    [self ShareButtonClickAndViewHiden:YES];
    
}

-(void)ShareButton:(UIButton *)sender hiden:(BOOL)Hiden{
    
 
    if (!Hiden) {
        
        self.hidden =NO;
    }
    
    CGFloat coverAlpha = Hiden ? 0 : 0.5;
    
    CGRect  newRect = self.bgView.frame;
    
    newRect.origin.y = Hiden ? XSCREEN_HEIGHT:XSCREEN_HEIGHT - self.bgView.frame.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.cover.alpha = coverAlpha;
        
        self.bgView.frame = newRect;
        
  
    } completion:^(BOOL finished) {
        
        if (Hiden) {
            
            self.hidden = YES;
            
            if (self.actionBlock) {
                
                self.actionBlock(sender,YES);
                
            }
        }
        
    }];
}

-(void)ShareButtonClickAndViewHiden:(BOOL)Hiden{
    
    [self ShareButton:nil hiden:Hiden];
    
}

@end

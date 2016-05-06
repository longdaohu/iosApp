//
//  XWshareView.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#import "XWGJShareButton.h"
#import "XWGJShareView.h"
@interface XWGJShareView ()

@property(nonatomic,strong)UIImageView *BgView;
@property(nonatomic,strong)UILabel *TitleLab;
@property(nonatomic,strong)UIView  *ShareBgView;
@property(nonatomic,strong)UIButton  *CancelBtn;

@end

@implementation XWGJShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.BgView = [[UIImageView alloc] init];
        self.BgView.image = [UIImage imageNamed:@"bg98"];
        [self addSubview:self.BgView];
        
        self.TitleLab = [[UILabel alloc] init];
        
        self.TitleLab.text = GDLocalizedString(@"About_shareTitle");
        self.TitleLab.textAlignment = NSTextAlignmentCenter;
        self.TitleLab.textColor = XCOLOR_BLACK;
        [self  addSubview:self.TitleLab];
        
        self.ShareBgView =[[UIView  alloc] init];
        self.ShareBgView.backgroundColor = XCOLOR_CLEAR;
        [self addSubview:self.ShareBgView];
        XWGJShareButton *XEIXIN= [XWGJShareButton myShareButtonWithNormalTitle:GDLocalizedString(@"About_shareweixin") seletedTitle:GDLocalizedString(@"About_shareweixin")  normalImage:@"share_weixin" seletedImage:@"share_weixinPress" actionType:0];
        [XEIXIN addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:XEIXIN];
        
        XWGJShareButton *Friend= [XWGJShareButton myShareButtonWithNormalTitle:GDLocalizedString(@"About_sharefrend")  seletedTitle:GDLocalizedString(@"About_sharefrend")  normalImage:@"share_Friend" seletedImage:@"share_FriendPress" actionType:1];
        [Friend addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:Friend];
        
        
        XWGJShareButton *QQ= [XWGJShareButton myShareButtonWithNormalTitle:@"QQ" seletedTitle:@"QQ" normalImage:@"share_QQ" seletedImage:@"share_QQPress" actionType:2];
        [QQ addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:QQ];
        
        XWGJShareButton *QQRoom  = [XWGJShareButton myShareButtonWithNormalTitle:GDLocalizedString(@"About_shareZoom")  seletedTitle:GDLocalizedString(@"About_shareZoom") normalImage:@"share_QQRoom" seletedImage:@"share_QQRoomPress" actionType:3];
        [QQRoom addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:QQRoom];

        XWGJShareButton *WEIBO  = [XWGJShareButton myShareButtonWithNormalTitle:GDLocalizedString(@"About_shareWeibo") seletedTitle:GDLocalizedString(@"About_shareWeibo") normalImage:@"share_weibo" seletedImage:@"share_weiboPress" actionType:4];
        [WEIBO addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:WEIBO];
        
        XWGJShareButton *EMAIL  = [XWGJShareButton myShareButtonWithNormalTitle:@"Email" seletedTitle:@"Email" normalImage:@"share_mail" seletedImage:@"share_mailPress" actionType:5];
        [EMAIL addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:EMAIL];

        
        XWGJShareButton *COPY  = [XWGJShareButton myShareButtonWithNormalTitle:GDLocalizedString(@"About_shareCopy") seletedTitle:GDLocalizedString(@"About_shareCopy")  normalImage:@"share_copy" seletedImage:@"share_copyPress" actionType:6];
        [COPY addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:COPY];
        
        XWGJShareButton *MORE  = [XWGJShareButton myShareButtonWithNormalTitle:GDLocalizedString(@"About_shareMore") seletedTitle:GDLocalizedString(@"About_shareMore") normalImage:@"share_More" seletedImage:@"share_MorePress" actionType:7];
        [MORE addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShareBgView addSubview:MORE];
        
        self.CancelBtn = [[UIButton alloc] init];
        self.CancelBtn.tag = 8;
        self.CancelBtn.layer.cornerRadius = 5;
        self.CancelBtn.layer.masksToBounds = YES;
        [self.CancelBtn setTitle:GDLocalizedString(@"Potocol-Cancel") forState:UIControlStateNormal];
        self.CancelBtn.titleLabel.font = [UIFont systemFontOfSize:16 + FONT_SCALE];
        [self.CancelBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
        self.CancelBtn.backgroundColor = XCOLOR_LIGHTGRAY;
        [self.CancelBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.CancelBtn];
        
        
        self.backgroundColor = XCOLOR_CLEAR;
        
     }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.BgView.frame = CGRectMake(0, 0, APPSIZE.width, self.bounds.size.height);
    
    CGFloat Tx = 0;
    CGFloat Ty = 0;
    CGFloat Tw = self.bounds.size.width;
    CGFloat Th = self.bounds.size.width *0.2;
    self.TitleLab.frame = CGRectMake(Tx, Ty, Tw, Th);
    
    CGFloat Sx = 15;
    CGFloat Sy = CGRectGetMaxY(self.TitleLab.frame);
    CGFloat Sw = self.bounds.size.width - 30;
    CGFloat Sh = 2  * Sw * 0.25;
    self.ShareBgView.frame = CGRectMake(Sx, Sy, Sw, Sh);
    
    
        for (int i = 0 ; i < 8 ; i++) {
            
            XWGJShareButton *item =(XWGJShareButton *)self.ShareBgView.subviews[i];
            CGFloat top = 0;
            CGFloat w = Sw / 4.0;
            CGFloat h = w;
            CGFloat x = (i % 4 + 1) + i % 4 * w;
            CGFloat y = top + (h)*( i / 4);
            
            
            item.frame = CGRectMake(x, y, w, h);
        }
    
    CGFloat Cx = 40;
    CGFloat Cy = CGRectGetMaxY(self.ShareBgView.frame) +20;
    CGFloat Cw = self.bounds.size.width - Cx * 2;
    CGFloat Ch = 50;
    self.CancelBtn.frame = CGRectMake(Cx, Cy, Cw, Ch);
    
}

-(void)share:(UIButton *)sender
{
    
     
    if (self.ShareBlock) {
        
        self.ShareBlock(sender);
    }
}


@end

//
//  ShareNView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/2/8.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ShareNView.h"
#import "ShareButton.h"

@interface ShareNView ()
@property(nonatomic,strong)UIButton *cover;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIView *shareBgView;

@end


@implementation ShareNView

+ (instancetype)shareViewWithAction:(shareViewBlock)actionBlock{
    
    ShareNView  *shareView = [[ShareNView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    
    shareView.actionBlock = actionBlock;
    
    return shareView;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.cover =[[UIButton alloc] initWithFrame:self.bounds];
        [self.cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.cover];
        self.cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
 
        self.bgView =[[UIView alloc] init];
        self.bgView.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.bgView];
        CGFloat bgX = 0;
        CGFloat bgY = self.bounds.size.height;
        CGFloat bgW = self.bounds.size.width;
        CGFloat bgH = bgW * 0.8;
        self.bgView.frame = CGRectMake(bgX, bgY, bgW, bgH);
        
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.text = @"分享";
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.textColor = [UIColor blackColor];
        [self.bgView  addSubview:self.titleLab];
        CGFloat titleX = 0;
        CGFloat titleY = 15;
        CGFloat titleW = bgW;
        CGFloat titleH = 30;
        self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
        
        
        self.cancelBtn = [[UIButton alloc] init];
        self.cancelBtn.tag = 9;
        self.cancelBtn.layer.cornerRadius = 5;
        self.cancelBtn.layer.masksToBounds = YES;
        [self.cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.cancelBtn.backgroundColor = [UIColor lightGrayColor];
        [self.cancelBtn addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.cancelBtn];
        CGFloat cancelX = 40;
        CGFloat cancelW = bgW - cancelX * 2;
        CGFloat cancelH = 45;
        CGFloat cancelY = bgH - cancelH - 20;
        self.cancelBtn.frame = CGRectMake(cancelX, cancelY, cancelW, cancelH);
        
        
        self.shareBgView =[[UIView  alloc] init];
        [self.bgView addSubview:self.shareBgView];
        CGFloat shareBgX = 15;
        CGFloat shareBgY = CGRectGetMaxY(self.titleLab.frame);
        CGFloat shareBgW = bgW - shareBgX * 2;
        CGFloat shareBgH = CGRectGetMinY(self.cancelBtn.frame) - shareBgY;
        self.shareBgView.frame = CGRectMake(shareBgX, shareBgY, shareBgW, shareBgH);
        
        
        [self shareButtonWithTitle:GDLocalizedString(@"About_shareweixin")  imageName:@"share_weixin" tag:1];
        [self shareButtonWithTitle:GDLocalizedString(@"About_sharefrend")  imageName:@"share_Friend" tag:2];
        [self shareButtonWithTitle:@"QQ"  imageName:@"share_QQ" tag:3];
        [self shareButtonWithTitle:GDLocalizedString(@"About_shareZoom")  imageName:@"share_QQRoom" tag:4];
        [self shareButtonWithTitle:GDLocalizedString(@"About_shareWeibo")  imageName:@"share_weibo" tag:5];
        [self shareButtonWithTitle:GDLocalizedString(@"Email")  imageName:@"share_mail" tag:6];
        [self shareButtonWithTitle:GDLocalizedString(@"About_shareCopy")  imageName:@"share_copy" tag:7];
        [self shareButtonWithTitle:GDLocalizedString(@"About_shareMore")  imageName:@"share_More" tag:8];
  
        
        CGFloat itemw = shareBgW * 0.25;
        CGFloat top = 5;
        CGFloat itemh = (shareBgH - top) * 0.5;
        for (int index = 0 ; index < self.shareBgView.subviews.count; index++) {
            
            UIButton *item =(UIButton *)self.shareBgView.subviews[index];
            CGFloat itemx = index % 4 * itemw;
            CGFloat itemy = top + (itemh)*( index / 4);
            item.frame = CGRectMake(itemx, itemy, itemw, itemh);
        }
        
         
        
    }
    return self;
}

- (void)shareButtonWithTitle:(NSString *)title imageName:(NSString *)imageName tag:(NSInteger)tag{
    
    NSString *selectTittle =[NSString stringWithFormat:@"%@Press",imageName];
    ShareButton *sender= [ShareButton myShareButtonWithNormalTitle:title  seletedTitle:title  normalImage:imageName seletedImage:selectTittle actionType:tag];
    [sender addTarget:self action:@selector(shareItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBgView addSubview:sender];
    
}

- (void)coverClick:(UIButton *)sender{
 
    [self showHiden];
    
}

- (void)showHiden{

    [self share:NO shareItem:self.cancelBtn];
}

- (void)show{
    
    [self share:YES shareItem:nil];
}

- (void)shareItemClick:(UIButton *)sender{
    
    [self share:NO shareItem:sender];
}

- (void)share:(BOOL)show shareItem:(UIButton *)sender{
    
    if (show) {
        
         self.hidden = NO;
     }
    
    
    CGFloat coverAlpha = show ? 1 : 0;
    
    CGFloat bgViewY =  show ? [UIScreen mainScreen].bounds.size.height - self.bgView.bounds.size.height : [UIScreen mainScreen].bounds.size.height;
    
    XWeakSelf;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        weakSelf.cover.alpha = coverAlpha;
        
        weakSelf.bgView.mj_y = bgViewY;
        
    } completion:^(BOOL finished) {
        
        if (!show) {
            
            weakSelf.hidden = YES;
            
            weakSelf.actionBlock(sender,YES);
        }
        
    }];

}



@end

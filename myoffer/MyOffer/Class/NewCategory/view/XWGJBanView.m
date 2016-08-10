//
//  XWGJBanView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJBanView.h"
@interface XWGJBanView ()
//灰色背景
@property(nonatomic,strong)UIImageView  *bgView;
@property(nonatomic,strong)UIImageView  *topBgView;
@property(nonatomic,strong)UIImage *navigationBgImage;
@end

@implementation XWGJBanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.topBgView = [[UIImageView alloc] init];
        self.topBgView.contentMode = UIViewContentModeScaleToFill;
        self.topBgView.image = self.navigationBgImage;
        self.topBgView.clipsToBounds = YES;
        [self addSubview:self.topBgView];

        //灰色背景
        self.bgView = [[UIImageView alloc] init];
        UIColor *color =  [UIColor colorWithWhite:0 alpha:0.5];
        self.bgView.backgroundColor = color;
        self.bgView.layer.masksToBounds = YES;
        [self addSubview:self.bgView];
        
        //蓝色图片
        self.FocusView = [[UIImageView alloc] init];
        self.FocusView.layer.masksToBounds = YES;
        self.FocusView.layer.cornerRadius  = TOP_HIGHT * 0.5;
        self.FocusView.layer.borderWidth = 1;
        self.FocusView.layer.borderColor =color.CGColor;
        self.FocusView.image = self.itemImages[0];
        [self addSubview:self.FocusView];
        
        
        //按钮背景View
        self.SelectView = [[UIView alloc] init];
        [self addSubview:self.SelectView];
        
        
         NSArray *titles = @[GDLocalizedString(@"CategoryNew-region"),GDLocalizedString(@"CategoryNew-major"),GDLocalizedString(@"CategoryNew-rank")];
 
        for (int i = 0 ; i < 3; i++) {
            
            UIButton  *sender =  [[UIButton alloc] init];
            
            sender.tag = i;
            
            [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 
            [sender setTitleColor:XCOLOR_WHITE forState:UIControlStateDisabled];
            
            [sender setTitle:titles[i] forState:UIControlStateNormal];
            
            [sender addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            sender.enabled = i == 0 ? NO : YES;
            
            [_SelectView addSubview:sender];
        }
        
        self.lastBtn = _SelectView.subviews[0];
        
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.topBgView.frame = self.frame;
    
    CGFloat sw = self.bounds.size.width - 20;
    
    CGFloat sh = TOP_HIGHT;
    CGFloat bgViewy = self.bounds.size.height - TOP_HIGHT - 10;
    
    self.bgView.frame =CGRectMake(ITEM_MARGIN,bgViewy, sw, sh);
    
    self.bgView.layer.cornerRadius = 0.5 * sh;
    
    self.SelectView.frame = self.bgView.frame;
    
    for (int i = 0 ; i < 3; i++) {
        
        UIButton *sender = self.SelectView.subviews[i];
        
        sender.frame = CGRectMake(i * sw / 3, 0, sw / 3, sh);
    }
    
    self.FocusView.frame = CGRectMake(ITEM_MARGIN, bgViewy, sw / 3, sh);
    
    
}

-(void)selectBtnClick:(UIButton *)sender
{
    
    if (sender != self.lastBtn) {
        
        sender.enabled = NO;
        
        self.lastBtn.enabled = YES;
        
        self.lastBtn = sender;
        
        CGRect NewRect = self.FocusView.frame;
        
        NewRect.origin.x =ITEM_MARGIN + sender.tag * NewRect.size.width;
        
        
        [UIView transitionWithView:self.FocusView duration:0.3 options:UIViewAnimationOptionCurveEaseIn |UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            self.FocusView.frame = NewRect;
            self.FocusView.image = self.itemImages[sender.tag];
            self.FocusView.image = self.itemImages[sender.tag];
            
        } completion:^(BOOL finished) {
            
            
        }];
        
        if (self.actionBlock) {
            
            self.actionBlock(sender);
        }
        
    }
    
}




-(NSArray *)itemImages
{
    if (!_itemImages) {
        
        NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"items"];
        NSData *imageData_arr =[NSData dataWithContentsOfFile:path];
        _itemImages = [NSKeyedUnarchiver unarchiveObjectWithData:imageData_arr];
        
    }
    return _itemImages;
}

-(UIImage *)navigationBgImage
{
    if (!_navigationBgImage) {
        
        NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"nav.png"];
        UIImage *navImage =[UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
        _navigationBgImage =[self makeNewImageWithRect:CGRectMake(0, 64, XScreenWidth, 64) andImage:navImage];
        
    }
    return _navigationBgImage;
}
//得到部分区域图片
-(UIImage *)makeNewImageWithRect:(CGRect)clipRect andImage:(UIImage *)image
{
    //原图片
    //    UIImage * img = [UIImage imageNamed:@"bg.png"];
    //转化为位图
    CGImageRef temImg = image.CGImage;
    //根据范围截图
    temImg=CGImageCreateWithImageInRect(temImg, clipRect);
    //得到新的图片
    UIImage *newImage = [UIImage imageWithCGImage:temImg];
    //释放位图对象
    CGImageRelease(temImg);
    
    return newImage;
    
}


@end

 

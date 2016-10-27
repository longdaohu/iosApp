//
//  UniCollectionViewCell.m
//  myOffer
//
//  Created by sara on 16/3/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//


#import "UniCollectionViewCell.h"
#import "HotUniversityFrame.h"
#import "UniversityNew.h"

@interface UniCollectionViewCell ()
//cell背景
@property(nonatomic,strong)UIView *bgView;
//学校logo
@property(nonatomic,strong)LogoView *logoView;
//分隔线
@property(nonatomic,strong)UIView *center_Line;
//地理图标
@property(nonatomic,strong)UIImageView *anthorView;
//学校名称
@property(nonatomic,strong)UILabel *titleLab;
//学校英文名称
@property(nonatomic,strong)UILabel *subTitleLab;
//地理名称
@property(nonatomic,strong)UILabel *localLab;
//标签背景
@property(nonatomic,strong)UIView *tapView;

@end

@implementation UniCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor =  XCOLOR_BG;
        
        //cell背景
        self.bgView                     =[[UIView alloc] init];
        self.bgView.backgroundColor     = XCOLOR_WHITE;
        self.bgView.layer.cornerRadius  = 5;
        self.bgView.layer.borderWidth   = 1;
        self.bgView.layer.borderColor   = XCOLOR_CLEAR.CGColor;
        [self.contentView addSubview:self.bgView];
        self.bgView.layer.shadowOffset  = CGSizeMake(3, 3);
        self.bgView.layer.shadowOpacity = 0.20;
        
        //学校logo
        self.logoView                   = [[LogoView alloc] init];
        [self.bgView addSubview:self.logoView];
        
        //分隔线
        self.center_Line                 = [[UIView alloc] init];
        self.center_Line.backgroundColor = XCOLOR_LIGHTGRAY;
        [self.bgView addSubview:self.center_Line];
        
       //学校名称
        self.titleLab                    = [UILabel labelWithFontsize:KDUtilSize(15) TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentCenter];
        self.titleLab.lineBreakMode      = NSLineBreakByCharWrapping;
        self.titleLab.numberOfLines      = 2;
        [self.bgView addSubview:self.titleLab];

        //地理图标
        self.anthorView                     = [[UIImageView alloc] init];
        self.anthorView.image               = [UIImage imageNamed:@"Uni_anthor"];
        [self.bgView addSubview:self.anthorView];

        //地理名称
        self.localLab =  [UILabel labelWithFontsize:KDUtilSize(13) TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentLeft];
        self.localLab.lineBreakMode      =  NSLineBreakByClipping;
        [self.bgView addSubview:self.localLab];

       //学校英文名称
        self.subTitleLab =   [UILabel labelWithFontsize:KDUtilSize(11) TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentCenter];
        [self.bgView addSubview:self.subTitleLab];

        //标签背景
        self.tapView = [[UIView alloc] init];
        [self.bgView addSubview:self.tapView];

    }
    return self;
}




-(void)setUniFrame:(HotUniversityFrame *)uniFrame
{
    _uniFrame = uniFrame;
    
    UniversityNew *unversity = uniFrame.uni;
    
    self.bgView.frame        = uniFrame.bgViewFrame;
    self.center_Line.frame   = uniFrame.LineFrame;
    self.tapView.frame       = uniFrame.tapBgViewFrame;
    self.anthorView.frame       = uniFrame.LocalMVFrame;
    self.logoView.frame      = uniFrame.LogoFrame;
    self.titleLab.frame      = uniFrame.TitleFrame;
    self.subTitleLab.frame   = uniFrame.SubTitleFrame;
    self.localLab.frame      = uniFrame.LocalFrame;

    
    [self.logoView.logoImageView sd_setImageWithURL:[NSURL URLWithString:unversity.logo]];
    self.titleLab.text       =  unversity.name;
    self.subTitleLab.text    = unversity.official_name;
    self.localLab.text       = unversity.address_detail;
    
    CGFloat addressWidth = [unversity.address_detail KD_sizeWithAttributeFont:XFONT(XPERCENT * 11)].width;
    if (addressWidth > (uniFrame.LocalFrame.size.width - 30)) {
        
        self.localLab.text = unversity.address_short;
        
    }

    //移除子控件，防止重复显示
    [self.tapView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
  
    NSArray *tags = unversity.tags.count > 4 ? [unversity.tags subarrayWithRange:NSMakeRange(0, 4)] : unversity.tags;
    
    for (int i = 0; i < tags.count; i ++) {
        
        UILabel *sender =[UILabel labelWithFontsize:KDUtilSize(13) TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentCenter];
        sender.adjustsFontSizeToFitWidth = YES;
        sender.layer.borderColor         = XCOLOR(222.0, 222.0, 222.0).CGColor;
        sender.layer.borderWidth         = 1;
        [self.tapView addSubview:sender];
        sender.text = unversity.tags[i];
        sender.frame = [uniFrame.tapFrames[i]  CGRectValue];
        sender.layer.cornerRadius = 0.5 * sender.frame.size.height;
     }
    
}


@end

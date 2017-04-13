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
@property(nonatomic,strong)UILabel *nameLab;
//学校英文名称
@property(nonatomic,strong)UILabel *official_nameLab;
//地理名称
@property(nonatomic,strong)UILabel *addressLab;
//标签背景
@property(nonatomic,strong)UIView *tagsView;

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
        self.bgView.layer.cornerRadius  = CORNER_RADIUS;
        self.bgView.layer.shadowOffset  = CGSizeMake(3, 3);
        self.bgView.layer.shadowOpacity = 0.20;
        [self.contentView addSubview:self.bgView];

        //学校logo
        self.logoView                   = [[LogoView alloc] init];
        [self.bgView addSubview:self.logoView];
        
        //分隔线
        self.center_Line                 = [[UIView alloc] init];
        self.center_Line.backgroundColor = XCOLOR_LIGHTGRAY;
        [self.bgView addSubview:self.center_Line];
        
       //学校名称
        self.nameLab                    = [UILabel labelWithFontsize:KDUtilSize(15) TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentCenter];
        self.nameLab.lineBreakMode      = NSLineBreakByCharWrapping;
        self.nameLab.numberOfLines      = 2;
        [self.bgView addSubview:self.nameLab];

        //地理图标
        self.anthorView                     = [[UIImageView alloc] init];
        self.anthorView.image               = [UIImage imageNamed:@"Uni_anthor"];
        [self.bgView addSubview:self.anthorView];

        //地理名称
        self.addressLab =  [UILabel labelWithFontsize:KDUtilSize(13) TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentLeft];
        self.addressLab.lineBreakMode      =  NSLineBreakByClipping;
        [self.bgView addSubview:self.addressLab];

       //学校英文名称
        self.official_nameLab =   [UILabel labelWithFontsize:KDUtilSize(11) TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentCenter];
        [self.bgView addSubview:self.official_nameLab];

        //标签背景
        self.tagsView = [[UIView alloc] init];
        [self.bgView addSubview:self.tagsView];

    }
    return self;
}




-(void)setUniFrame:(HotUniversityFrame *)uniFrame
{
    _uniFrame = uniFrame;
    
    UniversityNew *unversity = uniFrame.universtiy;
    
    self.bgView.frame        = uniFrame.bgViewFrame;
    self.center_Line.frame   = uniFrame.LineFrame;
    self.tagsView.frame       = uniFrame.tagsBgViewFrame;
    self.anthorView.frame    = uniFrame.anthorFrame;
    self.logoView.frame      = uniFrame.LogoFrame;
    self.nameLab.frame       = uniFrame.nameFrame;
    self.official_nameLab.frame   = uniFrame.official_nameFrame;
    self.addressLab.frame      = uniFrame.addressFrame;


    
    [self.logoView.logoImageView sd_setImageWithURL:[NSURL URLWithString:unversity.logo]];
    self.nameLab.text       =  unversity.name;
    self.official_nameLab.text    = unversity.official_name;
    self.addressLab.text       = unversity.address_long;
    
    CGFloat addressWidth = [unversity.address_long KD_sizeWithAttributeFont:XFONT(XPERCENT * 11)].width;
    if (addressWidth > (uniFrame.addressFrame.size.width - 30)) {
        
        self.addressLab.text = unversity.address_short;
        
    }

    //移除子控件，防止重复显示
    [self.tagsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   
    NSArray *tags = unversity.tags.count > 4 ? [unversity.tags subarrayWithRange:NSMakeRange(0, 4)] : unversity.tags;
    
    [tags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *sender =[UILabel labelWithFontsize:KDUtilSize(13) TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentCenter];
        sender.layer.borderColor         = XCOLOR(222.0, 222.0, 222.0 , 1).CGColor;
        sender.layer.borderWidth         = 1;
        sender.layer.masksToBounds = YES;
        [self.tagsView addSubview:sender];
        sender.text = unversity.tags[idx];
        sender.frame = [uniFrame.tagFrames[idx]  CGRectValue];
        sender.layer.cornerRadius = 0.5 * sender.frame.size.height;
        
    }];

    
       
    
}


@end

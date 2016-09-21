//
//  UniCollectionViewCell.m
//  myOffer
//
//  Created by sara on 16/3/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//


#import "UniCollectionViewCell.h"
#import "HotUniversityFrame.h"
#import "UniversityObj.h"
@interface UniCollectionViewCell ()
//cell背景
@property(nonatomic,strong)UIView *bgView;
//学校logo
@property(nonatomic,strong)LogoView *logoView;
//分隔线
@property(nonatomic,strong)UIView *center_Line;
//地理图标
@property(nonatomic,strong)UIImageView *localMV;
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
        
        self.bgView                     =[[UIView alloc] init];
        self.bgView.backgroundColor     = XCOLOR_WHITE;
        self.bgView.layer.cornerRadius  = 5;
        self.bgView.layer.borderWidth   = 1;
        self.bgView.layer.borderColor   = XCOLOR_CLEAR.CGColor;
        [self.contentView addSubview:self.bgView];
        self.bgView.layer.shadowOffset  = CGSizeMake(3, 3);
        self.bgView.layer.shadowOpacity = 0.20;
        

        self.logoView                   = [[LogoView alloc] init];
        [self.bgView addSubview:self.logoView];
        
        
        self.center_Line                 = [[UIView alloc] init];
        self.center_Line.backgroundColor = XCOLOR_LIGHTGRAY;
        [self.bgView addSubview:self.center_Line];
        
        
        self.titleLab                    = [UILabel labelWithFontsize:KDUtilSize(15) TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentCenter];
        self.titleLab.lineBreakMode      = NSLineBreakByCharWrapping;
        self.titleLab.numberOfLines      = 2;
        [self.bgView addSubview:self.titleLab];

        self.localMV                     = [[UIImageView alloc] init];
        self.localMV.image               = [UIImage imageNamed:@"Uni_anthor"];
        [self.bgView addSubview:self.localMV];

        self.localLab =  [UILabel labelWithFontsize:KDUtilSize(13) TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentLeft];
        self.localLab.lineBreakMode      =  NSLineBreakByClipping;
        [self.bgView addSubview:self.localLab];

    
        self.subTitleLab =   [UILabel labelWithFontsize:KDUtilSize(11) TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentCenter];
        [self.bgView addSubview:self.subTitleLab];

        self.tapView = [[UIView alloc] init];
        [self.bgView addSubview:self.tapView];
        
        for (NSInteger i = 0 ; i < 4; i++) {
            
            UILabel *sender =[UILabel labelWithFontsize:KDUtilSize(13) TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentCenter];
            sender.adjustsFontSizeToFitWidth = YES;
            sender.layer.borderColor         = [UIColor colorWithRed:222.0/255 green:222.0/255 blue:222.0/255 alpha:1].CGColor;
            sender.layer.borderWidth         = 1;
            [self.tapView addSubview:sender];
        }
        
        
//        if (USER_EN) {
//            
//            self.subTitleLab.hidden = YES;
//            self.tapView.hidden     = YES;
//        }
        
    }
    return self;
}




-(void)setUniFrame:(HotUniversityFrame *)uniFrame
{
    _uniFrame = uniFrame;
    
    UniversityObj *unversity = uniFrame.university;
    self.bgView.frame        = uniFrame.bgViewFrame;
    self.center_Line.frame   = uniFrame.LineFrame;
    self.tapView.frame       = uniFrame.tapBgViewFrame;
    self.localMV.frame       = uniFrame.LocalMVFrame;
    NSDictionary *uniInfo    = uniFrame.universityDic;
    self.logoView.frame      = uniFrame.LogoFrame;
    
   [self.logoView.logoImageView sd_setImageWithURL:[NSURL URLWithString:unversity.logoName]];
    
    self.titleLab.frame      = uniFrame.TitleFrame;
    self.titleLab.text       =  unversity.titleName;
    
    self.subTitleLab.frame   = uniFrame.SubTitleFrame;
    self.subTitleLab.text    = unversity.subTitleName;
   
    self.localLab.frame      = uniFrame.LocalFrame;
    self.localLab.text       =  USER_EN ?[NSString stringWithFormat:@"%@ | %@", unversity.countryName,uniInfo[@"city"]] :[NSString stringWithFormat:@"%@ | %@ | %@", unversity.countryName, unversity.stateName, unversity.cityName];
    
    
    NSArray *tag_temps =  unversity.tags;
    NSArray *tags = tag_temps.count > 4 ? [tag_temps subarrayWithRange:NSMakeRange(0, 4)] : tag_temps;
    for (int i = 0; i < tags.count; i ++) {
        UILabel *item = (UILabel *)self.tapView.subviews[i];
        item.text = unversity.tags[i];
        item.frame = [uniFrame.tapFrames[i]  CGRectValue];
        item.layer.cornerRadius = 0.5 * item.frame.size.height;
     }
    
}


@end

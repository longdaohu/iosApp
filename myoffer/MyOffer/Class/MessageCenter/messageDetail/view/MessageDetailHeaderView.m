//
//  MessageDetailHeaderView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/3/26.
//  Copyright © 2018年 UVIC. All rights reserved.
//


#import "MessageDetailHeaderView.h"
#import "MessageDetailFrame.h"

#define TagHigh 24
#define SummaryFont 20
#define MARGIN 10

@interface MessageDetailHeaderView ()
//@property(nonatomic,strong)UIImageView *catigory_logo;//分类图片
@property(nonatomic,strong)UILabel *catigoryLab;//名称
@property(nonatomic,strong)UIView *tagsBgView;//用于显示小图标
@property(nonatomic,assign)CGFloat tagx;
@property(nonatomic,strong)UILabel *titleLab;//文章标题
@property(nonatomic,strong)UIView *first_line;//分隔线1
@property(nonatomic,strong)UIView *second_line;//分隔线2
@property(nonatomic,strong)UIView *third_line;//分隔线3
@property(nonatomic,strong)UILabel *arthorLab;//作者名称
@property(nonatomic,strong)UIButton *timeBtn;//时间
@property(nonatomic,strong)UIImageView *authorLogoView;//作者头像
@property(nonatomic,strong)UIImageView *coverView; //文章大图
@property(nonatomic,strong)UILabel *summaryLab;    //文件摘要

@end

@implementation MessageDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XCOLOR_WHITE;
        
//        self.catigory_logo =[[UIImageView alloc] init];
//        self.catigory_logo.image =[UIImage imageNamed:@"Detail_Life"];
//        self.catigory_logo.contentMode = UIViewContentModeScaleAspectFill;
//        [self addSubview:self.catigory_logo];
        
        self.catigoryLab =[[UILabel alloc] init];
        self.catigoryLab.font =[UIFont systemFontOfSize:14];
        [self addSubview:self.catigoryLab];
        
        self.tagsBgView =[[UIView alloc] init];
        [self addSubview:self.tagsBgView];
        
        self.first_line =[[UIView alloc] init];
        self.first_line.backgroundColor =XCOLOR_line;
        [self addSubview:self.first_line];
        
        
        self.second_line =[[UIView alloc] init];
        self.second_line.backgroundColor =XCOLOR_line;
        [self addSubview:self.second_line];
        
        
        self.titleLab =[[UILabel alloc] init];
        self.titleLab.font =  [UIFont fontWithName:@"Helvetica-Bold" size:24];
        self.titleLab.numberOfLines = 0;
        self.titleLab.textColor = XCOLOR_TITLE;
        [self addSubview:self.titleLab];
        
        
        self.arthorLab =[[UILabel alloc] init];
        self.arthorLab.font = [UIFont systemFontOfSize:14];
        [self.arthorLab sizeToFit];
        [self addSubview:self.arthorLab];
        self.arthorLab.textColor = XCOLOR_SUBTITLE;
        
        self.authorLogoView = [[UIImageView alloc] init];
        self.authorLogoView.layer.cornerRadius = 20;
        self.authorLogoView.layer.masksToBounds = YES;
        [self addSubview:self.authorLogoView];
        self.authorLogoView.image =[UIImage imageNamed:@"PlaceHolderImage"];
 
        self.timeBtn =[[UIButton alloc] init];
        self.timeBtn.enabled = NO;
        self.timeBtn.titleLabel.font =[UIFont systemFontOfSize:14];
        [self.timeBtn setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateNormal];
        [self addSubview:self.timeBtn];
        self.timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        self.coverView = [[UIImageView alloc] init];
        self.coverView.clipsToBounds = YES;
        [self addSubview:self.coverView];
        self.coverView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.summaryLab =[[UILabel alloc] init];
        self.summaryLab.font = [UIFont systemFontOfSize:SummaryFont];
        self.summaryLab.numberOfLines = 0;
        self.summaryLab.textColor = XCOLOR_DESC;
        self.summaryLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.summaryLab];
        
        self.third_line =[[UIView alloc] init];
        self.third_line.backgroundColor =XCOLOR_line;
        [self addSubview:self.third_line];
        
    }
    return self;
}


-(void)setMessageFrame:(MessageDetailFrame *)MessageFrame
{
    
    _MessageFrame = MessageFrame;
    
    self.catigoryLab.text =  MessageFrame.article.category;
    self.titleLab.text = MessageFrame.article.title;
    NSString *author_logo_str = MessageFrame.article.author_portrait_url;
    NSString *author_logo = [author_logo_str containsString:@"http"] ? author_logo_str : [NSString stringWithFormat:@"%@%@",DOMAINURL,author_logo_str];
    [self.authorLogoView sd_setImageWithURL:[NSURL URLWithString:author_logo]];
    self.arthorLab.text = MessageFrame.article.author;
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:MessageFrame.article.cover_url] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [self.timeBtn setTitle:MessageFrame.article.right_str  forState:UIControlStateNormal];
    
    self.catigoryLab.frame = MessageFrame.tag_title_Frame;
    self.tagsBgView.frame = MessageFrame.tagBg_Frame;
    self.first_line.frame = MessageFrame.first_line_frame;
    self.titleLab.frame = MessageFrame.title_Frame;
    self.arthorLab.frame = MessageFrame.arthor_Frame;
    self.coverView.frame = MessageFrame.cover_Frame;
    self.authorLogoView.frame = MessageFrame.icon_Frame;
    self.timeBtn.frame = MessageFrame.time_Frame;
    self.second_line.frame = MessageFrame.second_line_frame;
    self.summaryLab.frame = MessageFrame.summary_frame;
    self.summaryLab.text = MessageFrame.article.summary;
    self.third_line.frame = MessageFrame.third_line_frame;
    self.frame = MessageFrame.header_frame;

    
    for (NSInteger i = 0; i <  MessageFrame.tag_frames.count; i ++) {
        
        NSString *tag =  MessageFrame.article.tags[i];
        NSString *tag_frame_str =  MessageFrame.tag_frames[i];

        UILabel *tagBtn =[[UILabel alloc] init];
        tagBtn.font = XFONT(11);
        tagBtn.text = tag;
        tagBtn.textAlignment = NSTextAlignmentCenter;
        tagBtn.textColor = XCOLOR_SUBTITLE;
        tagBtn.layer.cornerRadius = CORNER_RADIUS;
        tagBtn.layer.masksToBounds = YES;
        tagBtn.backgroundColor = XCOLOR_BG;
        tagBtn.frame =  CGRectFromString(tag_frame_str);
        [self.tagsBgView addSubview:tagBtn];
        
    }
 
    
    
}
@end

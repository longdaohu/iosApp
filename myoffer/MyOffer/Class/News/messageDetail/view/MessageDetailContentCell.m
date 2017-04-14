//
//  MessageSecondTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#define TagHigh 24
#define SummaryFont 20
#define MARGIN 10

#import "MessageDetailContentCell.h"
#import "MessageDetailFrame.h"

@interface MessageDetailContentCell()
@property(nonatomic,strong)UIImageView *catigory_logo;    //分类图片
@property(nonatomic,strong)UILabel *catigoryLab;       //学校名称
@property(nonatomic,strong)UIView *tagsBgView;   //用于显示小图标
@property(nonatomic,assign)CGFloat tagx;
@property(nonatomic,strong)UILabel *titleLab;     //文章标题
@property(nonatomic,strong)UIView *FirstLine;   //分隔线1
@property(nonatomic,strong)UIView *SecondLine;      //分隔线2
@property(nonatomic,strong)UIView *ThreeLine;       //分隔线3
@property(nonatomic,strong)UILabel *ArthorLab;      //作者名称
@property(nonatomic,strong)UIButton *TimeBtn;       //时间
@property(nonatomic,strong)UIButton *FocusBtn;      //关注数量
@property(nonatomic,strong)UIImageView *authorLogoView;   //作者头像
@property(nonatomic,strong)UIImageView *coverView; //文章大图
@property(nonatomic,strong)UILabel *summaryLab;    //文件摘要

@end
@implementation MessageDetailContentCell

+(instancetype)CreateCellWithTableView:(UITableView *)tableView
{
    
    static NSString *Identifier = @"detailContent";
    
    MessageDetailContentCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        
        cell =[[MessageDetailContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.catigory_logo =[[UIImageView alloc] init];
        self.catigory_logo.image =[UIImage imageNamed:@"Detail_Life"];
        self.catigory_logo.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.catigory_logo];
        
        self.catigoryLab =[[UILabel alloc] init];
        self.catigoryLab.font =[UIFont systemFontOfSize:Uni_subject_FontSize];
        [self.contentView addSubview:self.catigoryLab];
        
        self.tagsBgView =[[UIView alloc] init];
        [self.contentView addSubview:self.tagsBgView];
        
        self.FirstLine =[[UIView alloc] init];
        self.FirstLine.backgroundColor =XCOLOR_BG;
        [self.contentView addSubview:self.FirstLine];
        
        
        self.SecondLine =[[UIView alloc] init];
        self.SecondLine.backgroundColor =XCOLOR_BG;
        [self.contentView addSubview:self.SecondLine];
        
        
        self.titleLab =[[UILabel alloc] init];
        self.titleLab.font =  [UIFont fontWithName:@"Helvetica-Bold" size:24];
        self.titleLab.numberOfLines = 0;
        [self.contentView addSubview:self.titleLab];
        
        
        self.ArthorLab =[[UILabel alloc] init];
        self.ArthorLab.font = [UIFont systemFontOfSize:14];
        [self.ArthorLab sizeToFit];
        [self.contentView addSubview:self.ArthorLab];
        
        
        self.authorLogoView = [[UIImageView alloc] init];
        self.authorLogoView.layer.cornerRadius = 20;
        self.authorLogoView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.authorLogoView];
        self.authorLogoView.image =[UIImage imageNamed:@"PlaceHolderImage"];

        self.TimeBtn =[[UIButton alloc] init];
         [self.TimeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];

        self.TimeBtn.enabled = NO;
        self.TimeBtn.titleLabel.font =[UIFont systemFontOfSize:14];
        [self.TimeBtn setTitleColor:XCOLOR_DARKGRAY forState:UIControlStateNormal];
        [self.TimeBtn setImage:[UIImage imageNamed:@"Detail_time"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.TimeBtn];
        
        self.FocusBtn =[[UIButton alloc] init];
         [self.FocusBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [self.FocusBtn setTitleColor:XCOLOR_DARKGRAY  forState:UIControlStateNormal];
        self.FocusBtn.enabled = NO;
        self.FocusBtn.titleLabel.font =[UIFont systemFontOfSize:14];
        [self.FocusBtn setImage:[UIImage imageNamed:@"Detail_Focus"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.FocusBtn];
        
        self.coverView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.coverView];
        self.coverView.contentMode = UIViewContentModeScaleAspectFit;

        self.summaryLab =[[UILabel alloc] init];
        self.summaryLab.font = [UIFont systemFontOfSize:SummaryFont];
        self.summaryLab.numberOfLines = 0;
        self.summaryLab.textColor = XCOLOR_DARKGRAY;
        self.summaryLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.summaryLab];
        
        self.ThreeLine =[[UIView alloc] init];
        self.ThreeLine.backgroundColor =XCOLOR_BG;
        [self.contentView addSubview:self.ThreeLine];
        
        
    }
    
    return self;
}


-(void)setMessageFrame:(MessageDetailFrame *)MessageFrame
{

    _MessageFrame = MessageFrame;
    
    self.catigory_logo.frame = MessageFrame.catigory_logo_Frame;
    self.catigory_logo.image =[UIImage imageNamed:MessageFrame.TagImageName];
    
    self.catigoryLab.text =  MessageFrame.article.category;
    self.catigoryLab.frame = MessageFrame.tag_title_Frame;
    
    self.tagsBgView.frame = MessageFrame.tagBg_Frame;
    self.FirstLine.frame = MessageFrame.FirstLineFrame;
    
    self.titleLab.text = MessageFrame.article.title;
    self.titleLab.frame = MessageFrame.title_Frame;
    
    
    NSString *author_logo_str = MessageFrame.article.author_portrait_url;
    NSString *author_logo = [author_logo_str containsString:@"http"] ? author_logo_str : [NSString stringWithFormat:@"%@%@",DOMAINURL,author_logo_str];
    [self.authorLogoView sd_setImageWithURL:[NSURL URLWithString:author_logo]];
    self.authorLogoView.frame = MessageFrame.icon_Frame;
    
    self.ArthorLab.text = MessageFrame.article.author;
    self.ArthorLab.frame = MessageFrame.Arthor_Frame;
    
    CGSize ArthorSize = [MessageFrame.article.author KD_sizeWithAttributeFont:[UIFont systemFontOfSize:14]];
    CGRect newRect  = self.ArthorLab.frame;
    newRect.size.width = ArthorSize.width;
    self.ArthorLab.frame = newRect;
    
    NSString  *path = [MessageFrame.article.cover_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];

    self.coverView.frame = MessageFrame.cover_Frame;
    
    [self.TimeBtn setTitle:MessageFrame.article.update_at forState:UIControlStateNormal];
    self.TimeBtn.frame = MessageFrame.time_Frame;
    
    NSString *view_count = MessageFrame.article.view_count;
    [self.FocusBtn setTitle:view_count forState:UIControlStateNormal];
    self.FocusBtn.frame = MessageFrame.focus_Frame;
    
    self.SecondLine.frame = MessageFrame.SecondLineFrame;
    
    self.summaryLab.frame = MessageFrame.Summary_Frame;
    self.summaryLab.text = MessageFrame.article.summary;
    self.ThreeLine.frame = MessageFrame.ThreeLineFrame;
    
    if (self.tagx > 0) {
        
        return;
    }
    
    NSInteger count =   MessageFrame.article.tags.count;
    
    for (NSInteger i = 0; i < count; i ++) {
        
        NSString *tag =   MessageFrame.article.tags[i];
        
        CGSize tagSize = [tag KD_sizeWithAttributeFont:[UIFont systemFontOfSize:Uni_subject_FontSize]];
        
        CGFloat ty = 0;
        CGFloat tw = tagSize.width + 15;
        CGFloat th = TagHigh;
        self.tagx += (MARGIN +tw);
        CGFloat tx = self.tagsBgView.bounds.size.width - self.tagx;
        
        UILabel *tagLabel =[[UILabel alloc] init];
        tagLabel.font = [UIFont systemFontOfSize:Uni_subject_FontSize];
        tagLabel.frame = CGRectMake(tx, ty, tw, th);
        tagLabel.text = tag;
        tagLabel.textColor =XCOLOR_WHITE;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.layer.cornerRadius = 0.5 * TagHigh;
        tagLabel.layer.masksToBounds = YES;
        tagLabel.backgroundColor = XCOLOR_DARKGRAY;
        [self.tagsBgView addSubview:tagLabel];
        
        if (self.tagx > self.tagsBgView.frame.size.width) {
            
            tagLabel.hidden = YES;
        }
    }

    
    
}
@end

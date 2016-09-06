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
@property(nonatomic,strong)UIImageView *TagView;    //分类图片
@property(nonatomic,strong)UILabel *TagLabel;       //学校名称
@property(nonatomic,strong)UIView *TagBackground;   //用于显示小图标
@property(nonatomic,assign)CGFloat tagx;
@property(nonatomic,strong)UILabel *TitleLabel;     //文章标题
@property(nonatomic,strong)UIView *FirstLineView;   //分隔线1
@property(nonatomic,strong)UIView *SecondLine;      //分隔线2
@property(nonatomic,strong)UIView *ThreeLine;       //分隔线3
@property(nonatomic,strong)UILabel *ArthorLab;      //作者名称
@property(nonatomic,strong)UIButton *TimeBtn;       //时间
@property(nonatomic,strong)UIButton *FocusBtn;      //关注数量
@property(nonatomic,strong)UIImageView *LogoView;   //作者头像
@property(nonatomic,strong)UIImageView *ArticleImageView; //文章大图
@property(nonatomic,strong)UILabel *SummaryLabel;    //文件摘要

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
        
        self.TagView =[[UIImageView alloc] init];
        self.TagView.image =[UIImage imageNamed:@"Detail_Life"];
        self.TagView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.TagView];
        
        self.TagLabel =[[UILabel alloc] init];
        self.TagLabel.font =[UIFont systemFontOfSize:UNIVERISITYTITLEFONT];
        [self.contentView addSubview:self.TagLabel];
        
        self.TagBackground =[[UIView alloc] init];
        [self.contentView addSubview:self.TagBackground];
        
        self.FirstLineView =[[UIView alloc] init];
        self.FirstLineView.backgroundColor =BACKGROUDCOLOR;
        [self.contentView addSubview:self.FirstLineView];
        
        
        self.SecondLine =[[UIView alloc] init];
        self.SecondLine.backgroundColor =BACKGROUDCOLOR;
        [self.contentView addSubview:self.SecondLine];
        
        
        self.TitleLabel =[[UILabel alloc] init];
        self.TitleLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:24];
        self.TitleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.TitleLabel];
        
        
        self.ArthorLab =[[UILabel alloc] init];
        self.ArthorLab.font = [UIFont systemFontOfSize:14];
        [self.ArthorLab sizeToFit];
        [self.contentView addSubview:self.ArthorLab];
        
        
        
        self.LogoView = [[UIImageView alloc] init];
        self.LogoView.layer.cornerRadius = 20;
        self.LogoView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.LogoView];
        
        
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
        
        self.ArticleImageView = [[UIImageView alloc] init];
//        self.ArticleImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.ArticleImageView];
        
        self.SummaryLabel =[[UILabel alloc] init];
        self.SummaryLabel.font = [UIFont systemFontOfSize:SummaryFont];
        self.SummaryLabel.numberOfLines = 0;
        self.SummaryLabel.textColor = XCOLOR_DARKGRAY;
        self.SummaryLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.SummaryLabel];
        
        self.ThreeLine =[[UIView alloc] init];
        self.ThreeLine.backgroundColor =BACKGROUDCOLOR;
        [self.contentView addSubview:self.ThreeLine];
        
        
    }
    
    return self;
}

-(void)setMessageFrame:(MessageDetailFrame *)MessageFrame
{

    _MessageFrame = MessageFrame;
    
    self.TagView.frame = MessageFrame.TagFrame;
    self.TagView.image =[UIImage imageNamed:MessageFrame.TagImageName];
    
    self.TagLabel.text = MessageFrame.MessageDetail[@"category"];
    self.TagLabel.frame = MessageFrame.TagLabFrame;
    
    self.TagBackground.frame = MessageFrame.TagBgFrame;
    self.FirstLineView.frame = MessageFrame.FirstLineFrame;
    
    self.TitleLabel.text = MessageFrame.MessageDetail[@"title"];
    self.TitleLabel.frame = MessageFrame.TitleFrame;
    
    [self.LogoView KD_setImageWithURL:MessageFrame.MessageDetail[@"author_portrait_url"]];
    self.LogoView.frame = MessageFrame.LogoFrame;
    
    self.ArthorLab.text = MessageFrame.MessageDetail[@"author"];
    self.ArthorLab.frame = MessageFrame.ArthorFrame;
    CGSize ArthorSize = [MessageFrame.MessageDetail[@"author"] KD_sizeWithAttributeFont:[UIFont systemFontOfSize:14]];
    CGRect newRect  = self.ArthorLab.frame;
    newRect.size.width = ArthorSize.width;
    self.ArthorLab.frame = newRect;
    
    NSString  *path = [MessageFrame.MessageDetail[@"cover_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.ArticleImageView KD_setImageWithURL:path];
    self.ArticleImageView.frame = MessageFrame.ArticleMVFrame;
    
    [self.TimeBtn setTitle:MessageFrame.MessageDetail[@"update_at"] forState:UIControlStateNormal];
    self.TimeBtn.frame = MessageFrame.TimeFrame;
    
    NSString *view_count = [NSString stringWithFormat:@"%@",MessageFrame.MessageDetail[@"view_count"]];
    [self.FocusBtn setTitle:view_count forState:UIControlStateNormal];
    self.FocusBtn.frame = MessageFrame.FocusFrame;
    
    self.SecondLine.frame = MessageFrame.SecondLineFrame;
    
    self.SummaryLabel.frame = MessageFrame.SummaryFrame;
    self.SummaryLabel.text = MessageFrame.MessageDetail[@"summary"];
    self.ThreeLine.frame = MessageFrame.ThreeLineFrame;
    
    if (self.tagx > 0) {
        
        return;
    }
    
    NSInteger count =  [MessageFrame.MessageDetail[@"tags"] count];
    
    for (NSInteger i = 0; i < count; i ++) {
        
        NSString *tag =  MessageFrame.MessageDetail[@"tags"][i];
        
        CGSize tagSize = [tag KD_sizeWithAttributeFont:[UIFont systemFontOfSize:UNIVERISITYTITLEFONT]];
        
        CGFloat ty = 0;
        CGFloat tw = tagSize.width + 15;
        CGFloat th = TagHigh;
        self.tagx += (MARGIN +tw);
        CGFloat tx = self.TagBackground.bounds.size.width - self.tagx;
        
        UILabel *tagLabel =[[UILabel alloc] init];
        tagLabel.font = [UIFont systemFontOfSize:UNIVERISITYTITLEFONT];
        tagLabel.frame = CGRectMake(tx, ty, tw, th);
        tagLabel.text = tag;
        tagLabel.textColor =XCOLOR_WHITE;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.layer.cornerRadius = 0.5 * TagHigh;
        tagLabel.layer.masksToBounds = YES;
        tagLabel.backgroundColor = XCOLOR_DARKGRAY;
        [self.TagBackground addSubview:tagLabel];
        
        if (self.tagx > self.TagBackground.frame.size.width) {
            
            tagLabel.hidden = YES;
        }
    }

    
    
}
@end

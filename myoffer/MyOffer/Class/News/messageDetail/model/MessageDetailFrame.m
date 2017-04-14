//
//  MessageTitleObj.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#define MARGIN 10
#define TagIconWidth 40
#define ArthorLogoWidth 40
#define LabHeight 20
#define SummaryFont 20
#define LineHeight 1
#import "MessageDetailFrame.h"
@interface MessageDetailFrame ()
@property(nonatomic,strong)NSArray *tags;
@property(nonatomic,strong)NSArray *tagImageNames;

@end

@implementation MessageDetailFrame

+ (instancetype)frameWithArticle:(MessageArticle *)article{

    MessageDetailFrame *detailFrame = [[MessageDetailFrame alloc] init];
   
    detailFrame.article = article;
    
    return detailFrame;
}


-(NSArray *)tags
{
    if (!_tags) {
        _tags = @[@"留学生活",@"留学申请",@"留学费用",@"留学考试",@"留学新闻",@"留学签证"];
    }
    return _tags;
}

-(NSArray *)tagImageNames
{
    if (!_tagImageNames) {
        
        _tagImageNames = @[@"Detail_Life",@"Detail_Request",@"Detail_Fee",@"Detail_Test",@"Detail_News",@"Detail_Visa"];
    }
    return _tagImageNames;
}


- (void)setArticle:(MessageArticle *)article{

    _article = article;
    
    CGFloat c_logo_X = MARGIN;
    CGFloat c_logo_Y = MARGIN;
    CGFloat c_logo_W = TagIconWidth;
    CGFloat c_logo_H = c_logo_W;
    self.catigory_logo_Frame = CGRectMake(c_logo_X, c_logo_Y, c_logo_W, c_logo_H);
    
    CGFloat tag_title_h = LabHeight;
    CGFloat tag_title_x = CGRectGetMaxX(self.catigory_logo_Frame) + 5;
    CGFloat tag_title_y = CGRectGetMinY(self.catigory_logo_Frame) + 0.5 * (c_logo_H - tag_title_h);
    CGFloat tag_title_w = 80;
    self.tag_title_Frame = CGRectMake(tag_title_x, tag_title_y, tag_title_w, tag_title_h);
    
    CGFloat TagBg_h = tag_title_h;
    CGFloat TagBg_x = CGRectGetMaxX(self.tag_title_Frame);
    CGFloat TagBg_y = tag_title_y;
    CGFloat TagBg_w = XSCREEN_WIDTH - TagBg_x;
    self.tagBg_Frame = CGRectMake(TagBg_x,TagBg_y,TagBg_w,TagBg_h);
    
    CGFloat ONEx = MARGIN;
    CGFloat ONEy = CGRectGetMaxY(self.catigory_logo_Frame) + MARGIN;
    CGFloat ONEw = XSCREEN_WIDTH - MARGIN;
    CGFloat ONEh = LineHeight;
    self.FirstLineFrame = CGRectMake(ONEx,ONEy,ONEw,ONEh);
    
    
    CGFloat title_x = MARGIN;
    CGFloat title_y = CGRectGetMaxY(self.FirstLineFrame) +MARGIN;
    CGFloat title_w = XSCREEN_WIDTH - title_x * 2;
    CGSize title_size = [article.title boundingRectWithSize:CGSizeMake(title_w, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:24]}context:nil].size;
    self.title_Frame = CGRectMake(title_x, title_y, title_w , title_size.height);
    
    
    CGFloat icon_x = MARGIN;
    CGFloat icon_y = CGRectGetMaxY(self.title_Frame) +MARGIN;
    CGFloat icon_w = ArthorLogoWidth;
    CGFloat icon_h = icon_w;
    self.icon_Frame = CGRectMake(icon_x, icon_y, icon_w, icon_h);
    
    CGFloat Arthor_x = CGRectGetMaxX(self.icon_Frame)+ MARGIN;
    CGFloat Arthor_y = CGRectGetMinY(self.icon_Frame) + MARGIN;
    CGFloat Arthor_w = 0;
    CGFloat Arthor_h = LabHeight;
    self.Arthor_Frame = CGRectMake(Arthor_x, Arthor_y, Arthor_w, Arthor_h);
    
    CGFloat time_y = Arthor_y;
    CGFloat time_w = 110 ;
    CGFloat time_h = LabHeight;
    CGFloat time_x = XSCREEN_WIDTH - time_w - MARGIN;
    self.time_Frame = CGRectMake(time_x,time_y, time_w , time_h);
    
    CGFloat focus_y = Arthor_y;
    CGFloat focus_w = 100 ;
    CGFloat focus_h = LabHeight;
    CGFloat focus_x = time_x - focus_w;
    self.focus_Frame = CGRectMake(focus_x,focus_y, focus_w , focus_h);
    
    CGFloat cover_X =  0;
    CGFloat cover_Y =  CGRectGetMaxY(self.icon_Frame) + MARGIN;
    CGFloat cover_W =  XSCREEN_WIDTH;
    CGFloat cover_H =  cover_W * 29.3/83;
    self.cover_Frame = CGRectMake(cover_X, cover_Y,cover_W, cover_H);
    
    CGFloat SECy = CGRectGetMaxY(self.cover_Frame) + MARGIN * 4;
    CGFloat SECw = XSCREEN_WIDTH * 0.5;
    CGFloat SECx = SECw * 0.5;
    CGFloat SECh = LineHeight;
    self.SecondLineFrame = CGRectMake(SECx, SECy, SECw, SECh);
    
    CGFloat Summary_y = CGRectGetMaxY(self.SecondLineFrame) + MARGIN * 4;
    CGFloat Summary_x = 2 * MARGIN;
    CGFloat Summary_w = XSCREEN_WIDTH - 4 * MARGIN;
    CGSize SUsize = [article.summary boundingRectWithSize:CGSizeMake(Summary_w, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:SummaryFont]}context:nil].size;
    self.Summary_Frame = CGRectMake(Summary_x, Summary_y,SUsize.width, SUsize.height);
    
    
    
    self.ThreeLineFrame = CGRectMake(SECx, CGRectGetMaxY(self.Summary_Frame) + 4 * MARGIN, SECw, LineHeight);
    
    self.MessageDetailHeight = CGRectGetMaxY(self.ThreeLineFrame) + MARGIN * 2;
    
    self.TagImageName =self.tagImageNames[0];
    
    if ([self.tags containsObject:article.category]) {
        
        NSInteger index =[self.tags indexOfObject:article.category];
        
        self.TagImageName =self.tagImageNames[index];
    }
     
    
    
}


@end

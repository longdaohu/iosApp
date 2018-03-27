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
    
    CGFloat tag_title_h = LabHeight;
    CGFloat tag_title_x = MARGIN;
    CGFloat tag_title_y = MARGIN * 2;
    CGFloat tag_title_w = 80;
    self.tag_title_Frame = CGRectMake(tag_title_x, tag_title_y, tag_title_w, tag_title_h);
    
    CGFloat TagBg_h = tag_title_h;
    CGFloat TagBg_x = CGRectGetMaxX(self.tag_title_Frame);
    CGFloat TagBg_y = tag_title_y;
    CGFloat TagBg_w = XSCREEN_WIDTH - TagBg_x;
    self.tagBg_Frame = CGRectMake(TagBg_x,TagBg_y,TagBg_w,TagBg_h);
    
    CGFloat ONEx = MARGIN;
    CGFloat ONEy = CGRectGetMaxY(self.tag_title_Frame) + tag_title_y;
    CGFloat ONEw = XSCREEN_WIDTH - MARGIN;
    CGFloat ONEh = LineHeight;
    self.first_line_frame = CGRectMake(ONEx,ONEy,ONEw,ONEh);
    
    
    CGFloat title_x = MARGIN;
    CGFloat title_y = CGRectGetMaxY(self.first_line_frame) +MARGIN;
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
    CGSize arthor_size = [article.author boundingRectWithSize:CGSizeMake(title_w, 0) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]}context:nil].size;
    CGFloat Arthor_w = arthor_size.width;
    CGFloat Arthor_h = LabHeight;
    self.arthor_Frame = CGRectMake(Arthor_x, Arthor_y, Arthor_w, Arthor_h);
    
    CGFloat time_y = Arthor_y;
    CGFloat time_w = ONEw;
    CGFloat time_h = LabHeight;
    CGFloat time_x = XSCREEN_WIDTH - time_w - icon_x;
    self.time_Frame = CGRectMake(time_x,time_y, time_w , time_h);
    
    CGFloat cover_X =  0;
    CGFloat cover_Y =  CGRectGetMaxY(self.icon_Frame) + MARGIN;
    CGFloat cover_W =  XSCREEN_WIDTH;
    CGFloat cover_H =  cover_W * 29.3/83;
    self.cover_Frame = CGRectMake(cover_X, cover_Y,cover_W, cover_H);
    
    CGFloat SECy = CGRectGetMaxY(self.cover_Frame) + MARGIN * 4;
    CGFloat SECw = XSCREEN_WIDTH * 0.5;
    CGFloat SECx = SECw * 0.5;
    CGFloat SECh = LineHeight;
    self.second_line_frame = CGRectMake(SECx, SECy, SECw, SECh);
    
    CGFloat Summary_y = CGRectGetMaxY(self.second_line_frame) + MARGIN * 4;
    CGFloat Summary_x = 2 * MARGIN;
    CGFloat Summary_w = XSCREEN_WIDTH - 4 * MARGIN;
    CGSize SUsize = [article.summary boundingRectWithSize:CGSizeMake(Summary_w, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:SummaryFont]}context:nil].size;
    self.summary_frame = CGRectMake(Summary_x, Summary_y,SUsize.width, SUsize.height);
    
    self.third_line_frame = CGRectMake(SECx, CGRectGetMaxY(self.summary_frame) + 4 * MARGIN, SECw, LineHeight);
    
    CGFloat header_height = CGRectGetMaxY(self.third_line_frame) + MARGIN * 2;
    self.header_frame = CGRectMake(0, 0, XSCREEN_WIDTH, header_height);
    
    CGFloat tag_y = 0;
    CGFloat tag_w = 0;
    CGFloat tag_h = TagBg_h;
    CGFloat tag_x = TagBg_w;
    
    NSMutableArray *tags_tmp = [NSMutableArray array];
    
    for (NSInteger index = 0; index < article.tags.count; index++) {
        
        CGSize tagSize = [article.tags[index] KD_sizeWithAttributeFont:XFONT(11)];
        tag_w = tagSize.width + MARGIN;
        tag_x -= (tag_w + MARGIN);
        CGRect tag_rect = CGRectMake(tag_x, tag_y, tag_w, tag_h);
        if (tag_x < 0) break;
        [tags_tmp addObject:NSStringFromCGRect(tag_rect)];
    }
    
    self.tag_frames = [tags_tmp copy];
    
}


@end

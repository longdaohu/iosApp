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
+ (instancetype)frameWithDictionary:(NSDictionary *)messageInfo{

    MessageDetailFrame *detailFrame = [[MessageDetailFrame alloc] init];
   
    detailFrame.MessageDetail = messageInfo;
    
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


-(void)setMessageDetail:(NSDictionary *)MessageDetail
{
    _MessageDetail = MessageDetail;
  
    CGFloat TGx = MARGIN;
    CGFloat TGy = MARGIN;
    CGFloat TGw = TagIconWidth;
    CGFloat TGh = TGw;
    self.TagFrame = CGRectMake(TGx, TGy, TGw, TGh);
    
    CGFloat TLh = LabHeight;
    CGFloat TLx = CGRectGetMaxX(self.TagFrame) + 5;
    CGFloat TLy = CGRectGetMinY(self.TagFrame) + 0.5 * (TGh - TLh);
    CGFloat TLw = 80;
    self.TagLabFrame = CGRectMake(TLx, TLy, TLw, TLh);
    
    CGFloat TBh = TLh;
    CGFloat TBx = CGRectGetMaxX(self.TagLabFrame);
    CGFloat TBy = TLy;
    CGFloat TBw = APPSIZE.width - TBx;
    self.TagBgFrame = CGRectMake(TBx,TBy,TBw,TBh);
    
    CGFloat ONEx = MARGIN;
    CGFloat ONEy = CGRectGetMaxY(self.TagFrame) + MARGIN;
    CGFloat ONEw = APPSIZE.width - MARGIN;
    CGFloat ONEh = LineHeight;
    self.FirstLineFrame = CGRectMake(ONEx,ONEy,ONEw,ONEh);
    
    
    CGFloat Tx = MARGIN;
    CGFloat Ty = CGRectGetMaxY(self.FirstLineFrame) +MARGIN;
    CGFloat Tw = APPSIZE.width - Tx * 2;
    CGSize Tsize = [MessageDetail[@"title"] boundingRectWithSize:CGSizeMake(Tw, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:24]}context:nil].size;
    self.TitleFrame = CGRectMake(Tx, Ty,Tw , Tsize.height);
    
    
    CGFloat Lx = MARGIN;
    CGFloat Ly = CGRectGetMaxY(self.TitleFrame) +MARGIN;
    CGFloat Lw = ArthorLogoWidth;
    CGFloat Lh = Lw;
    self.LogoFrame = CGRectMake(Lx, Ly, Lw, Lh);
    
    CGFloat Ax = CGRectGetMaxX(self.LogoFrame)+ MARGIN;
    CGFloat Ay = CGRectGetMinY(self.LogoFrame) + MARGIN;
    CGFloat Aw = 0;
    CGFloat Ah = LabHeight;
    self.ArthorFrame = CGRectMake(Ax, Ay, Aw, Ah);
    
    CGFloat TMy = Ay;
    CGFloat TMw = 110 ;
    CGFloat TMh = LabHeight;
    CGFloat TMx = APPSIZE.width - TMw - MARGIN;
    self.TimeFrame = CGRectMake(TMx,TMy, TMw , TMh);
    
    CGFloat FCy = Ay;
    CGFloat FCw = 100 ;
    CGFloat FCh = LabHeight;
    CGFloat FCx = TMx - FCw;
    self.FocusFrame = CGRectMake(FCx,FCy, FCw , FCh);
    
    CGFloat AMy = CGRectGetMaxY(self.LogoFrame) + MARGIN;
    CGFloat AMh = 200 * XScreenWidth / 320.0;
    CGFloat AMw = XScreenWidth;
    self.ArticleMVFrame = CGRectMake(0, AMy,AMw, AMh);
    
    CGFloat SECy = CGRectGetMaxY(self.ArticleMVFrame) + MARGIN * 4;
    CGFloat SECw = XScreenWidth * 0.5;
    CGFloat SECx = SECw * 0.5;
    CGFloat SECh = LineHeight;
    self.SecondLineFrame = CGRectMake(SECx, SECy, SECw, SECh);
    
    CGFloat SUy = CGRectGetMaxY(self.SecondLineFrame) + MARGIN * 4;
    CGFloat SUx = 2 * MARGIN;
    CGFloat SUw = XScreenWidth - 4 * MARGIN;
    CGSize SUsize = [MessageDetail[@"summary"] boundingRectWithSize:CGSizeMake(SUw, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:SummaryFont]}context:nil].size;
    self.SummaryFrame = CGRectMake(SUx, SUy,SUsize.width, SUsize.height);
   
    
    
    self.ThreeLineFrame = CGRectMake(SECx, CGRectGetMaxY(self.SummaryFrame) + 4 * MARGIN, SECw, LineHeight);
    
    self.MessageDetailHeight = CGRectGetMaxY(self.ThreeLineFrame) + MARGIN * 2;
    
    self.TagImageName =self.tagImageNames[0];
    
    if ([self.tags containsObject:MessageDetail[@"category"]]) {
        
        NSInteger index =[self.tags indexOfObject:MessageDetail[@"category"]];
        
        self.TagImageName =self.tagImageNames[index];
    }
}


@end

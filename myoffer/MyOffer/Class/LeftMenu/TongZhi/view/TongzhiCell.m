//
//  NotiTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/31.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "TongzhiCell.h"
#import "NotiItem.h"


@interface TongzhiCell ()
//图片
@property(nonatomic,strong)UIImageView *logoView;
//标题
@property(nonatomic,strong)UILabel *titleLab;
//时间
@property(nonatomic,strong)UILabel *timeLab;
//描述
@property(nonatomic,strong)UILabel *subTitleLab;
//未读消息小红点
@property(nonatomic,strong)UIView *redSpotsView;

@property(nonatomic,strong)UIView *line;

@end

@implementation TongzhiCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identi = @"noti";
    TongzhiCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (!cell) {
     
        cell =[[TongzhiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
    }
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.logoView =[[UIImageView alloc] init];
        [self.contentView addSubview:self.logoView];
        
        self.redSpotsView=[[UIView alloc] init];
        [self.contentView addSubview:self.redSpotsView];
        self.redSpotsView.backgroundColor = [UIColor redColor];
        self.redSpotsView.layer.cornerRadius = 4;
        
        self.titleLab =[UILabel labelWithFontsize:18 TextColor:XCOLOR_TITLE TextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLab];
        
        self.timeLab = [UILabel labelWithFontsize: 12 TextColor:XCOLOR_SUBTITLE TextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.timeLab];
        
        self.subTitleLab = [UILabel labelWithFontsize: 14 TextColor:XCOLOR_SUBTITLE TextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.subTitleLab];
        
        self.line=[[UIView alloc] init];
        [self.contentView addSubview:self.line];
        self.line.backgroundColor = XCOLOR_line;
        
        
     }
    return self;
}

- (void)setNoti:(NotiItem *)noti
{
    _noti  = noti;
    
    self.titleLab.text   = noti.category;
    [self.titleLab sizeToFit];
    
    self.subTitleLab.text   = noti.summary;
    [self.subTitleLab sizeToFit];

    self.timeLab.text       = noti.create_time_short;
    [self.timeLab sizeToFit];
    
    NSString *imageName   =  [noti.category_id integerValue] == 0 ? @"noti_blue" : @"noti_yellow";
    self.logoView.image   =  [UIImage imageNamed:imageName];
    self.redSpotsView.hidden = noti.state.length;

}


- (void)separatorLineShow:(BOOL)show{

    self.line.hidden = show;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = self.contentView.bounds.size;
    
    CGFloat logo_H = 50;
    CGFloat logo_W = logo_H;
    CGFloat logo_X = 10;
    CGFloat logo_Y = (contentSize.height - logo_H) * 0.5;
    self.logoView.frame =CGRectMake(logo_X, logo_Y, logo_W, logo_H);
    
    CGFloat redw = 8;
    CGFloat redh = redw;
    CGFloat redx = CGRectGetMaxX(self.logoView.frame) - redw;
    CGFloat redy =  logo_Y;
    self.redSpotsView.frame =CGRectMake(redx, redy, redw, redh);
    
    
    CGFloat time_H = self.timeLab.mj_h;
    CGFloat time_W = self.timeLab.mj_w;
    CGFloat time_X =  contentSize.width - time_W - logo_X;
    CGFloat timeY = logo_Y;
    self.timeLab.frame =CGRectMake(time_X, timeY, time_W, time_H);
    
    
    CGFloat title_X = CGRectGetMaxX(self.logoView.frame) + logo_X;
    CGFloat title_Y = logo_Y;
    CGFloat title_W = self.titleLab.mj_w;
    CGFloat title_H = self.titleLab.mj_h;
    self.titleLab.frame = CGRectMake(title_X, title_Y, title_W, title_H);

    
    CGFloat sub_X = title_X;
    CGFloat sub_W = self.subTitleLab.mj_w;
    CGFloat sub_H = self.subTitleLab.mj_h;
    CGFloat sub_Y = CGRectGetMaxY(self.logoView.frame) - sub_H;
    self.subTitleLab.frame =CGRectMake(sub_X, sub_Y, sub_W, sub_H);
    
    CGFloat line_X = title_X;
    CGFloat line_W = contentSize.width;
    CGFloat line_H = LINE_HEIGHT;
    CGFloat line_Y = contentSize.height - line_H;
    self.line.frame =CGRectMake(line_X, line_Y, line_W, line_H);
    
}

 

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

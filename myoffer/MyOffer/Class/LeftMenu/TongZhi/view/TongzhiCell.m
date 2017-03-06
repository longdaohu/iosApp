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


@end

@implementation TongzhiCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identi = @"noti";
    TongzhiCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (!cell) {
     
        cell =[[TongzhiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        self.redSpotsView.layer.cornerRadius = 6;
        
        self.titleLab =[UILabel labelWithFontsize:XPERCENT * 15 TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLab];
        
        self.timeLab = [UILabel labelWithFontsize:XPERCENT * 12 TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.timeLab];
        
        self.subTitleLab = [UILabel labelWithFontsize:XPERCENT * 13 TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.subTitleLab];
        
     }
    return self;
}

-(void)setNoti:(NotiItem *)noti
{
    _noti  = noti;
    
    self.titleLab.text      = noti.category;
    self.subTitleLab.text   = noti.summary;
    self.timeLab.text       = noti.create_at;
    NSString *imageName     =  [noti.category_id integerValue] == 0 ? @"noti_blue" : @"noti_yellow";
    self.logoView.image     =  [UIImage imageNamed:imageName];
    self.redSpotsView.hidden = noti.state.length;

}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = self.contentView.bounds.size;
    
    CGFloat logox = 10;
    CGFloat logoy = 20;
    CGFloat logoh = contentSize.height - logoy * 2;
    CGFloat logow = logoh;
    self.logoView.frame =CGRectMake(logox, logoy, logow, logoh);
    

    CGFloat redw = 12;
    CGFloat redh = redw;
    CGFloat redx = CGRectGetMaxX(self.logoView.frame) - redw;
    CGFloat redy = logoy;
    self.redSpotsView.frame =CGRectMake(redx, redy, redw, redh);
    
    CGFloat titleX = CGRectGetMaxX(self.logoView.frame) + ITEM_MARGIN;
    CGFloat titleY = logoy;
    CGFloat titleW = XSCREEN_WIDTH - titleX - 2 * ITEM_MARGIN;
    CGFloat titleH = XPERCENT * 15;
    self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);

    
    CGFloat subX = titleX;
    CGFloat subW = titleW;
    CGFloat subH = XPERCENT * 13;
    CGFloat subY = CGRectGetMaxY(self.logoView.frame) - subH;
    self.subTitleLab.frame =CGRectMake(subX, subY, subW, subH);
    
    CGFloat timeX = titleX;
    CGFloat timeW = titleW;
    CGFloat timeH = XPERCENT * 12;
    CGFloat timeY = self.logoView.center.y - timeH * 0.5;
    self.timeLab.frame =CGRectMake(timeX, timeY, timeW, timeH);
    
}

 

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

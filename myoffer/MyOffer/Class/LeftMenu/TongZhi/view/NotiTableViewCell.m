//
//  NotiTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/31.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "NotiTableViewCell.h"
#import "NotiItem.h"

@interface NotiTableViewCell ()
@property(nonatomic,strong)UIImageView *logoView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *timeLab;
@property(nonatomic,strong)UILabel *subTitleLab;


@end

@implementation NotiTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identi = @"noti";
    NotiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (!cell) {
     
        cell =[[NotiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
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
        
        self.NewImageView=[[UIImageView alloc] init];
        self.NewImageView.layer.cornerRadius = 5;
        self.NewImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.NewImageView];
        
        
        self.titleLab =[UILabel labelWithFontsize:18 TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLab];
        
        self.timeLab = [UILabel labelWithFontsize:14 TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.timeLab];
        
        self.subTitleLab = [UILabel labelWithFontsize:16 TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentLeft];
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
    self.logoView.image     = [UIImage imageNamed:imageName];
    UIImage *newImage       = noti.state.length ? nil:[UIImage imageNamed:@"message_dot"];
    self.NewImageView.image = newImage;
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat cx = 10;
    CGFloat cy = 20;
    CGFloat cw = 60;
    CGFloat ch = 60;
    self.logoView.frame =CGRectMake(cx, cy, cw, ch);
    
    CGFloat nx = CGRectGetMaxX(self.logoView.frame) - 12;
    CGFloat ny = 30;
    CGFloat nw = 10;
    CGFloat nh = 10;
    self.NewImageView.frame =CGRectMake(nx, ny, nw, nh);
    
    CGFloat nox = CGRectGetMaxX(self.logoView.frame) + 10;
    CGFloat noy = 10;
    CGFloat now = APPSIZE.width - nox - 20;
    CGFloat noh = 20;
    self.titleLab.frame = CGRectMake(nox, noy, now, noh);
    
    
    CGFloat tx = nox;
    CGFloat ty = CGRectGetMaxY(self.titleLab.frame)+10;
    CGFloat tw = now;
    CGFloat th = 20;
    self.timeLab.frame =CGRectMake(tx, ty, tw, th);
    
    CGFloat dx = nox;
    CGFloat dy = CGRectGetMaxY(self.timeLab.frame) +10;
    CGFloat dw = now;
    CGFloat dh = 20;
    self.subTitleLab.frame =CGRectMake(dx, dy, dw, dh);
    
}

 

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

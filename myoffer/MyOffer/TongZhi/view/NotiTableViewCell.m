//
//  NotiTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/31.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "NotiTableViewCell.h"
#import "XWGJNoti.h"
@interface NotiTableViewCell ()
@property(nonatomic,strong)UIImageView *CellImageView;
@property(nonatomic,strong)UILabel *NotiTitleLabel;
@property(nonatomic,strong)UILabel *TimeLabel;
@property(nonatomic,strong)UILabel *NotiDetailLabel;
@property(nonatomic,strong)UIView *NewView;


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
        
        self.CellImageView =[[UIImageView alloc] init];
        [self.contentView addSubview:self.CellImageView];
        
        self.NewImageView=[[UIImageView alloc] init];
        self.NewImageView.layer.cornerRadius = 5;
        self.NewImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.NewImageView];
        
        
        self.NotiTitleLabel =[[UILabel alloc] init];
        self.NotiTitleLabel.font =[UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.NotiTitleLabel];
        
        self.TimeLabel =[[UILabel alloc] init];
        self.TimeLabel.font =[UIFont systemFontOfSize:14];
        self.TimeLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.TimeLabel];
        
        self.NotiDetailLabel =[[UILabel alloc] init];
        self.NotiDetailLabel.font =[UIFont systemFontOfSize:16];
        self.NotiDetailLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.NotiDetailLabel];
        
     }
    return self;
}

-(void)setNoti:(XWGJNoti *)noti
{
    _noti  = noti;
    
    self.NotiTitleLabel.text = noti.category;
    self.NotiDetailLabel.text = noti.summary;
    self.TimeLabel.text =  noti.create_at;
    
    NSString *imageName =  [noti.category_id integerValue] == 0 ? @"noti_blue" : @"noti_yellow";
    self.CellImageView.image = [UIImage imageNamed:imageName];
    
    UIImage *newImage = noti.state?nil:[UIImage imageNamed:@"message_dot"];
    self.NewImageView.image = newImage;
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat cx = 10;
    CGFloat cy = 20;
    CGFloat cw = 60;
    CGFloat ch = 60;
    self.CellImageView.frame =CGRectMake(cx, cy, cw, ch);
    
    CGFloat nx = CGRectGetMaxX(self.CellImageView.frame) - 12;
    CGFloat ny = 30;
    CGFloat nw = 10;
    CGFloat nh = 10;
    self.NewImageView.frame =CGRectMake(nx, ny, nw, nh);
    
    CGFloat nox = CGRectGetMaxX(self.CellImageView.frame) + 10;
    CGFloat noy = 10;
    CGFloat now = APPSIZE.width - nox - 20;
    CGFloat noh = 20;
    self.NotiTitleLabel.frame = CGRectMake(nox, noy, now, noh);
    
    
    CGFloat tx = nox;
    CGFloat ty = CGRectGetMaxY(self.NotiTitleLabel.frame)+10;
    CGFloat tw = now;
    CGFloat th = 20;
    self.TimeLabel.frame =CGRectMake(tx, ty, tw, th);
    
    CGFloat dx = nox;
    CGFloat dy = CGRectGetMaxY(self.TimeLabel.frame) +10;
    CGFloat dw = now;
    CGFloat dh = 20;
    self.NotiDetailLabel.frame =CGRectMake(dx, dy, dw, dh);
    
}

 

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

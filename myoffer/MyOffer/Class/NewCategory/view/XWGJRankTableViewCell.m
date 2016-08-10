//
//  XWGJRankTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/2/29.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJRankTableViewCell.h"
#import "XWGJRank.h"

@interface XWGJRankTableViewCell ()
//图片
@property(nonatomic,strong)UIImageView *IconView;
//蒙版
@property(nonatomic,strong)UIImageView *mengView;
//标题
@property(nonatomic,strong)UILabel *oneLab;
@property(nonatomic,strong)UILabel *twoLab;
@property(nonatomic,strong)UILabel *threeLab;

@end

@implementation XWGJRankTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.IconView = [[UIImageView alloc] init];
        self.IconView.layer.cornerRadius = 5;
        self.IconView.layer.masksToBounds = YES;
        self.IconView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.IconView];
        
        self.mengView =[[UIImageView alloc] init];
        self.IconView.contentMode = UIViewContentModeScaleToFill;
        self.mengView.image = [UIImage imageNamed:@"Black_spot"];
        self.mengView.alpha = 0.2;
        self.mengView.layer.cornerRadius = 5;
        self.mengView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.mengView];
        
        
        self.oneLab = [self makeLabel];
        
        self.twoLab = [self makeLabel];
        
        self.threeLab = [self makeLabel];
        
        self.contentView.backgroundColor = XCOLOR_CLEAR;
        self.backgroundColor = XCOLOR_CLEAR;
     }
    return self;
}

-(UILabel *)makeLabel{

    UILabel *Lab =[UILabel labelWithFontsize: 20.0f TextColor:XCOLOR_WHITE TextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:Lab];

    return Lab;
}

+(instancetype)cellInitWithTableView:(UITableView *)tableView
{
    static NSString *Identifier = @"rank";
    
    XWGJRankTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        
        cell =[[XWGJRankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        
    }
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;

    return cell;
 
}

-(void)setRank:(XWGJRank *)rank
{
    _rank = rank;
   
    self.IconView.image = [UIImage imageNamed:rank.IconName];
    
    if ([rank.TitleName containsString:@"+"]) {
    
        NSArray *titles = [rank.TitleName componentsSeparatedByString:@"+"];
        self.twoLab.text = titles[0];
        self.threeLab.text = titles[1];
        
    }else
    {
        self.oneLab.text = rank.TitleName;
    }
    
}


-(void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat iconx = ITEM_MARGIN;
    CGFloat icony = 0;
    CGFloat iconw = XScreenWidth - 2*iconx;
    CGFloat iconh = XScreenWidth / 2.5 - icony - 20;
    self.IconView.frame = CGRectMake(iconx, icony, iconw, iconh);
    self.mengView.frame = self.IconView.frame;

    CGFloat onex = iconx;
    CGFloat oneh = iconh / 4;
    CGFloat onew = iconw;
    CGFloat oney = icony + (iconh - oneh) * 0.5;
    self.oneLab.frame = CGRectMake(onex, oney, onew, oneh);
    
    CGFloat twox = iconx;
    CGFloat twoh = oneh;
    CGFloat twow = iconw;
    CGFloat twoy = icony + (iconh - 2*oneh) * 0.5;
    self.twoLab.frame = CGRectMake(twox, twoy, twow, twoh);

    CGFloat thx = twox;
    CGFloat thh = twoh;
    CGFloat thw = twow;
    CGFloat thy = twoy + twoh;
    self.threeLab.frame = CGRectMake(thx, thy, thw, thh);
    
    self.oneLab.font = [UIFont systemFontOfSize: oneh * 0.8];
    self.threeLab.font = [UIFont systemFontOfSize: oneh * 0.8];
    self.twoLab.font = [UIFont systemFontOfSize: oneh * 0.8];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

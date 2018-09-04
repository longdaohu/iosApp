//
//  YasiCourseOnLivingCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YasiCourseOnLivingCell.h"
#import "YaSiProgressView.h"
#import "UIImage+GIF.h"

@interface YasiCourseOnLivingCell ()
@property(nonatomic,strong)UIImageView *livingView;
@property(nonatomic,strong)UILabel *timeLab;
@property(nonatomic,strong)UILabel *livingLab;
@property(nonatomic,strong)YaSiProgressView *progressView;
@end

@implementation YasiCourseOnLivingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.playBtn setTitle:@"进入班级" forState:UIControlStateNormal];
        
        UILabel *timeLab = [UILabel new];
        timeLab.font = XFONT(12);
        self.timeLab = timeLab;
        timeLab.textColor = XCOLOR_TITLE;
        [self.contentView addSubview:timeLab];
        timeLab.text = @"今天 19：30 — 21：00";
        
        UIImageView *iconView = [UIImageView new];
        self.livingView = iconView;
        [self.contentView addSubview:iconView];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"dot_40x40" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        self.livingView.image =  image;

        
        UILabel *livingLab = [UILabel new];
        livingLab.font = XFONT(12);
        self.livingLab = livingLab;
        livingLab.textColor = XCOLOR_RED;
        [self.contentView addSubview:livingLab];
        livingLab.text = @"正在直播";
        
        YaSiProgressView *progressView = [[YaSiProgressView alloc] init];
        self.progressView  = progressView;
        [self.contentView addSubview:progressView];
    
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize content_size = self.contentView.bounds.size;
    
    CGFloat left_margin = 20;
    CGFloat progress_width = 40;
    
    CGFloat pro_w = progress_width;
    CGFloat pro_h = pro_w;
    CGFloat pro_x = content_size.width  - left_margin - pro_w;
    CGFloat pro_y =  20;
    self.progressView.frame = CGRectMake(pro_x, pro_y , pro_w, pro_h);
 
    CGFloat title_x = left_margin;
    CGFloat title_y = 15;
    CGFloat title_w = pro_x - title_x;
    CGFloat title_h = 20;
    self.titleLab.frame = CGRectMake(title_x, title_y, title_w, title_h);
    
    CGFloat dt_x = title_x;
    CGFloat dt_y = title_y + title_h;
    CGFloat dt_w = title_w;
    CGFloat dt_h = 20;
    self.dateBtn.frame = CGRectMake(dt_x, dt_y, dt_w, dt_h);
 
    CGFloat pl_w = 68;
    CGFloat pl_h = 24;
    CGFloat pl_y =  pro_y + pro_h + 15;
    CGFloat pl_x = content_size.width  - left_margin - pl_w;
    self.playBtn.frame = CGRectMake(pl_x, pl_y, pl_w, pl_h);
 
    CGFloat time_x = title_x;
    CGFloat time_h = 18;
    CGFloat time_y = dt_h + dt_y + 25;
    CGFloat time_w = 0;
    CGSize time_size  = [self.timeLab.text stringWithfontSize:12];
    time_w = time_size.width;
    self.timeLab.frame = CGRectMake(time_x, time_y, time_w, time_h);
 
    CGFloat live_h = 18;
    CGFloat live_w = live_h;
    CGFloat live_x = time_x + time_w + 8;
    CGFloat live_y = time_y;
    self.livingView.frame = CGRectMake(live_x, live_y, live_w, live_h);
 
    CGFloat lvl_h = time_h;
    CGFloat lvl_w =  50;
    CGFloat lvl_x =  live_x + live_w + 5;
    CGFloat lvl_y =  time_y;
    self.livingLab.frame = CGRectMake(lvl_x, lvl_y, lvl_w, lvl_h);
    
}

- (void)setItem:(YSCourseModel *)item{
 
    super.item = item;
    
    self.titleLab.text = item.name;
    self.progressView.progress = item.progress;
    [self.dateBtn setTitle:item.date_label forState:UIControlStateNormal];
    self.timeLab.text = item.nextCourseTime;
    
    self.livingLab.hidden = !item.isLiving;
    self.livingView.hidden = !item.isLiving;

}

 
@end



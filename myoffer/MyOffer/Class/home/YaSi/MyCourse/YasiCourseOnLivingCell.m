//
//  YasiCourseOnLivingCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YasiCourseOnLivingCell.h"
#import "YaSiProgressView.h"

@interface YasiCourseOnLivingCell ()
@property(nonatomic,strong)UIImageView *livingView;
@property(nonatomic,strong)UILabel *tagLab;
@property(nonatomic,strong)UILabel *timeLab;
@property(nonatomic,strong)YaSiProgressView *progressView;
@end

@implementation YasiCourseOnLivingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.playBtn setTitle:@"进入教室" forState:UIControlStateNormal];
        
        UILabel *tagLab = [UILabel new];
        tagLab.font = XFONT(10);
        self.tagLab = tagLab;
        tagLab.textColor = XCOLOR_TITLE;
        tagLab.textColor = XCOLOR_LIGHTBLUE;
        [self.contentView addSubview:tagLab];
        tagLab.text = @"上课";
        tagLab.backgroundColor = XCOLOR(5,203, 249,0.1);
        tagLab.textAlignment = NSTextAlignmentCenter;
        tagLab.layer.cornerRadius = 2;
        tagLab.layer.masksToBounds = true;
        
        UILabel *timeLab = [UILabel new];
        timeLab.font = XFONT(12);
        self.timeLab = timeLab;
        timeLab.textColor = XCOLOR_TITLE;
        [self.contentView addSubview:timeLab];
        timeLab.text = @"今天 19：30 — 21：00";
        
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
    CGFloat title_max_width = content_size.width - left_margin * 2 - progress_width;
    CGSize title_size  = [self.titleLab.text stringWithfontSize:14];
    
    CGFloat title_x = left_margin;
    CGFloat title_y = 15;
    CGFloat title_w = title_size.width + 20;
    if (title_w > title_max_width) {
        title_w = title_max_width;
    }
    CGFloat title_h = 20;
    self.titleLab.frame = CGRectMake(title_x, title_y, title_w, title_h);
    
    CGFloat dt_x = title_x;
    CGFloat dt_y = title_y + title_h;
    CGFloat dt_w = title_max_width;
    CGFloat dt_h = 20;
    self.dateBtn.frame = CGRectMake(dt_x, dt_y, dt_w, dt_h);
 
    CGFloat pl_w = 68;
    CGFloat pl_h = 24;
    CGFloat pl_y =  content_size.height - pl_h - 15;
    CGFloat pl_x = content_size.width  - left_margin - pl_w;
    self.playBtn.frame = CGRectMake(pl_x, pl_y, pl_w, pl_h);
    
    CGFloat tag_w = 38;
    CGFloat tag_h = 17;
    CGFloat tag_x = title_x;
    CGFloat tag_y = pl_y + pl_h - tag_h;
    self.tagLab.frame = CGRectMake(tag_x, tag_y, tag_w, tag_h);
    
    CGFloat time_h = tag_h;
    CGFloat time_x = tag_x + tag_w + 5;
    CGFloat time_y = tag_y;
    CGFloat time_w = pl_x - time_x;
    self.timeLab.frame = CGRectMake(time_x, time_y, time_w, time_h);
 
    CGFloat pro_w = progress_width;
    CGFloat pro_h = pro_w;
    CGFloat pro_x = content_size.width  - left_margin - pl_w;
    CGFloat pro_y =  20;
    self.progressView.frame = CGRectMake(pro_x, pro_y , pro_w, pro_h);

}

 
@end



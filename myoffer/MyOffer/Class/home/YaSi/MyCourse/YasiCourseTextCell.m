//
//  YasiCourseTextCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YasiCourseTextCell.h"

@interface YasiCourseTextCell ()
@property(nonatomic,strong)UILabel *descLab;
@end

@implementation YasiCourseTextCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
 
        self.playBtn.alpha = 0;
        self.dateBtn.alpha = 0;
        
        
        UILabel *descLab = [UILabel new];
        descLab.font = XFONT(12);
        self.descLab = descLab;
        descLab.textColor = XCOLOR_TITLE;
        descLab.numberOfLines = 2;
        [self.contentView addSubview:descLab];
        descLab.text = @"您的专属老师正在为您安排班级和课程\n 预计  2018 . 08 . 11  前完成。";
    }
    
    return self;
}

- (void)setItem:(YSCourseModel *)item{
    
    super.item = item;
    
    self.descLab.text =  item.tips;//[NSString stringWithFormat:@"您的专属老师正在为您安排班级和课程\n 预计  2018 . 08 . 11  前完成。"];
  
}

- (void)layoutSubviews{
    
    [super layoutSubviews];

    CGRect item_frame = self.dateBtn.frame;
    item_frame.size.height = 42;
    self.descLab.frame = item_frame;
 
}


@end

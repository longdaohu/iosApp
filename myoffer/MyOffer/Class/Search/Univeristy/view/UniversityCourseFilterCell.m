//
//  UniversityCourseFilterCell.m
//  myOffer
//
//  Created by xuewuguojie on 2017/4/24.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "UniversityCourseFilterCell.h"
@interface UniversityCourseFilterCell ()
@property (strong, nonatomic)UILabel *titleLab;

@end

@implementation UniversityCourseFilterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UILabel *titleLab  = [[UILabel alloc] init];
        titleLab.font = XFONT(16);
        titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab = titleLab;
        [self.contentView addSubview:titleLab];
    }
    
    return self;
}

- (void)setIsTextAligmentLeft:(BOOL)isTextAligmentLeft{

    _isTextAligmentLeft = isTextAligmentLeft;
    
    self.titleLab.textAlignment = isTextAligmentLeft ? NSTextAlignmentLeft : NSTextAlignmentCenter;
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat title_X = 10;
    CGFloat title_W = self.contentView.bounds.size.width - title_X * 2;
    CGFloat title_H = self.contentView.bounds.size.height;
    self.titleLab.frame = CGRectMake(title_X, 0, title_W,title_H);
    
    
}

- (void)setTitle:(NSString *)title{

    _title = title;
    
    self.titleLab.text = title;
}

- (void)setOnSelected:(BOOL)onSelected{

    _onSelected = onSelected;
    
    self.titleLab.textColor = onSelected ? XCOLOR_LIGHTBLUE : XCOLOR_BLACK;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

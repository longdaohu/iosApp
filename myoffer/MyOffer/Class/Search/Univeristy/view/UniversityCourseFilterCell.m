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

- (void)layoutSubviews{

    [super layoutSubviews];
    
    self.titleLab.frame = self.contentView.bounds;
    
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

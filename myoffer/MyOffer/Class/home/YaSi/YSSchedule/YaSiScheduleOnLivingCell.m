//
//  YaSiScheduleOnLivingCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YaSiScheduleOnLivingCell.h"

@interface YaSiScheduleOnLivingCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *onlivingView;
@property (weak, nonatomic) IBOutlet UILabel *onLivingLab;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *subLab;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIView *topLine;

@end

@implementation YaSiScheduleOnLivingCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.topLine.backgroundColor = XCOLOR_line;
    self.onLivingLab.textColor = XCOLOR_RED;
    self.subLab.textColor = XCOLOR_SUBTITLE;
    
    self.playBtn.layer.shadowColor = XCOLOR_LIGHTBLUE.CGColor;
    self.playBtn.layer.shadowOffset = CGSizeMake(0, 3);
    self.playBtn.layer.shadowOpacity = 0.5;
}


- (IBAction)caseplay:(UIButton *)sender {
    
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end

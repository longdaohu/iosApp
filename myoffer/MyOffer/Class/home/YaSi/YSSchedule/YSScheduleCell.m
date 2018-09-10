//
//  YSScheduleCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YSScheduleCell.h"
#import "YSScheduleModel.h"

@interface YSScheduleCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *onlivingView;
@property (weak, nonatomic) IBOutlet UILabel *onLivingLab;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIButton *beforeBtn;


@end

@implementation YSScheduleCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.topLine.backgroundColor = XCOLOR_line;
    self.onLivingLab.textColor = XCOLOR_RED;
    
    self.playBtn.layer.shadowColor = XCOLOR_LIGHTBLUE.CGColor;
    self.playBtn.layer.shadowOffset = CGSizeMake(0, 3);
    self.playBtn.layer.shadowOpacity = 0.5;
    
    self.playBtn.userInteractionEnabled = NO;
    self.timeBtn.userInteractionEnabled = NO;

    self.beforeBtn.hidden = YES;
    self.beforeBtn.enabled = NO;
    self.beforeBtn.layer.borderWidth = 1;
    self.beforeBtn.layer.borderColor = XCOLOR_SUBTITLE.CGColor;
    self.beforeBtn.layer.cornerRadius = 2;
    self.beforeBtn.layer.masksToBounds  = YES;
    [self.beforeBtn setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateNormal];
   
}

- (void)setItem:(YSScheduleModel *)item{
    _item = item;
    
    self.nameLab.text = item.teacherName;
    self.titleLab.text = [NSString stringWithFormat:@"%ld %@",(self.row + 1),item.topic];
    [self.timeBtn setTitle:item.nextCourseTime forState:UIControlStateNormal];
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:item.teacherImage] placeholderImage:nil];
    [self.playBtn setTitle:item.stateName forState:UIControlStateNormal];

    self.onLivingLab.hidden = item.livelogoState;
    self.onlivingView.hidden = item.livelogoState;
    self.playBtn.enabled = item.playButtonState;
    UIColor *clr = self.playBtn.enabled ? XCOLOR_LIGHTBLUE : XCOLOR_WHITE;
    self.playBtn.layer.shadowColor = clr.CGColor;
 
    self.playBtn.hidden = NO;
    self.beforeBtn.hidden = YES;
    if (item.type == YSScheduleVideoStateBefore){
        self.beforeBtn.hidden = NO;
        self.playBtn.hidden = YES;
    }
  
    
}






@end

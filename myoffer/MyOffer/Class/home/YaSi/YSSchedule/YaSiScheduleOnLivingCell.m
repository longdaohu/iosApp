//
//  YaSiScheduleOnLivingCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YaSiScheduleOnLivingCell.h"
#import "YSScheduleModel.h"
#import "UIImage+GIF.h"

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
    self.playBtn.layer.shadowOffset = CGSizeMake(0, 3);
    self.playBtn.layer.shadowOpacity = 0.5;
    self.playBtn.userInteractionEnabled = NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"living_icon" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    self.onlivingView.image =  image;
}



- (void)setItem:(YSScheduleModel *)item{
    _item = item;
    
    self.titleLab.text = @"";
    if (item.type == YSScheduleVideoStateLiving || item.type == YSScheduleVideoStateBefore) {
        self.titleLab.text =  item.nextCourseTime;
    }
    self.nameLab.text = item.teacherName;
    self.subLab.text = item.topic;
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:item.teacherImage] placeholderImage:nil];
    [self.playBtn setTitle:item.stateName forState:UIControlStateNormal];

    self.onLivingLab.hidden = item.livelogoState;
    self.onlivingView.hidden = item.livelogoState;
    self.playBtn.enabled = item.playButtonState;
    UIColor *clr = self.playBtn.enabled ? XCOLOR_LIGHTBLUE : XCOLOR_WHITE;
    self.playBtn.layer.shadowColor = clr.CGColor;

}

- (void)ToplineHiden:(BOOL)hide{
    
    self.topLine.hidden = hide;
}


@end


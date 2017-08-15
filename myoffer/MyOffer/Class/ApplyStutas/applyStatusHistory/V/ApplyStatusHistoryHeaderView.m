//
//  ApplyStatusHistoryHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/15.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ApplyStatusHistoryHeaderView.h"

@interface ApplyStatusHistoryHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *sub_titleLab;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UIView *paddingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagWidthConstraint;

@end

@implementation ApplyStatusHistoryHeaderView

- (void)setHistoyFrame:(ApplyStatusHistoryFrameModel *)histoyFrame{

    _histoyFrame = histoyFrame;
    
    self.titleLab.text = histoyFrame.statusModel.title;
    self.sub_titleLab.text = histoyFrame.statusModel.sub_title;
    self.tagLab.text = histoyFrame.statusModel.type;
    self.tagHeightConstraint.constant = histoyFrame.tagFrame.size.height;
    self.tagWidthConstraint.constant = histoyFrame.tagFrame.size.width;
    
    self.paddingView.hidden = self.sub_titleLab.text.length > 0 ? NO : YES;
    
    self.frame = CGRectMake(0, 0, XSCREEN_WIDTH, histoyFrame.header_height);

}

- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.titleLab.textColor = XCOLOR_TITLE;
    self.sub_titleLab.textColor = XCOLOR_SUBTITLE;
    self.tagLab.textColor = XCOLOR_SUBTITLE;
    
    self.paddingView.layer.cornerRadius = 2;
    self.paddingView.layer.masksToBounds = YES;
    self.paddingView.backgroundColor = XCOLOR_BG;
    self.tagLab.backgroundColor = XCOLOR_BG;
    self.tagLab.layer.cornerRadius = CORNER_RADIUS;
    self.tagLab.layer.masksToBounds = YES;
}

 
@end

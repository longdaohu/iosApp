//
//  personServiceStatusCell.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "personServiceStatusCell.h"

@interface personServiceStatusCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *sub_titleLab;
@property (weak, nonatomic) IBOutlet UIView *padding;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paddingToBottomConstraint;

@end

@implementation personServiceStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    personServiceStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([personServiceStatusCell class])];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([personServiceStatusCell class]) owner:self options:nil].firstObject;
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = XCOLOR_BG;
    
    _bgView.layer.shadowColor = XCOLOR_LIGHTBLUE.CGColor;//shadowColor阴影颜色
    _bgView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _bgView.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    
    self.statusLab.textColor = XCOLOR_LIGHTBLUE;
    self.dateLab.textColor = XCOLOR_SUBTITLE;
    self.titleLab.textColor = XCOLOR_TITLE;
    self.sub_titleLab.textColor = XCOLOR_SUBTITLE;
    self.padding.backgroundColor = XCOLOR_line;
    self.padding.layer.cornerRadius = 2;
    self.padding.layer.masksToBounds = YES;
    
    self.tagLab.backgroundColor = XCOLOR_BG;
    self.tagLab.textColor = XCOLOR_SUBTITLE;
    self.tagLab.layer.cornerRadius = CORNER_RADIUS;
    self.tagLab.layer.masksToBounds = YES;
    
    
}


- (void)setStatusFrame:(ApplyStatusModelFrame *)statusFrame{
    
    _statusFrame = statusFrame;
    
    self.statusLab.text = statusFrame.statusModel.status;
    self.dateLab.text =  statusFrame.statusModel.date;
    self.titleLab.text = statusFrame.statusModel.title;
    self.sub_titleLab.text = statusFrame.statusModel.sub_title;
    self.tagLab.text = statusFrame.statusModel.type;
    self.padding.hidden = self.sub_titleLab.text.length ? NO : YES;
    self.paddingToBottomConstraint.constant = statusFrame.padding_bottom_distance;
    
    
}

@end

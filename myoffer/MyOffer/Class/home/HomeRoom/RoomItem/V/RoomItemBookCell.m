//
//  RoomItemBookCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomItemBookCell.h"

@interface RoomItemBookCell ()
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *lengthLab;
@property (weak, nonatomic) IBOutlet UIButton *bookBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation RoomItemBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 8;
    self.bookBtn.layer.cornerRadius = 4;
    self.bookBtn.backgroundColor = XCOLOR_RED;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)book:(UIButton *)sender {
    
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    self.subTitleLab.text = title;
}

@end

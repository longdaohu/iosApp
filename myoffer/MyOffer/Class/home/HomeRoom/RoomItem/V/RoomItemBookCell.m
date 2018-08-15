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
    
    self.bgView.layer.cornerRadius = CORNER_RADIUS;
    self.priceLab.textColor = XCOLOR_RED;
}


- (IBAction)book:(UIButton *)sender {
    
    if (self.actionBlock) {
        self.actionBlock(self.item.roomtype_id);
    }
}


- (void)setItem:(RoomTypeBookItemModel *)item{
    _item = item;
    
    self.subTitleLab.text = item.note;
    self.priceLab.text = item.priceCurrency;
    self.timeLab.text = item.start_date;
    NSString *unit = item.unit;
    if ([item.unit containsString:@"每"]) {
        unit = [item.unit componentsSeparatedByString:@"每"].lastObject;
    }
    self.lengthLab.text = [NSString stringWithFormat:@"%@%@",item.weeks,unit];
}

@end

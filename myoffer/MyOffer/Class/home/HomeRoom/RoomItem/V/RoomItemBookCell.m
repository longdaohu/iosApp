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
    
    self.bookBtn.layer.shadowColor = XCOLOR_RED.CGColor;
    self.bookBtn.layer.shadowOffset = CGSizeMake(0, 3);
    self.bookBtn.layer.shadowOpacity = 0.3;
    
 }


- (IBAction)book:(UIButton *)sender {
    
    if (self.actionBlock) {
        self.actionBlock(self.item.roomtype_id);
    }
}


- (void)setItem:(RoomTypeBookItemModel *)item{
    _item = item;
    
    self.bookBtn.enabled = !item.state.boolValue;
    UIColor *shadow_color = item.state.boolValue ?  XCOLOR_BLACK : XCOLOR_RED;
    self.bookBtn.layer.shadowColor = shadow_color.CGColor;
    
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

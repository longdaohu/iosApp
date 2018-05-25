//
//  InvitationRecordsCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/22.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "InvitationRecordsCell.h"

@interface InvitationRecordsCell ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation InvitationRecordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)lookUp:(id)sender {
    
    if (self.cellBlock) {
        self.cellBlock(self.item.accountId);
    }
}

- (void)setItem:(InvitationRecordItem *)item{
    
    _item = item;
    
    self.phoneLab.text = item.phonenumber;
    [self.statusBtn setTitle:item.stateDisplay  forState:UIControlStateNormal];
    self.statusBtn.selected = NO;
    self.checkBtn.selected = NO;
    if ([item.state isEqualToString:@"award_issued"]) {
        self.statusBtn.selected = YES;
        self.checkBtn.selected = YES;
    }
    
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



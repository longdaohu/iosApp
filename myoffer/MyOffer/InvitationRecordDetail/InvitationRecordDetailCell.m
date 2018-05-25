//
//  InvitationRecordDetailCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/23.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "InvitationRecordDetailCell.h"
@interface InvitationRecordDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation InvitationRecordDetailCell

- (void)setItem:(NSDictionary *)item{
    
    _item = item;

    self.titleLab.text = item[@"stateDisplay"];
    self.subLab.text = item[@"detail"];
    self.timeLab.text = [NSString stringWithFormat:@"%@  %@",item[@"date"],item[@"time"]];
}

@end






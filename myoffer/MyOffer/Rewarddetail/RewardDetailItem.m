//
//  RewardDetailItem.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/23.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RewardDetailItem.h"
#import "RewardDetailCelltem.h"

@implementation RewardDetailItem

- (NSArray *)statusGroup{
    
    if (!_statusGroup) {
        
        RewardDetailCelltem *stateDisplay = [RewardDetailCelltem itemWithTitle:@"状态" sub:self.stateDisplay];
        NSString *sub = [self.amount isEqualToString:@"0"] ? @"0" :[NSString stringWithFormat:@"-%@",self.amount];
        RewardDetailCelltem *amount = [RewardDetailCelltem itemWithTitle:@"消耗的现金券" sub:sub];
        _statusGroup = @[stateDisplay,amount];
    }
    
    return _statusGroup;
}

- (NSArray *)userGroup{
    
    if (!_userGroup) {
        
        RewardDetailCelltem *bankReceiptName = [RewardDetailCelltem itemWithTitle:@"持卡人姓名" sub:self.bankReceiptName];
        RewardDetailCelltem *bankAccount = [RewardDetailCelltem itemWithTitle:@"储蓄卡卡号" sub:self.bankAccount];
        NSString *date_time = [NSString stringWithFormat:@"%@  %@",self.date,self.time];
        RewardDetailCelltem *time_item = [RewardDetailCelltem itemWithTitle:@"提交时间" sub:date_time];
        RewardDetailCelltem *bankName = [RewardDetailCelltem itemWithTitle:@" 开户银行" sub:self.bankName];
        _userGroup = @[bankReceiptName,bankAccount,time_item,bankName];
    }
    
    return _userGroup;
}

- (NSArray *)otherGroup{
    if (!_otherGroup) {
        
        RewardDetailCelltem *displayname = [RewardDetailCelltem itemWithTitle:@"用户名" sub:self.displayname];
        RewardDetailCelltem *phonenumber = [RewardDetailCelltem itemWithTitle:@"手机号" sub:self.phonenumber];
        _otherGroup = @[displayname,phonenumber];
    }
    
    return _otherGroup;
}

@end



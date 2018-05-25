//
//  InvitationRecordUserCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/23.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewardDetailCelltem.h"

@interface InvitationRecordUserCell : UITableViewCell
@property(nonatomic,strong)RewardDetailCelltem *item;
- (void)cellSeparatorHiden:(BOOL)hiden;

@end


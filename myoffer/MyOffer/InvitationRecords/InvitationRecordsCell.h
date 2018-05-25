//
//  InvitationRecordsCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/22.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvitationRecordItem.h"

@interface InvitationRecordsCell : UITableViewCell

@property(nonatomic,copy)void(^cellBlock)(NSString *);
@property(nonatomic,strong)InvitationRecordItem *item;

@end

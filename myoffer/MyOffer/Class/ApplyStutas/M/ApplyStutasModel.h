//
//  ApplyStutasModel.h
//  myOffer
//
//  Created by xuewuguojie on 2017/8/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplyStutasHistoryModel.h"

@interface ApplyStutasModel : NSObject

@property(nonatomic,copy)NSString  *process_id;
@property(nonatomic,copy)NSString  *date;
@property(nonatomic,copy)NSString  *time;
@property(nonatomic,copy)NSString  *title;
@property(nonatomic,copy)NSString  *sub_title;
@property(nonatomic,copy)NSString  *status;
@property(nonatomic,copy)NSString  *type;
@property(nonatomic,strong)NSArray *history;


@end

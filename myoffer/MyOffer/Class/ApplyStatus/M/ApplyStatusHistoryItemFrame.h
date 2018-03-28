//
//  ApplyStatusHistoryItemFrame.h
//  myOffer
//
//  Created by xuewuguojie on 2017/8/15.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplyStutasHistoryModel.h"

@interface ApplyStatusHistoryItemFrame : NSObject
@property(nonatomic,strong)ApplyStutasHistoryModel *historyItem;
@property(nonatomic,assign)CGRect status_Frame;
@property(nonatomic,assign)CGRect date_Frame;
@property(nonatomic,assign)CGRect line_Frame;
@property(nonatomic,assign)CGRect spod_Frame;
@property(nonatomic,assign)CGFloat cell_Height;

+ (instancetype)frameWithHistoryItem:(ApplyStutasHistoryModel *)historyItem;

@end

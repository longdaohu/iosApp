//
//  ApplyStatusHistoryFrameModel.h
//  myOffer
//
//  Created by xuewuguojie on 2017/8/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplyStutasModel.h"

@interface ApplyStatusHistoryFrameModel : NSObject
@property(nonatomic,strong)ApplyStutasModel *statusModel;
@property(nonatomic,assign)CGRect title_Frame;
@property(nonatomic,assign)CGRect sub_titleFrame;
@property(nonatomic,assign)CGRect paddingFrame;
@property(nonatomic,assign)CGRect tagFrame;

@property(nonatomic,assign)CGFloat header_height;


@end



//
//  SMNewsFrame.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMHotModel.h"

@interface SMNewsFrame : NSObject
@property(nonatomic,strong)SMHotModel *news;
@property(nonatomic,assign)CGRect icon_Frame;
@property(nonatomic,assign)CGRect title_Frame;
@property(nonatomic,assign)CGRect name_Frame;
@property(nonatomic,assign)CGRect uni_Frame;
@property(nonatomic,assign)CGRect play_Frame;
@property(nonatomic,assign)CGFloat cell_height;
@property(nonatomic,assign)CGSize cell_size;

+ (instancetype)frameWithHot:(SMHotModel *)news;

@end

//
//  SMHotFrame.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMHotModel.h"

@interface SMHotFrame : NSObject
@property(nonatomic,strong)SMHotModel *hot;
@property(nonatomic,assign)CGRect icon_Frame;
@property(nonatomic,assign)CGRect play_Frame;
@property(nonatomic,assign)CGRect tag_Frame;
@property(nonatomic,assign)CGRect title_Frame;
@property(nonatomic,assign)CGRect name_Frame;
@property(nonatomic,assign)CGRect uni_Frame;
@property(nonatomic,assign)CGRect bottom_line_Frame;
@property(nonatomic,assign)CGFloat cell_height;

+ (instancetype)frameWithHot:(SMHotModel *)hot;

@end

//
//  SMTagFrame.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMTagModel.h"

@interface SMTagFrame : NSObject
@property(nonatomic,strong)SMTagModel *tag;
@property(nonatomic,strong)NSArray *topicFrames;
@property(nonatomic,strong)NSArray *subjectFrames;
@property(nonatomic,assign)CGRect center_line_Frame;
@property(nonatomic,assign)CGRect topicFrame;
@property(nonatomic,assign)CGRect subjectFrame;
@property(nonatomic,assign)CGRect lineFrame;
@property(nonatomic,assign)CGFloat cell_height;

+ (instancetype)frameWithtag:(SMTagModel *)tag;

@end

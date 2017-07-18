//
//  MessageTopicCatigoryView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/17.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "messageCatigroyCountryModel.h"
#import "messageCatigroyModel.h"

typedef void(^topicTopViewBlock)(NSInteger);

@interface MessageTopicCatigoryView : UIView

+ (instancetype)topViewWithBlock:(topicTopViewBlock)actionBlock;

@property(nonatomic,strong)messageCatigroyCountryModel *catigoryCountry;

@property(nonatomic,copy)topicTopViewBlock actionBlock;

- (void)superViewSetScrollViewToCatigoryIndex:(NSInteger)page;


@end

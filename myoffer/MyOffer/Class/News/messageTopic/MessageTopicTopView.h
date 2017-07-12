//
//  MessageTopicTopView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messageCatigroyCountryModel.h"
#import "messageCatigroyModel.h"

typedef void(^topicTopViewBlock)(NSDictionary *,NSInteger);

@interface MessageTopicTopView : UIView

+ (instancetype)topViewWithBlock:(topicTopViewBlock)actionBlock;

@property(nonatomic,strong)messageCatigroyCountryModel *catigoryCountry;

@property(nonatomic,copy)topicTopViewBlock actionBlock;

- (void)scrollToCatigoryIndex:(NSInteger)page;

@end

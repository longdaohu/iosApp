//
//  MessageTopicFooterView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MessageTopicFooterViewBlock)();

@interface MessageTopicFooterView : UIView

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)MessageTopicFooterViewBlock actionBlock;

+ (instancetype)fooerWithTitle:(NSString *)title action:(MessageTopicFooterViewBlock)actionBlock;

@end

//
//  MessageTopicCountryContentVController.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/17.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCountryTopicModel.h"
@interface MessageTopicCountryContentVController : BaseViewController
@property(nonatomic,strong)MessageCountryTopicModel *group;

- (void)tableViewScrollToTop;

- (void)showError;


@end

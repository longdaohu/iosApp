//
//  MessageDetailViewController.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageDetaillViewController : BaseViewController
@property(nonatomic,copy)NSString *message_id;
- (instancetype)initWithMessageId:(NSString *)message_id;
@end

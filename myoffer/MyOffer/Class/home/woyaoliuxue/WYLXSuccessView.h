//
//  XliuxueSuccessView.h
//  myOffer
//
//  Created by xuewuguojie on 16/7/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^successBlock)();
@interface WYLXSuccessView : UIView
@property(nonatomic,copy)successBlock actionBlock;
+(instancetype)successViewWithBlock:(successBlock)actionBlock;
@end

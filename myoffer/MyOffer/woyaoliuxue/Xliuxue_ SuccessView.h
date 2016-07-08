//
//  Xliuxue_ SuccessView.h
//  myOffer
//
//  Created by xuewuguojie on 16/4/8.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^successBlock)();
@interface Xliuxue__SuccessView : UIView
@property(nonatomic,copy)successBlock actionBlock;
+(instancetype)successView;

@end

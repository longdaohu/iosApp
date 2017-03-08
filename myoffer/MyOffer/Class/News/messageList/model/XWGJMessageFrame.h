//
//  XWGJMessage.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyOfferArticle;
@interface XWGJMessageFrame : NSObject
@property(nonatomic,strong)MyOfferArticle *News;
@property(nonatomic,assign)CGRect LogoFrame;
@property(nonatomic,assign)CGRect TitleFrame;
@property(nonatomic,assign)CGRect FocusFrame;
@property(nonatomic,assign)CGRect TimeFrame;
+(instancetype)messageFrameWithMessage:(MyOfferArticle *)message;
@end

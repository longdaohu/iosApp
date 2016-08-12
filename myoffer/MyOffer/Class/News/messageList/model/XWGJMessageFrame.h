//
//  XWGJMessage.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NewsItem;
@interface XWGJMessageFrame : NSObject
@property(nonatomic,strong)NewsItem *News;
@property(nonatomic,assign)CGRect LogoFrame;
@property(nonatomic,assign)CGRect TitleFrame;
@property(nonatomic,assign)CGRect FocusFrame;
@property(nonatomic,assign)CGRect TimeFrame;
+(instancetype)messageFrameWithMessage:(NewsItem *)message;
@end

//
//  YYSingleNewsBO.h
//  YYDailyNewsDemo
//
//  Created by REiFON-MAC on 15/12/28.
//  Copyright © 2015年 L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYSingleNewsBO : NSObject

@property (nonatomic, copy) NSDictionary *message;
@property (nonatomic, copy) NSString *imageUrl; //轮播图
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSString *message_url;
@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic, assign) NSInteger index;

@property(nonatomic,strong)NSDictionary *banner;


@end

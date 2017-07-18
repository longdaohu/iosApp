//
//  MessageCountryTopicModel.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/11.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageCountryTopicModel : NSObject
//展示数组
@property(nonatomic,strong)NSMutableArray *messageFrames;
//当前网络请求参数
@property(nonatomic,strong)NSMutableDictionary *parameters;
//在数组地第几个
@property(nonatomic,assign)NSInteger catigoryIndex;
//记录网络请求在第几页
@property(nonatomic,assign)NSInteger page;
//是否可以继续加载
@property(nonatomic,assign)BOOL endPage;

+ (instancetype)countryTopicWithMessageFrames:(NSMutableArray *)messageFrames catigoryIndex:(NSInteger)catigoryIndex;


@end

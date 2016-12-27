//
//  MessageCategoryItem.h
//  myOffer
//
//  Created by sara on 16/1/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWGJMessageCategoryItem : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger LastPage;
@property(nonatomic,assign)BOOL IsNoMoreState;

+ (instancetype)categoryInitWithName:(NSString *)name lastPage:(NSInteger)lastPage;

@end

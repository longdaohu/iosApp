//
//  MessageCategoryItem.h
//  myOffer
//
//  Created by sara on 16/1/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWGJMessageCategoryItem : NSObject
@property(nonatomic,copy)NSString *titleName;
@property(nonatomic,assign)NSInteger LastPage;
@property(nonatomic,assign)BOOL IsNoMoreState;

+ (instancetype)CreateCategoryItemWithTitle:(NSString *)titleName andLastPage:(NSInteger)page;
@end

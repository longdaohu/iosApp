//
//  UniDetailGroups.h
//  myOffer
//
//  Created by xuewuguojie on 16/9/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UniDetailGroup : NSObject
@property(nonatomic,copy)NSString   *HeaderTitle;
@property(nonatomic,strong)NSArray  *items;
@property(nonatomic,assign)BOOL      HaveFooter;
@property(nonatomic,assign)BOOL      HaveHeader;
@property(nonatomic,assign)CGFloat   cellHeight;

+(instancetype)groupWithTitle:(NSString *)title contentes:(NSArray *)items  andFooter:(BOOL)footer;

@end

//
//  XWGJTJSectionGroup.h
//  myOffer
//
//  Created by xuewuguojie on 16/2/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface XWGJTJSectionGroup : NSObject
@property(nonatomic,copy)NSString *sectionTitleName;
@property(nonatomic,strong)NSArray *celles;

+(instancetype)groupInitWithTitle:(NSString *)title celles:(NSArray *)celles;


@end

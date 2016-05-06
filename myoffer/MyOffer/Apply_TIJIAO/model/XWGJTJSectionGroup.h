//
//  XWGJTJSectionGroup.h
//  myOffer
//
//  Created by xuewuguojie on 16/2/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface XWGJTJSectionGroup : NSObject
@property(nonatomic,copy)NSString *SectionTitleName;
@property(nonatomic,copy)NSString *SectionIconName;
@property(nonatomic,strong)NSArray *cellItems;

+(instancetype)groupInitWithTitle:(NSString *)titleName andSecitonIcon:(NSString *)iconName andContensArray:(NSArray *)items;


@end

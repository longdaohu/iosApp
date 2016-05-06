//
//  OptionItem.h
//  myOffer
//
//  Created by xuewuguojie on 15/12/18.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionItem : NSObject
@property(nonatomic,copy)NSString *RankType;
@property(nonatomic,copy)NSString *RankTypeName;
@property(nonatomic,copy)NSString *RankTypeShowName;
@property(nonatomic,assign)BOOL  *isSelected;

-(instancetype)initWithRank:(NSString *)typeName;
+(instancetype)CreateOpitonItemWithRank:(NSString *)typeName;


@end

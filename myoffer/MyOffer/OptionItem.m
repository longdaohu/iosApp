//
//  OptionItem.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/18.
//  Copyright © 2015年 UVIC. All rights reserved.
//
#define RANKTI  @"ranking_ti"
#define RANKQS  @"ranking_qs"
#import "OptionItem.h"

@implementation OptionItem
-(instancetype)initWithRank:(NSString *)typeName
{
    if (self = [super init]) {
      
        self.RankTypeName = typeName;
        
        if ([typeName containsString:[GDLocalizedString(@"SearchRank_Country") lowercaseString]]) {
            
            self.RankTypeShowName = GDLocalizedString(@"SearchResult_countryxxxRank");
            self.RankType = RANKTI;
        }else{
            self.RankType = RANKQS;
            self.RankTypeShowName = GDLocalizedString(@"SearchResult_worldxxxRank");
            
         }
        
        
     }
    return self;
}
+(instancetype)CreateOpitonItemWithRank:(NSString *)typeName
{
    return [[self alloc] initWithRank:typeName];
}



 


@end
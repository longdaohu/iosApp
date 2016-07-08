//
//  UniversityObj.m
//  myOffer
//
//  Created by sara on 15/12/18.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "UniversityObj.h"

@implementation UniversityObj

-(instancetype)initUniversityWithUniversityInfo:(NSDictionary *)info
{
    if (self = [super init]) {
        
        self.logoName  =  info[@"logo"];
        self.in_cart = info[@"in_cart"];
        self.titleName = info[@"name"];
        self.subTitleName = info[@"official_name"];
        self.countryName  =[info[@"country"] containsString:@"ingdom"] ? @"UK" : info[@"country"];
        self.stateName  =  info[@"state"];
        self.cityName  =  info[@"city"];
        self.LocalPlaceName =[NSString stringWithFormat:@"%@-%@-%@",self.countryName, info[@"state"],info[@"city"]];
        self.rankName   =  [NSString stringWithFormat:@"%@",info[@"ranking_qs"]];
        self.RANKTIName  =[NSString stringWithFormat:@"%@",info[@"ranking_ti"]];
        self.isLike =[info[@"favorited"] boolValue];
        self.resultSubjectArray = info[@"courses"];
        self.universityID = (NSString *)info[@"_id"];
        self.isHot = [info[@"hot"] boolValue];
        self.tags = info[@"tags"];

    }
    return self;
}
+(instancetype)createUniversityWithUniversityInfo:(NSDictionary *)info
{
    return [[self alloc] initUniversityWithUniversityInfo:info];
}


 

@end

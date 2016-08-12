//
//  UniversityObj.h
//  myOffer
//
//  Created by sara on 15/12/18.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UniversityObj : NSObject
@property(nonatomic,copy)NSString *logoName;
@property(nonatomic,copy)NSString *in_cart;
@property(nonatomic,copy)NSString *titleName;
@property(nonatomic,copy)NSString *subTitleName;
@property(nonatomic,copy)NSString *LocalPlaceName;
@property(nonatomic,copy)NSString *countryName;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *stateName;
@property(nonatomic,copy)NSString *rankName;
@property(nonatomic,copy)NSString *RANKTIName;
@property(nonatomic,copy)NSString *universityID;
@property(nonatomic,assign)BOOL isLike;
@property(nonatomic,assign)BOOL isHot;
@property(nonatomic,assign)NSArray *tags;


@property(nonatomic,strong)NSArray *resultSubjectArray;

+(instancetype)createUniversityWithUniversityInfo:(NSDictionary *)info;
-(instancetype)initUniversityWithUniversityInfo:(NSDictionary *)info;

@end


 
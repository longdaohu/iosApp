//
//  UniversityCourse.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/12.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UniversityCourse : NSObject
@property(nonatomic,copy)NSString *official_name;
@property(nonatomic,copy)NSString *level;
@property(nonatomic,strong)NSArray *areas;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,copy)NSString *NO_id;
@property(nonatomic,assign)BOOL applied;
@property(nonatomic,assign)BOOL optionSeleced;

@end
/*
    pageCount = 4,
	pageIndex = 0,
	pageSize = 40,
	count = 132,
	courses =
 */

/*
 {
	_id = 56a0856d93c4392863862c8e,
	qualification = <null>,
	official_name = Monash （College） Standard Foundation Programme,
	subjects = [
 ],
	degree_type = <null>,
	level = 本科预科,
	areas = [
 ],
	duration = 8,
	name = Monash （College） Standard Foundation Programme,
	university_id = 559bbe918f4d4be0791908b4
 },
 */

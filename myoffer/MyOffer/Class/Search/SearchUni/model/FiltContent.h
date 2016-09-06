//
//  filtercontent.h
//  TESTER
//
//  Created by xuewuguojie on 15/12/15.
//  Copyright © 2015年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface FiltContent : NSObject
@property(nonatomic,copy)NSString *logoName;
@property(nonatomic,copy)NSString *titleName;
@property(nonatomic,copy)NSString *detailTitleName;
@property(nonatomic,strong)NSArray *buttonArray;


+(instancetype)createItemWithTitle:(NSString *)titleName andDetailTitle:(NSString *)detailName anditems:(NSArray *)items;
+(instancetype)filterItemWithLogoName:(NSString *)logoName titleName:(NSString *)title detailTitleName:(NSString *)detailTitle anditems:(NSArray *)items;
-(instancetype)initItemWithLogoName:(NSString *)logo  titleName:(NSString *)title andDetailTitleName:(NSString *)detailtitle anditems:(NSArray *)items;
@end
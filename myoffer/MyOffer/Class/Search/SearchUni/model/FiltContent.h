//
//  filtercontent.h
//  TESTER
//
//  Created by xuewuguojie on 15/12/15.
//  Copyright © 2015年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, FilterOption) {
    
    FilterOptionCountry = 0,
    FilterOptionState,
    FilterOptionCity,
    FilterOptionArea,
    FilterOptionSuject
    
};
@interface FiltContent : NSObject
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subtitle;
@property(nonatomic,strong)NSArray *optionItems;
@property(nonatomic,assign)FilterOption optionStyle;
@property(nonatomic,copy)NSString *selectedValue;

+ (instancetype)filterWithIcon:(NSString *)icon  title:(NSString *)title subtitlte:(NSString *)subtitle filterOptionItems:(NSArray *)optionItems;

@end

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
@property(nonatomic,strong)NSMutableArray *buttonArray;
@property(nonatomic,assign)CGFloat  contentheigh;
@property(nonatomic,assign)BOOL  cellHiden;


+(instancetype)createItemWithTitle:(NSString *)titleName andDetailTitle:(NSString *)detailName anditems:(NSArray *)items;
-(instancetype)initItemWithTitle:(NSString *)titleName andDetailTitle:(NSString *)detailName anditems:(NSArray *)items;

@end

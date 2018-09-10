//
//  YasiCatigoryItemModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YasiCatigoryItemModel : NSObject

@property(nonatomic,copy)NSString *_id ;
@property(nonatomic,assign)BOOL contract_enable;
@property(nonatomic,copy)NSString *name ;
@property(nonatomic,copy)NSString *category_id ;
@property(nonatomic,copy)NSString *display_price ;
@property(nonatomic,copy)NSString *price ;
@property(nonatomic,copy)NSString *cover_url;
@property(nonatomic,strong)NSArray *courseCaveats;
@property(nonatomic,strong)NSArray *courseQuestions;
@property(nonatomic,strong)NSArray *courseDescription;
@property(nonatomic,strong)NSArray *courseOutline;

@property(nonatomic,strong)NSArray *items;
@property(nonatomic,assign)NSInteger current_selected;

@property(nonatomic,assign)CGFloat cell_courseCaveat_height;
@property(nonatomic,assign)CGFloat cell_courseQuestions_height;
@property(nonatomic,assign)CGFloat cell_courseDescription_height;
@property(nonatomic,assign)CGFloat cell_courseOutline_height;

@property(nonatomic,strong)NSArray *imageFrame_courseCaveats;
@property(nonatomic,strong)NSArray *imageFrame_courseQuestions;
@property(nonatomic,strong)NSArray *imageFrame_courseDescription;
@property(nonatomic,strong)NSArray *imageFrame_courseOutline;

@property(nonatomic,strong)NSArray *cell_arr;
@property(nonatomic,strong)NSArray *imagesFrame_arr;


@end
 

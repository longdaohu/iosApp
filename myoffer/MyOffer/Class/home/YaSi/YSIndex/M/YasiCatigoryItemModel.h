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

/*
 "_id" = 5b8cd22c0329d7d838eebcb9;
 "contract_enable" = 0;
  =                     (
 );
 courseDescription =                     (
 );
 courseOutline =                     (
 );
 courseQuestions =                     (
 );
 "cover_url" = "www.https://img.myoffer.cn/data/cms/emall/DIYsku_logo.jpg.com";
 "display_price" = 2000;
 name = "\U96c5\U601d5\U5206\U57fa\U7840\U73ed";
 price = 1000;
 
 
 
     "_id" = 5b8cd3050329d7d838eebccb;
     "asken_questions" =             (
     );
     "contract_enable" = 0;
     "course_description" =             (
     );
     "course_outline" =             (
     );
     "cover_url" = "";
     name = "\U96c5\U601d7\U5206\U51b2\U523a\U73ed";
     "notes_application" =             (
     );
     "old_price" = 7000;
     price = 3500;
 */


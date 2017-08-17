//
//  UniDetailGroups.h
//  myOffer
//
//  Created by xuewuguojie on 16/9/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,GroupType){

    GroupTypeA = 0,
    GroupTypeB,
    GroupTypeC,
    GroupTypeD,
    GroupTypeE
};

@interface UniDetailGroup : NSObject
//分组数组数据
@property(nonatomic,strong)NSArray  *items;
//分组header
@property(nonatomic,copy)NSString   *header_title;
@property(nonatomic,copy)NSString   *accessory_title;
//行高
@property(nonatomic,assign)CGFloat   cellHeight;
@property(nonatomic,assign)CGFloat      section_header_height;
@property(nonatomic,assign)CGFloat      section_footer_height;
@property(nonatomic,assign)GroupType     type;

+(instancetype)groupWithTitle:(NSString *)title contentes:(NSArray *)items groupType:(GroupType)type haveFooter:(BOOL)footer;


@end

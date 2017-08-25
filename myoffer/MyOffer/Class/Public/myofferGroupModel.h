//
//  myofferGroupModel.h
//  myOffer
//
//  Created by xuewuguojie on 2017/8/24.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myofferGroupModel : NSObject
@property(nonatomic,copy)NSString *header_title;
@property(nonatomic,copy)NSString *accesory_title;
@property(nonatomic,copy)NSString *footer_title;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)BOOL haveHeader;
@property(nonatomic,assign)BOOL havefooter;
@property(nonatomic,assign)BOOL head_accesory_arrow;
@property(nonatomic,assign)CGFloat  section_footer_height;
@property(nonatomic,assign)CGFloat  section_header_height;
@property(nonatomic,strong)NSArray *items;

+ (instancetype)groupWithItems:(NSArray *)items  header:(NSString *)header;
+ (instancetype)groupWithItems:(NSArray *)items  header:(NSString *)header footer:(NSString *)footer;
+ (instancetype)groupWithItems:(NSArray *)items  header:(NSString *)header footer:(NSString *)footer  accessory:(NSString *)accessory_title;


@end

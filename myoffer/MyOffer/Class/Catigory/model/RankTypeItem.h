//
//  RankTypeItem.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankTypeItem : NSObject

@property(nonatomic,copy)NSString *type_id;
@property(nonatomic,copy)NSString *image_url;
@property(nonatomic,strong)NSURL *image_path;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *name_en;

@end



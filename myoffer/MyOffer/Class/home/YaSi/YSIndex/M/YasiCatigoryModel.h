//
//  YasiCatigoryModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YasiCatigoryModel : NSObject
@property(nonatomic,strong)NSDictionary *item;
@property(nonatomic,copy)NSString *_id ;
@property(nonatomic,copy)NSString *name ;
@property(nonatomic,copy)NSString *sort ;
@property(nonatomic,strong)NSArray *servicePackage ;

@end




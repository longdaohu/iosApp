//
//  SMAudioModel.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMAudioModel : NSObject
@property(nonatomic,copy)NSString *file_url;
@property(nonatomic,copy)NSString *seconds_duration;
@property(nonatomic,strong)NSArray *fragments;

@end
 

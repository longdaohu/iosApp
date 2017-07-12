//
//  messageCatigroyCountryModel.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messageCatigroyCountryModel : NSObject
@property(nonatomic,strong)NSArray *subs;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,assign)BOOL isSelected;

@end

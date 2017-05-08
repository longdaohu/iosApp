//
//  UniItemFrame.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyOfferUniversityModel.h"

@interface UniItemFrame : NSObject
@property(nonatomic,strong)MyOfferUniversityModel *item;
@property(nonatomic,assign)CGRect logoFrame;
@property(nonatomic,assign)CGRect nameFrame;
@property(nonatomic,assign)CGRect official_nameFrame;
@property(nonatomic,assign)CGRect address_detailFrame;
@property(nonatomic,assign)CGRect QSRankFrame;
@property(nonatomic,assign)CGRect TIMESRankFrame;
@property(nonatomic,assign)CGRect anchorFrame;
@property(nonatomic,assign)CGRect hotFrame;

+ (instancetype)frameWithUniversity:(MyOfferUniversityModel *)uni;

@end

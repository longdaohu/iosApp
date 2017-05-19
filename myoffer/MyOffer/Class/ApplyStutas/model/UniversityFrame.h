//
//  UniversityFrame.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/31.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyOfferUniversityModel;

@interface UniversityFrame : NSObject

@property(nonatomic,strong)MyOfferUniversityModel *university;
@property(nonatomic,assign)CGRect icon_Frame;
@property(nonatomic,assign)CGFloat cell_Height;
@property(nonatomic,assign)CGRect name_Frame;
@property(nonatomic,assign)CGRect official_Frame;
@property(nonatomic,assign)CGRect address_Frame;
@property(nonatomic,assign)CGRect rank_Frame;
@property(nonatomic,assign)CGRect starBgFrame;
@property(nonatomic,strong)NSArray *starFrames;
@property(nonatomic,assign)CGRect lineFrame;

@end

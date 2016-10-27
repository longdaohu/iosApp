//
//  UniversityFrame.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/31.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UniversityNew;

@interface UniversityFrame : NSObject
@property(nonatomic,strong)UniversityNew *university;
@property(nonatomic,assign)CGRect selectButtonFrame;
@property(nonatomic,assign)CGRect LogoFrame;
@property(nonatomic,assign)CGRect nameFrame;
@property(nonatomic,assign)CGRect official_nameFrame;
@property(nonatomic,assign)CGRect address_detailFrame;
@property(nonatomic,assign)CGRect  anchorFrame;
@property(nonatomic,assign)CGRect RankFrame;
@property(nonatomic,assign)CGRect starBgFrame;
@property(nonatomic,strong)NSArray *starFrames;

@end

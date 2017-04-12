//
//  UniversityNewFrame.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/24.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniversitydetailNew.h"

@interface UniversityNewFrame : NSObject
@property(nonatomic,strong)UniversitydetailNew *item;
@property(nonatomic,assign)CGRect logo_Frame;
@property(nonatomic,assign)CGRect name_Frame;
@property(nonatomic,assign)CGRect official_nameFrame;
@property(nonatomic,assign)CGRect address_detailFrame;
@property(nonatomic,assign)CGRect website_Frame;
@property(nonatomic,assign)CGRect dataView_Frame;
@property(nonatomic,assign)CGRect lineFrame;
@property(nonatomic,assign)CGRect introduction_Frame;
@property(nonatomic,assign)CGRect more_Frame;
@property(nonatomic,assign)CGRect gradientBgViewFrame;
@property(nonatomic,assign)CGFloat centerHeigh;
@property(nonatomic,assign)CGRect upViewFrame;
@property(nonatomic,assign)CGRect headerFrame;
@property(nonatomic,assign)CGRect centerViewFrame;
@property(nonatomic,assign)CGRect downViewFrame;
@property(nonatomic,assign)CGRect rightViewFrame;
@property(nonatomic,assign)CGRect QSRankFrame;
@property(nonatomic,assign)CGRect TIMESRankFrame;
@property(nonatomic,assign)CGRect tagsOneFrame;
@property(nonatomic,assign)CGRect tagsTwoFrame;
@property(nonatomic,assign)BOOL   showMore;

//第一分区Frame
@property(nonatomic,assign)CGRect fenguanFrame;
@property(nonatomic,assign)CGRect collectionViewFrame;
@property(nonatomic,assign)CGRect lineOneFrame;
@property(nonatomic,assign)CGRect keyFrame;
@property(nonatomic,assign)CGRect subjectBgFrame;
@property(nonatomic,strong)NSArray *subjectItemFrames;
@property(nonatomic,assign)CGRect lineTwoFrame;
@property(nonatomic,assign)CGRect rankFrame;
@property(nonatomic,assign)CGRect selectionFrame;
@property(nonatomic,assign)CGRect qsFrame;
@property(nonatomic,assign)CGRect timesFrame;
@property(nonatomic,assign)CGRect historyLineFrame;
@property(nonatomic,assign)CGRect chartViewBgFrame;
@property(nonatomic,assign)CGFloat contentHeight;

+ (instancetype)frameWithUniversity:(UniversitydetailNew *)university;
@end

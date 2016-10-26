//
//  UniversityFrameApplyObj.h
//  myOffer
//
//  Created by xuewuguojie on 16/4/5.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UniversityItemNew;
@interface UniversityFrameApplyObj : NSObject
@property(nonatomic,strong)UniversityItemNew *uni;
@property(nonatomic,assign)CGRect SectionBackgroudFrame;
@property(nonatomic,assign)CGRect LogoFrame;
@property(nonatomic,assign)CGRect nameFrame;
@property(nonatomic,assign)CGRect official_nameFrame;
@property(nonatomic,assign)CGRect address_detailFrame;
@property(nonatomic,assign)CGRect anchorFrame;
@property(nonatomic,assign)CGRect RankFrame;
@property(nonatomic,assign)CGRect AddButtonFrame;
@property(nonatomic,assign)CGRect CancelButtonFrame;
@property(nonatomic,assign)CGRect starBgFrame;
@property(nonatomic,strong)NSArray *starFrames;
@property(nonatomic,assign)CGRect hotFrame;

@end


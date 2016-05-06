//
//  UniversityFrame.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/31.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UniversityObj;

@interface UniversityFrame : NSObject
@property(nonatomic,strong)UniversityObj *uniObj;
@property(nonatomic,assign)CGRect selectButtonFrame;
@property(nonatomic,assign)CGRect LogoFrame;
@property(nonatomic,assign)CGRect TitleFrame;
@property(nonatomic,assign)CGRect SubTitleFrame;
@property(nonatomic,assign)CGRect LocalFrame;
@property(nonatomic,assign)CGRect  LocalMVFrame;
@property(nonatomic,assign)CGRect RankFrame;
@property(nonatomic,assign)CGRect starBgFrame;
@property(nonatomic,strong)NSArray *starFrames;

@end

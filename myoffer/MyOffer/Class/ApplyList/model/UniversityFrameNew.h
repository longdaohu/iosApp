//
//  UniversityFrameNew.h
//  myOffer
//
//  Created by xuewuguojie on 16/4/5.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UniversityNew;
@interface UniversityFrameNew : NSObject
@property(nonatomic,strong)UniversityNew *universtiy;
@property(nonatomic,assign)CGRect SectionBackgroudFrame;
//logo
@property(nonatomic,assign)CGRect LogoFrame;
//学校名称
@property(nonatomic,assign)CGRect nameFrame;
//英文名称
@property(nonatomic,assign)CGRect official_nameFrame;
//地址
@property(nonatomic,assign)CGRect address_detailFrame;
//地址图标
@property(nonatomic,assign)CGRect anchorFrame;
//排名
@property(nonatomic,assign)CGRect RankFrame;
//添加按钮
@property(nonatomic,assign)CGRect AddButtonFrame;
//删除按钮
@property(nonatomic,assign)CGRect CancelButtonFrame;
//显示星星
@property(nonatomic,assign)CGRect starBgFrame;
//星号Frame
@property(nonatomic,strong)NSArray *starFrames;
//推荐
@property(nonatomic,assign)CGRect hotFrame;
//底部分隔线
@property(nonatomic,assign)CGRect bottom_line_Frame;

+(instancetype)universityFrameWithUniverstiy:(UniversityNew *)universtiy;

@end


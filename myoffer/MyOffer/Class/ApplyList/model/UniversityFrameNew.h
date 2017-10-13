//
//  UniversityFrameNew.h
//  myOffer
//
//  Created by xuewuguojie on 16/4/5.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyOfferUniversityModel;
@interface UniversityFrameNew : NSObject
@property(nonatomic,strong)MyOfferUniversityModel *universtiy;
@property(nonatomic,assign)CGRect SectionBackgroudFrame;
//logo
@property(nonatomic,assign)CGRect icon_Frame;
//学校名称
@property(nonatomic,assign)CGRect name_Frame;
//英文名称
@property(nonatomic,assign)CGRect official_Frame;
//地址
@property(nonatomic,assign)CGRect address_Frame;
//排名
@property(nonatomic,assign)CGRect rank_Frame;
//添加按钮
@property(nonatomic,assign)CGRect add_Frame;
//删除按钮
@property(nonatomic,assign)CGRect cancel_Frame;
//显示星星
@property(nonatomic,assign)CGRect starBgFrame;
//星号Frame
@property(nonatomic,strong)NSArray *starFrames;
//推荐
@property(nonatomic,assign)CGRect hot_Frame;
//底部分隔线
@property(nonatomic,assign)CGRect bottom_line_Frame;

@property(nonatomic,assign)CGFloat cell_Height;

@property(nonatomic,strong)NSArray *courseFrames;


+(instancetype)universityFrameWithUniverstiy:(MyOfferUniversityModel *)universtiy;

@end



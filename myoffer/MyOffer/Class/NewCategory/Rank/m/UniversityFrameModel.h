//
//  UniversityFrameModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyOfferUniversityModel.h"

@interface UniversityFrameModel : NSObject
@property(nonatomic,strong)MyOfferUniversityModel *universityModel;
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
//底部分隔线
@property(nonatomic,assign)CGRect bottom_line_Frame;

@property(nonatomic,assign)CGRect cell_Frame;
@property(nonatomic,assign)CGFloat cell_Height;

+(instancetype)universityFrameWithUniverstiy:(MyOfferUniversityModel *)universtiy;

@end

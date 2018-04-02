//
//  SMDetailHeaderFrame.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMDetailMedol.h"

@interface SMDetailHeaderFrame : NSObject
@property(nonatomic,strong)SMDetailMedol *detailModel;
@property(nonatomic,assign)CGRect title_Frame;
@property(nonatomic,assign)CGRect sub_Frame;
@property(nonatomic,strong)NSArray *tag_frames;
@property(nonatomic,assign)CGRect tagView_Frame;
@property(nonatomic,assign)CGRect intro_Frame;
@property(nonatomic,assign)CGRect regist_Frame;
@property(nonatomic,assign)CGRect line_Frame;
@property(nonatomic,assign)CGRect head_Frame;
@property(nonatomic,assign)CGRect name_Frame;
@property(nonatomic,assign)CGRect uni_Frame;
@property(nonatomic,assign)CGRect guest_hiden_Frame;
@property(nonatomic,assign)CGRect guest_show_Frame;
@property(nonatomic,assign)CGRect bottom_Frame;
@property(nonatomic,assign)CGFloat header_height;

+ (instancetype)frameWithDetail:(SMDetailMedol *)detail;


@end

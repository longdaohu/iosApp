//
//  YaSiHomeModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YSScheduleModel;
@class YasiCatigoryModel;
@class YasiCatigoryItemModel;

@interface YaSiHomeModel : NSObject
@property(nonatomic,copy)NSString *user_coin;
@property(nonatomic,assign)NSInteger coin;
@property(nonatomic,assign)BOOL login_state;
@property(nonatomic,strong)YSScheduleModel *living_item;
@property(nonatomic,strong)NSArray *banners;
@property(nonatomic,strong)NSArray *banner_images;
@property(nonatomic,strong)NSArray *banner_targets;
@property(nonatomic,strong)NSArray *catigorys;
@property(nonatomic,strong)NSArray *catigory_titles;
@property(nonatomic,assign)CGFloat catigory_title_fontSize;
@property(nonatomic,strong)NSArray *catigory_title_frames;
@property(nonatomic,assign)NSInteger  catigory_title_selected_index;
@property(nonatomic,assign)NSInteger  catigoryPackage_item_selected_index;
@property(nonatomic,strong)YasiCatigoryModel *catigory_current;
@property(nonatomic,strong)YasiCatigoryItemModel *catigory_Package_current;
@property(nonatomic,copy)NSString *banner_target;

@property(nonatomic,assign)CGFloat left_margin;
@property(nonatomic,assign)CGSize header_banner_size;
@property(nonatomic,assign)CGRect ysBtn_frame;
@property(nonatomic,assign)CGRect signedBtn_frame;
@property(nonatomic,assign)CGRect signTitle_frame;
@property(nonatomic,assign)CGRect banner_box_frame;
@property(nonatomic,assign)CGRect banner_pageControl_frame;
@property(nonatomic,assign)CGRect catigory_box_frame;
@property(nonatomic,assign)CGRect catigory_collectView_frame;
@property(nonatomic,assign)CGRect cati_clt_line_frame;
@property(nonatomic,assign)CGRect cati_clct_bottom_line_frame;
@property(nonatomic,assign)CGRect cati_active_frame;
@property(nonatomic,assign)CGRect price_cell_frame;

@property(nonatomic,assign)CGRect livingBtn_frame;
@property(nonatomic,assign)CGRect clockBtn_frame;
@property(nonatomic,assign)CGRect onlineLab_frame;
@property(nonatomic,assign)CGRect bottomView_frame;

@property(nonatomic,assign)CGRect bannerView_frame;
@property(nonatomic,assign)CGRect line_banner_frame;

@property(nonatomic,assign)CGRect header_frame;

@end



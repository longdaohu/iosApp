//
//  YaSiHomeModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YaSiHomeModel.h"
#import "YSScheduleModel.h"
#import "YasiCatigoryModel.h"
#import "HomeBannerObject.h"
#import "YasiCatigoryModel.h"
#import "YasiCatigoryItemModel.h"

@interface YaSiHomeModel()

@end

@implementation YaSiHomeModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.left_margin = 20;
        self.catigory_title_fontSize = 18;
        [self makeSubviewesFrame];
    }
    return self;
}


- (void)makeSubviewesFrame{
    
    CGFloat max_width = XSCREEN_WIDTH;
    CGFloat max_y = 0;
    
    //雅思评测试
    CGFloat ys_y = 0;
    CGFloat ys_w = 90;
    CGFloat ys_h = ys_w;
    CGFloat ys_x = max_width - ys_w;
    self.ysBtn_frame = CGRectMake(ys_x, ys_y, ys_w, ys_h);
    max_y = CGRectGetMaxY(self.ysBtn_frame);
    
    //--------------------- 签到
    CGFloat sg_btn_x = self.left_margin;
    CGFloat sg_btn_h = 23;
    CGFloat sg_btn_y =  37;
    CGFloat sg_btn_w = 92;
    self.signedBtn_frame = CGRectMake(sg_btn_x, sg_btn_y, sg_btn_w, sg_btn_h);
 
    CGFloat sg_tt_x = sg_btn_x + sg_btn_w + 8;
    CGFloat sg_tt_h = sg_btn_h;
    CGFloat sg_tt_y = sg_btn_y;
    CGFloat sg_tt_w = ys_x - sg_tt_x;
    self.signTitle_frame = CGRectMake(sg_tt_x, sg_tt_y, sg_tt_w, sg_tt_h);
    //--------------------- 签到

    //--------------------- 直播
    CGFloat clock_btn_x = sg_btn_x;
    CGFloat clock_btn_y =  sg_btn_h + sg_btn_y + 32;
    CGFloat clock_btn_h = 37;
    CGFloat clock_btn_w = clock_btn_h;
    self.clockBtn_frame = CGRectMake(clock_btn_x, clock_btn_y, clock_btn_w, clock_btn_h);
    
    CGFloat bg_btn_x = clock_btn_x + 10;
    CGFloat bg_btn_y = clock_btn_y + 6;
    CGFloat bg_btn_h = 31;
    CGFloat bg_btn_w = max_width - bg_btn_x - self.left_margin;
    self.livingBtn_frame = CGRectMake(bg_btn_x, bg_btn_y, bg_btn_w, bg_btn_h);
    max_y = CGRectGetMaxY(self.livingBtn_frame);
    //--------------------- 直播
    
    
    //--------------------- 轮播图
    if (self.banners.count > 0) {
        [self makeBannerBoxFrame];
        max_y = CGRectGetMaxY(self.banner_box_frame);
    }
    //--------------------- 轮播图
    
    //--------------------- 商品
    if (self.catigorys.count > 0) {
        [self makeCatigoryBoxFrame];
        max_y = CGRectGetMaxY(self.catigory_box_frame);
    }
    //--------------------- 商品
    
    CGFloat header_height =  max_y;
    self.header_frame = CGRectMake(0, 0, XSCREEN_WIDTH, header_height);

}


- (void)makeCatigoryBoxFrame{
    
    CGFloat box_x = 0;
    CGFloat box_y = CGRectGetMaxY(self.banner_box_frame) + 30;
    if (!self.banners) {
        box_y = CGRectGetMaxY(self.livingBtn_frame) + 30;
    }
    if (!self.banners && !self.living_item) {
        box_y = CGRectGetMaxY(self.ysBtn_frame) + 30;
    }
    CGFloat box_w = XSCREEN_WIDTH;
    CGFloat box_h = 0;

    CGFloat padding = 20;
    CGFloat title_x = 0;
    CGFloat title_y = 0;
    CGFloat title_w = 0;
    CGFloat title_h = 25;
    NSMutableArray *titles_temp = [NSMutableArray array];
    for (NSInteger index = 0; index < self.catigory_titles.count; index++) {
        NSString *title = self.catigory_titles[index];
        CGSize title_size =[title stringWithfontSize:self.catigory_title_fontSize];
        title_w = title_size.width+3;
        CGRect title_frame = CGRectMake(title_x, title_y, title_w, title_h);
        [titles_temp addObject:[NSValue valueWithCGRect:title_frame]];
        title_x += (padding + title_w);
    }
    title_x -= padding;
    
    CGFloat half_x = (box_w - title_x) * 0.5;
    
    NSMutableArray *titleFrames = [NSMutableArray array];
    for (NSValue *itemFrame in titles_temp) {
        CGRect item = itemFrame.CGRectValue;
        item.origin.x += half_x;
        NSValue *value = [NSValue valueWithCGRect:item];
        [titleFrames addObject:value];
    }
    self.catigory_title_frames = titleFrames;
 
    CGFloat line_x = self.left_margin;
    CGFloat line_y = title_h + 20;
    CGFloat line_w = box_w - line_x * 2;
    CGFloat line_h = 1;
    self.line_banner_frame = CGRectMake(line_x, line_y, line_w, line_h);
    
    CGFloat active_x = 0;
    CGFloat active_w = 0;
    if (titleFrames.count > 0) {
        NSValue *value = titleFrames.firstObject;
        active_w =  value.CGRectValue.size.width;
        active_x =  value.CGRectValue.origin.x;
    }
    CGFloat active_h = 2;
    CGFloat active_y =  line_y - active_h;
    self.cati_active_frame = CGRectMake(active_x, active_y, active_w, active_h);
    
    
    CGFloat ct_cv_x = 0;
    CGFloat ct_cv_y = line_y + line_h;
    CGFloat ct_cv_w = box_w;
    CGFloat ct_cv_h = 91;
    self.catigory_collectView_frame = CGRectMake(ct_cv_x, ct_cv_y, ct_cv_w, ct_cv_h);
    
    CGFloat ct_cv_bt_line_x = 0;
    CGFloat ct_cv_bt_line_y = ct_cv_y + ct_cv_h;
    CGFloat ct_cv_bt_line_w = box_w;
    CGFloat ct_cv_bt_line_h = 1;
    self.cati_clct_bottom_line_frame = CGRectMake(ct_cv_bt_line_x, ct_cv_bt_line_y, ct_cv_bt_line_w, ct_cv_bt_line_h);
    
    CGFloat ct_cv_line_x = 0;
    CGFloat ct_cv_line_y = ct_cv_y + ct_cv_h;
    CGFloat ct_cv_line_w = box_w;
    CGFloat ct_cv_line_h = 1;
    self.cati_clt_line_frame = CGRectMake(ct_cv_line_x, ct_cv_line_y, ct_cv_line_w, ct_cv_line_h);
 
    CGFloat price_cell_x = 0;
    CGFloat price_cell_y = ct_cv_line_y + ct_cv_line_h;
    CGFloat price_cell_w = box_w;
    CGFloat price_cell_h = 60;
    self.price_cell_frame = CGRectMake(price_cell_x, price_cell_y, price_cell_w, price_cell_h);
 
    box_h =  price_cell_h + price_cell_y;
    self.catigory_box_frame = CGRectMake(box_x, box_w, box_w, box_h);
    
}

- (void)makeBannerBoxFrame{

    CGFloat banner_box_x = 0;
    CGFloat banner_box_y = CGRectGetMaxY(self.livingBtn_frame) + 20;

    CGFloat banner_box_w = XSCREEN_WIDTH;
    CGFloat banner_box_h = 0;
    
    CGFloat banner_x = 0;
    CGFloat banner_y = 0;
    CGFloat banner_w = XSCREEN_WIDTH - banner_x * 2;
    CGFloat banner_h = banner_w * 189.0/335;
    self.bannerView_frame = CGRectMake(banner_x, banner_y, banner_w, banner_h);
    self.header_banner_size = CGSizeMake(banner_w - 40, banner_h - 5);
    
    banner_box_h = banner_h + 20;
    self.banner_box_frame = CGRectMake(banner_box_x, banner_box_y, banner_box_w, banner_box_h);
}


- (void)setLiving_item:(YSScheduleModel *)living_item{
    
    _living_item = living_item;
    if (!living_item) return;
    [self makeSubviewesFrame];
}

- (void)setBanners:(NSArray *)banners{
    
    _banners = banners;
    if (!banners) return;
    
    NSMutableArray *url_arr = [NSMutableArray array];
    NSMutableArray *target_arr = [NSMutableArray array];
    for (HomeBannerObject *banner in banners) {
        if (banner.image && banner.target) {
            [url_arr addObject:banner.image];
            [target_arr addObject:banner.target];
        }
    }
    self.banner_images = url_arr;
    self.banner_targets = target_arr;
    
    [self makeSubviewesFrame];
}

- (void)setCatigorys:(NSArray *)catigorys{
    
    _catigorys = catigorys;
    
    if (!catigorys) return;
    
    self.catigory_titles  = [catigorys valueForKey:@"name"];
    [self makeSubviewesFrame];
}

- (YasiCatigoryModel *)catigory_current{
    
    return self.catigorys[self.catigory_title_selected_index];
}

- (YasiCatigoryItemModel *)catigory_Package_current{
 
     YasiCatigoryItemModel  *item  = self.catigory_current.servicePackage[self.catigoryPackage_item_selected_index];
    
     return item;
}

- (NSInteger)coin{
    
    if (LOGIN && self.user_coin.length > 0) {
        return  self.user_coin.integerValue;
    }
    
    return 0;
}



@end

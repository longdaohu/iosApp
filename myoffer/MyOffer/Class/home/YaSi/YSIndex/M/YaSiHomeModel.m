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
    CGFloat clock_btn_y =  sg_btn_h + sg_btn_y + 15;
    CGFloat clock_btn_h = 37;
    CGFloat clock_btn_w = clock_btn_h;
    self.clockBtn_frame = CGRectMake(clock_btn_x, clock_btn_y, clock_btn_w, clock_btn_h);
    
    CGFloat bg_btn_x = clock_btn_x + 17;
    CGFloat bg_btn_y = clock_btn_y + 6;
    CGFloat bg_btn_h = 31;
    CGFloat bg_btn_w = max_width - bg_btn_x - self.left_margin;
    self.livingBtn_frame = CGRectMake(bg_btn_x, bg_btn_y, bg_btn_w, bg_btn_h);
    max_y = CGRectGetMaxY(self.livingBtn_frame);
    
    CGFloat live_box_x = CGRectGetMaxX(self.clockBtn_frame);
    CGFloat live_box_y = bg_btn_y;
    CGFloat live_box_w = CGRectGetMaxX(self.livingBtn_frame) - live_box_x - 5;
    CGFloat live_box_h = bg_btn_h;
    self.living_box_frame = CGRectMake(live_box_x, live_box_y, live_box_w, live_box_h);
    //--------------------- 直播
    
    //--------------------- 轮播图
    if (self.banners.count > 0 && CGRectIsEmpty(self.banner_box_frame)) {
        [self makeBannerBoxFrame];
        max_y = CGRectGetMaxY(self.banner_box_frame);
    }
    if (!CGRectIsEmpty(self.banner_box_frame)) {
        max_y = CGRectGetMaxY(self.banner_box_frame);
    }
    //--------------------- 轮播图
    
    //--------------------- 商品
    if (self.catigorys.count > 0 && CGRectIsEmpty(self.catigory_box_frame)) {
        [self makeCatigoryBoxFrame];
        max_y = CGRectGetMaxY(self.catigory_box_frame);
    }
    if (!CGRectIsEmpty(self.catigory_box_frame)) {
        max_y = CGRectGetMaxY(self.catigory_box_frame);
    }
    //--------------------- 商品
    
    CGFloat header_height =  max_y;
    self.header_frame = CGRectMake(0, 0, XSCREEN_WIDTH, header_height);
    
}


- (void)makeCatigoryBoxFrame{
    
    CGFloat box_x = 0;
    CGFloat box_y = CGRectGetMaxY(self.banner_box_frame);
    if (!self.banners) {
        box_y = CGRectGetMaxY(self.livingBtn_frame);
    }
    
    CGFloat box_w = XSCREEN_WIDTH;
    CGFloat box_h = 0;
    
    CGFloat padding = 20;
    CGFloat title_x = 0;
    CGFloat title_y = 0;
    CGFloat title_w = 0;
    CGFloat title_h = 70;
    NSMutableArray *titles_temp = [NSMutableArray array];
    
    NSArray *titles = self.catigory_titles.count > 2 ? [self.catigory_titles subarrayWithRange:NSMakeRange(0, 2)] : self.catigory_titles;
    for (NSInteger index = 0; index < titles.count; index++) {
        NSString *title = titles[index];
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
    
    CGFloat line_x = -box_w;
    CGFloat line_w = box_w * 3;
    CGFloat line_h = 40;
    CGFloat line_y = title_h - line_h;
    self.line_banner_frame = CGRectMake(line_x, line_y, line_w, line_h);
    
    CGFloat ct_cv_x = 0;
    CGFloat ct_cv_y = line_y + line_h - 15;
    CGFloat ct_cv_w = box_w;
    CGFloat ct_cv_h = 91 + 15;
    self.catigory_collectView_frame = CGRectMake(ct_cv_x, ct_cv_y, ct_cv_w, ct_cv_h);
    
    CGFloat ct_cv_bt_line_x = 20;
    CGFloat ct_cv_bt_line_y = ct_cv_y + ct_cv_h;
    CGFloat ct_cv_bt_line_w = box_w - ct_cv_bt_line_x * 2;
    CGFloat ct_cv_bt_line_h = LINE_HEIGHT;
    self.cati_clct_bottom_line_frame = CGRectMake(ct_cv_bt_line_x, ct_cv_bt_line_y, ct_cv_bt_line_w, ct_cv_bt_line_h);
    
    CGFloat ct_cv_line_x = 0;
    CGFloat ct_cv_line_y = ct_cv_y + ct_cv_h;
    CGFloat ct_cv_line_w = box_w;
    CGFloat ct_cv_line_h = LINE_HEIGHT;
    self.cati_clt_line_frame = CGRectMake(ct_cv_line_x, ct_cv_line_y, ct_cv_line_w, ct_cv_line_h);
    
    CGFloat price_cell_x = 0;
    CGFloat price_cell_y = ct_cv_line_y;
    CGFloat price_cell_w = box_w;
    CGFloat price_cell_h = 60;
    self.price_cell_frame = CGRectMake(price_cell_x, price_cell_y, price_cell_w, price_cell_h);
    
    box_h =  price_cell_h + price_cell_y;
    self.catigory_box_frame = CGRectMake(box_x, box_y, box_w, box_h);
    
}

- (void)makeBannerBoxFrame{
    
    CGFloat banner_box_x = 0;
    CGFloat banner_box_y = CGRectGetMaxY(self.livingBtn_frame) + 20;
    
    CGFloat banner_box_w = XSCREEN_WIDTH;
    CGFloat banner_box_h = 0;
    
    CGFloat banner_w = XSCREEN_WIDTH - 40;
    CGFloat banner_h = banner_w * 378.0/670;
    self.header_banner_size = CGSizeMake(banner_w, banner_h);
    banner_w = XSCREEN_WIDTH;
    CGFloat banner_x = 0;
    CGFloat banner_y = 0;
    self.bannerView_frame = CGRectMake(banner_x, banner_y, banner_w, banner_h);
    
    banner_box_h = banner_h + 20;
    self.banner_box_frame = CGRectMake(banner_box_x, banner_box_y, banner_box_w, banner_box_h);
    
    CGFloat page_x  = 20;
    CGFloat page_h  = 10;
    CGFloat page_y  = banner_box_h - page_h;
    CGFloat page_w  = self.banner_images.count * 16;
    self.banner_pageControl_frame = CGRectMake(page_x, page_y, page_w, page_h);
}

- (void)setLiving_items:(NSArray *)living_items{
    _living_items = living_items;
    
    if (living_items.count > 0) {
        [self makeSubviewesFrame];
    }
}

 

- (NSArray *)living_titles{
    
    NSArray *living_titles = @[@"今天没有新课程，复习一下学完的课程吧"];
    if (LOGIN && self.living_items) {
        NSArray *titles = [self.living_items valueForKeyPath:@"living_text"];
        living_titles = titles;
    }
    
    return living_titles;
}

- (void)setBanners:(NSArray *)banners{
    
    _banners = banners;
    
    if (!banners) return;
    NSMutableArray *url_arr = [NSMutableArray array];
    NSMutableArray *target_arr = [NSMutableArray array];
    for (HomeBannerObject *banner in banners) {
        if (banner.image) {
            [url_arr addObject:banner.image];
            NSString *target = banner.target.length == 0 ? @"" :  banner.target;
            [target_arr addObject:target];
        }
    }
    self.banner_images = url_arr;
    self.banner_targets = target_arr;
    if (self.banner_images.count > 0) {
        [self makeSubviewesFrame];
    }
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

- (BOOL)living_items_loaded{

    return    self.living_items.count > 0 ? YES : NO;
}



@end

//
//  SMDetailHeaderFrame.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMDetailHeaderFrame.h"

@implementation SMDetailHeaderFrame

+ (instancetype)frameWithDetail:(SMDetailMedol *)detail{

    SMDetailHeaderFrame *head_frame = [[SMDetailHeaderFrame alloc] init];
    
    head_frame.detailModel = detail;
    
    return head_frame;
}


- (void)setDetailModel:(SMDetailMedol *)detailModel{


    _detailModel = detailModel;
    
    CGFloat Margin = 10;
    CGFloat padding = 15;
    
    NSString *vedio  =  (detailModel.has_audio)  ? @"音频"  : @"";
    NSString *audio  =  (detailModel.has_video)  ? @"视频"  : @"";
    NSString *title = [NSString stringWithFormat:@"%@%@%@",vedio,audio,detailModel.main_title];
    
    // 1 标题
    CGFloat title_x =  Margin;
    CGFloat title_y =  Margin;
    CGFloat title_w =  XSCREEN_WIDTH - title_x * 2;
    CGSize title_size = [title KD_sizeWithAttributeFont:[UIFont systemFontOfSize:16] maxWidth:title_w];
    CGFloat title_h =  title_size.height + 10;
    self.title_Frame = CGRectMake(title_x, title_y, title_w, title_h);
    
    
    //2 标签
    CGFloat tags_x =  title_x;
    CGFloat tags_y =  CGRectGetMaxY(self.title_Frame) + Margin;
    CGFloat tags_w =  title_w;
    CGFloat tags_h =  16;
    self.tagView_Frame = CGRectMake(tags_x, tags_y, tags_w, tags_h);
    
    //3 小标签
    NSMutableArray *tags_temp = [NSMutableArray array];
    CGFloat  tag_h = tags_h;
    CGFloat  tag_y = 0;
    CGFloat  tag_x = 0;
    CGFloat  tag_tmp = 0;
    for (NSInteger index = 0; index < detailModel.tags.count; index++) {
    
        NSString *tagStr = detailModel.tags[index];
        CGSize   tagSize = [tagStr KD_sizeWithAttributeFont:[UIFont systemFontOfSize:12]];
        CGFloat  tag_w = tagSize.width + 10;
        tag_x += tag_tmp;
        CGRect tag_Frame = CGRectMake(tag_x,tag_y, tag_w, tag_h);
        tag_tmp = tag_w + Margin;
        if (tag_x + tag_w > tags_w) return;
         [tags_temp addObject:[NSValue valueWithCGRect:tag_Frame]];
    }
    
    self.tag_frames = [tags_temp copy];
    
    
    
    //4 活动介绍
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = 18;
    NSDictionary *attr = @{
                           NSFontAttributeName:[UIFont systemFontOfSize:12],
                           NSParagraphStyleAttributeName : paragraphStyle
                           };
    
    CGFloat intro_x =  title_x;
    CGFloat intro_y =  CGRectGetMaxY(self.tagView_Frame) + padding;
    CGFloat intro_w =  title_w;
    CGSize intro_size = [detailModel.introduction KD_sizeWithAttribute:attr maxWidth:intro_w];
    CGFloat intro_h =  intro_size.height;
    self.intro_Frame = CGRectMake(intro_x, intro_y, intro_w, intro_h);
    
    CGRect topFrame = self.intro_Frame;
    
    // 5 注册按钮
    if (!detailModel.islogin) {

        CGFloat reginst_x =  title_x;
        CGFloat reginst_y =  CGRectGetMaxY(self.intro_Frame) + padding;
        CGFloat reginst_w =  title_w;
        CGFloat reginst_h =  40;
        self.regist_Frame = CGRectMake(reginst_x, reginst_y, reginst_w, reginst_h);
        
        topFrame = self.regist_Frame;
        
    }else{
    
        self.regist_Frame = CGRectZero;
        
    }
    
    //6  分割线
    CGFloat line_x = title_x;
    CGFloat line_y = CGRectGetMaxY(topFrame) + padding;
    CGFloat line_w = title_w;
    CGFloat line_h = LINE_HEIGHT;
    self.line_Frame = CGRectMake(line_x, line_y, line_w, line_h);
    
    
    //7 头像
    CGFloat head_x = title_x;
    CGFloat head_y = CGRectGetMaxY(self.line_Frame) + padding;
    CGFloat head_h = 40;
    CGFloat head_w = head_h;
    self.head_Frame = CGRectMake(head_x, head_y, head_w, head_h);
    
    //8 用户名
    CGFloat name_x = head_x + head_w + Margin;
    CGFloat name_y = head_y;
    CGFloat name_h = 20;
    CGFloat name_w = title_w - name_x;
    self.name_Frame = CGRectMake(name_x, name_y, name_w, name_h);
    
    //9 学校
    CGFloat uni_x =  name_x;
    CGFloat uni_y =  CGRectGetMaxY(self.name_Frame);
    CGFloat uni_h =  name_h;
    CGFloat uni_w =  title_w - uni_x;
    self.uni_Frame = CGRectMake(uni_x, uni_y, uni_w, uni_h);
    
    //10 嘉宾介绍
    CGFloat gest_x =  title_x;
    CGFloat gest_y =  CGRectGetMaxY(self.head_Frame) + padding;
    CGFloat gest_w =  title_w;
    CGSize guest_size = [detailModel.guest_introduction  KD_sizeWithAttribute:attr maxWidth:gest_w];
    CGFloat gest_h =  guest_size.height;
    self.guest_show_Frame = CGRectMake(gest_x, gest_y, gest_w, gest_h);

    CGRect guest_rect = self.guest_show_Frame;
    NSInteger  line_count = gest_h/paragraphStyle.minimumLineHeight;
    
    if (line_count > 3 && !detailModel.guest_intr_ShowAll) {
        //10 - 1 嘉宾介绍简介
        gest_h = paragraphStyle.minimumLineHeight * 3;
        self.guest_hiden_Frame = CGRectMake(gest_x, gest_y, gest_w, gest_h);
        guest_rect =self.guest_hiden_Frame;
        
        NSString *more_str = @"查看全部";
        NSString *dish_str = @"...";
        NSInteger limit_gest_length =  detailModel.guest_introduction.length * 3/ line_count - more_str.length - dish_str.length;
        NSString *gest_sub = [detailModel.guest_introduction substringWithRange:NSMakeRange(0, limit_gest_length)];
        detailModel.guest_intr_short_sub   = [NSString stringWithFormat:@"%@%@%@",gest_sub,dish_str,more_str];
        
    }else{
    
         //10 - 2 嘉宾介绍全部展示
        detailModel.guest_intr_ShowAll = YES;

    }
    
    //11 分割线
    CGFloat bottom_x =  0;
    CGFloat bottom_y =  CGRectGetMaxY(guest_rect) + padding;
    CGFloat bottom_h =  padding;
    CGFloat bottom_w =  XSCREEN_WIDTH;
    self.bottom_Frame = CGRectMake(bottom_x, bottom_y, bottom_w, bottom_h);
    
    
    self.header_height = CGRectGetMaxY(self.bottom_Frame);
 

}

@end

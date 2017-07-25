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
    
    
    CGFloat title_x =  Margin;
    CGFloat title_y =  Margin;
    CGFloat title_w =  XSCREEN_WIDTH - title_x * 2;
    CGSize title_size = [title KD_sizeWithAttributeFont:[UIFont systemFontOfSize:16] maxWidth:title_w];
    CGFloat title_h =  title_size.height + 10;
    self.title_Frame = CGRectMake(title_x, title_y, title_w, title_h);
    
    
    CGFloat tags_x =  title_x;
    CGFloat tags_y =  CGRectGetMaxY(self.title_Frame) + Margin;
    CGFloat tags_w =  title_w;
    CGFloat tags_h =  16;
    self.tagView_Frame = CGRectMake(tags_x, tags_y, tags_w, tags_h);
    
    
    
    
    NSMutableArray *tags_temp = [NSMutableArray array];
    
    CGFloat  tag_h = tags_h;
    CGFloat  tag_y = 0;
    CGFloat  tag_x = 0;

    for (NSInteger index = 0; index < detailModel.tags.count; index++) {
    
        NSString *tagStr = detailModel.tags[index];
        CGSize   tagSize = [tagStr KD_sizeWithAttributeFont:[UIFont systemFontOfSize:12]];
        CGFloat  tag_w = tagSize.width + 10;
        
        tag_x += index *(tag_w + Margin);
        
        CGRect tag_Frame = CGRectMake(tag_x,tag_y, tag_w, tag_h);
        
        if (tag_x + tag_w > tags_w) return;
     
         [tags_temp addObject:[NSValue valueWithCGRect:tag_Frame]];
        
    }
    
    self.tag_frames = [tags_temp copy];
    
    
    CGFloat intro_x =  title_x;
    CGFloat intro_y =  CGRectGetMaxY(self.tagView_Frame) + padding;
    CGFloat intro_w =  title_w;
    CGSize intro_size = [detailModel.introduction KD_sizeWithAttributeFont:[UIFont systemFontOfSize:12] maxWidth:intro_w];
    CGFloat intro_h =  intro_size.height;
    self.intro_Frame = CGRectMake(intro_x, intro_y, intro_w, intro_h);
    
    
    CGRect topFrame = self.intro_Frame;
    
    
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
    
    CGFloat line_x = title_x;
    CGFloat line_y = CGRectGetMaxY(topFrame) + padding;
    CGFloat line_w = title_w;
    CGFloat line_h = LINE_HEIGHT;
    self.line_Frame = CGRectMake(line_x, line_y, line_w, line_h);
    
    
    CGFloat head_x = title_x;
    CGFloat head_y = CGRectGetMaxY(self.line_Frame) + padding;
    CGFloat head_h = 40;
    CGFloat head_w = head_h;
    self.head_Frame = CGRectMake(head_x, head_y, head_w, head_h);
    
    
    CGFloat name_x = head_x + head_w + Margin;
    CGFloat name_y = head_y;
    CGFloat name_h = 20;
    CGFloat name_w = title_w - name_x;
    self.name_Frame = CGRectMake(name_x, name_y, name_w, name_h);
    
    
    CGFloat uni_x =  name_x;
    CGFloat uni_y =  CGRectGetMaxY(self.name_Frame);
    CGFloat uni_h =  name_h;
    CGFloat uni_w =  title_w - uni_x;
    self.uni_Frame = CGRectMake(uni_x, uni_y, uni_w, uni_h);
    
    
    CGFloat gest_x =  title_x;
    CGFloat gest_y =  CGRectGetMaxY(self.head_Frame);
    CGFloat gest_w =  title_w;
    
    
//    CGSize test_size = [@"我是中国人" KD_sizeWithAttributeFont:[UIFont systemFontOfSize:12] maxWidth:gest_w];
    CGSize guest_size = [detailModel.guest_introduction  KD_sizeWithAttributeFont:[UIFont systemFontOfSize:12] maxWidth:gest_w];
    CGFloat gest_h =  guest_size.height;
    self.guest_intr_Frame = CGRectMake(gest_x, gest_y, gest_w, gest_h);
    

    
    
    CGFloat bottom_x =  0;
    CGFloat bottom_y =  CGRectGetMaxY(self.guest_intr_Frame) + padding;
    CGFloat bottom_h =  padding;
    CGFloat bottom_w =  XSCREEN_WIDTH;
    self.bottom_Frame = CGRectMake(bottom_x, bottom_y, bottom_w, bottom_h);
    
    
    self.header_height = CGRectGetMaxY(self.bottom_Frame);
 

}

@end

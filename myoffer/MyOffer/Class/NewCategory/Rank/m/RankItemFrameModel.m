//
//  RankItemFrameModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "RankItemFrameModel.h"
#import "UniversityFrameModel.h"

@implementation RankItemFrameModel

- (void)setRankItem:(RankTypeModel *)rankItem{
    
    _rankItem = rankItem;
    
    CGFloat  margin = 20;

    CGFloat  header_x = 0;
    CGFloat  header_y = 0;
    CGFloat  header_w = XSCREEN_WIDTH;
    CGFloat  header_h = 0;
    
    CGFloat  desc_x = margin;
    CGFloat  desc_y = margin;
    CGFloat  desc_w = header_w - desc_x * 2;
    CGFloat  desc_h = [rankItem.descrpt KD_sizeWithAttributeFont:[UIFont systemFontOfSize:16] maxWidth:desc_w].height;
    self.desc_frame = CGRectMake(desc_x, desc_y, desc_w, desc_h);
    
    header_h = desc_h + desc_y * 2;
    self.header_frame = CGRectMake(header_x, header_y, header_w, header_h);
    
 
    NSMutableArray *tmps = [NSMutableArray array];
    for (MyOfferUniversityModel *uni in rankItem.universities) {
        UniversityFrameModel *uni_frame = [UniversityFrameModel universityFrameWithUniverstiy:uni];
        [tmps addObject:uni_frame];
    }
    
    self.university_frames = [tmps copy];
    
}


@end



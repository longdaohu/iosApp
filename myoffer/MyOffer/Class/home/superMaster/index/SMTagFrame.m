//
//  SMTagFrame.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMTagFrame.h"

@implementation SMTagFrame



+ (instancetype)frameWithtag:(SMTagModel *)tag{
    
    SMTagFrame *newsFrame = [[SMTagFrame alloc] init];
    
    newsFrame.tag = tag;
    
    return newsFrame;
}


- (void)setTag:(SMTagModel *)tag{
    
    _tag = tag;
    
    CGFloat margin = 10.0;
    
    if (tag.topic.count == 0 && tag.subject.count == 0) {
    
        self.cell_height = HEIGHT_ZERO;
        
        return;
    }

    
    CGFloat topic_w = XSCREEN_WIDTH - 20;
    CGFloat topic_x = margin;
    CGFloat topic_y = 0;
    CGFloat topic_h = 0;
    self.topicFrame = CGRectMake(topic_x, topic_y, topic_w, topic_h);
    
    self.topicFrames = [self frameWithItems:tag.topic maxWidth:topic_w];
    NSNumber *last_topic = self.topicFrames.lastObject;
    CGRect  last_topic_frame = last_topic.CGRectValue;
    topic_h = CGRectGetMaxY(last_topic_frame);
    self.topicFrame = CGRectMake(topic_x, topic_y, topic_w, topic_h);
    
    BOOL topic_true = tag.topic.count > 0 ? YES : NO;
    BOOL subject_true = tag.subject.count > 0 ? YES : NO;
    
    
    CGFloat line_x = topic_x;
    CGFloat line_y = CGRectGetMaxY(self.topicFrame) + margin;
    CGFloat line_w = (topic_true && subject_true) ? topic_w : 0;
    CGFloat line_h = LINE_HEIGHT;
    self.lineFrame = CGRectMake(line_x, line_y, line_w, line_h);
    
    CGRect top_rect =  self.lineFrame;
    
     if (!topic_true) {
        
         top_rect = CGRectZero;
    }
    
 
    
    CGFloat subject_x = topic_x;
    CGFloat subject_y = CGRectGetMaxY(top_rect) + margin;
    CGFloat subject_w = topic_w;
    CGFloat subject_h = 0;
    self.subjectFrame = CGRectMake(subject_x, subject_y, subject_w, subject_h);
    
    
    self.subjectFrames = [self frameWithItems:[tag.subject valueForKeyPath:@"name"] maxWidth:subject_w];
    NSNumber *last_sub = self.subjectFrames.lastObject;
    CGRect  last_sub_frame = last_sub.CGRectValue;
    subject_h = CGRectGetMaxY(last_sub_frame);
    self.subjectFrame = CGRectMake(subject_x, subject_y, subject_w, subject_h);

    
    if ( subject_true) {
        
        top_rect =  self.subjectFrame;
    }
    
 
    self.cell_height =  CGRectGetMaxY(top_rect) + margin;
    
}


-(NSArray *)frameWithItems:(NSArray *)items maxWidth:(CGFloat) maxWidth
{
     NSMutableArray *temps =[NSMutableArray array];
    
    //第一个 label的起点
    CGSize startSize = CGSizeMake(0, 0);
    //间距
    CGFloat padding = 10.0;
    
    CGFloat MAXWidth = maxWidth;
    
    for (int i = 0; i < items.count; i ++) {
        
        CGFloat keyWordWidth = [items[i] KD_sizeWithAttributeFont:[UIFont systemFontOfSize:16]].width + 20;
        
        if (keyWordWidth > MAXWidth) {
            
            keyWordWidth = MAXWidth;
        }
        
        if (MAXWidth - startSize.width < keyWordWidth) {
            
            startSize.height += 40.0;
            
            startSize.width = 0;
        }
        
        
        CGRect itemRect = CGRectMake(startSize.width, startSize.height, keyWordWidth, 30);
        
        
        [temps addObject:[NSNumber valueWithCGRect:itemRect]];
        
        //起点 增加
        startSize.width += keyWordWidth + padding;
        
    }
    
    return [temps copy];
}





@end
    

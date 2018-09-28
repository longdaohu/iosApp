//
//  YasiCatigoryItemModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YasiCatigoryItemModel.h"

@implementation YasiCatigoryItemModel

-  (instancetype)init{
    self = [super init];
    if (self) {
        
        self.cell_courseCaveat_height = HEIGHT_ZERO;
        self.cell_courseQuestions_height = HEIGHT_ZERO;
        self.cell_courseDescription_height = HEIGHT_ZERO;
        self.cell_courseOutline_height = HEIGHT_ZERO;
    }
    
    return self;
}

- (NSArray *)items{
    
    
    if (!_items) {
        
        NSMutableArray *items_tmp = [NSMutableArray array];
        if (self.courseDescription.count > 0) {
            [items_tmp addObject:self.courseDescription];
            
        }else{
            
            [items_tmp addObject:@[@"test"]];
        }
        
        if (self.courseOutline.count > 0) {
            [items_tmp addObject:self.courseOutline];
        }else{
            [items_tmp addObject:@[@"test"]];
        }
        
        if (self.courseCaveats.count > 0) {
            [items_tmp addObject:self.courseCaveats];
        }else{
            [items_tmp addObject:@[@"test"]];
        }
        
        if (self.courseQuestions.count > 0) {
            [items_tmp addObject:self.courseQuestions];
        }else{
            [items_tmp addObject:@[@"test"]];
        }
        
        _items = items_tmp;
    }
    
    return _items;
}

- (NSArray *)frameWithItems:(NSArray *)images{
    
    NSMutableArray *value_Arr = [NSMutableArray array];
    
    CGFloat max_y = 0;
    if (images.count > 0) {
        max_y = 28;
    }
    
    for (NSString *item in images ) {
        
        NSArray *items = [item componentsSeparatedByString:@"-"];
        
        if (items.count > 0) {
            
            NSArray *tmp = [items.lastObject  componentsSeparatedByString:@"."];
            
            if (tmp.count > 0) {
                
                NSArray *countes = [tmp.firstObject  componentsSeparatedByString:@"x"];
                CGFloat width = [countes.firstObject floatValue];
                CGFloat height = [countes.lastObject floatValue];
                height *= (XSCREEN_WIDTH / width);
                width = XSCREEN_WIDTH;
                CGRect  imageFrame = CGRectMake(0, max_y , width, height);
                [value_Arr addObject:[NSValue valueWithCGRect:imageFrame]];
                
                max_y +=height;
            }
            
        }
    }
    
    return value_Arr;
}


- (void)setCourseCaveats:(NSArray *)courseCaveats{
    _courseCaveats = courseCaveats;
    
    self.imageFrame_courseCaveats = [self frameWithItems:courseCaveats];
    
    if (self.imageFrame_courseCaveats.count > 0) {
        
        NSValue *last = self.imageFrame_courseCaveats.lastObject;
        self.cell_courseCaveat_height = CGRectGetMaxY(last.CGRectValue);
        
    }else{
        self.cell_courseCaveat_height = HEIGHT_ZERO;
    }
    
}
- (void)setCourseQuestions:(NSArray *)courseQuestions{
    _courseQuestions =  courseQuestions;
    
    self.imageFrame_courseQuestions = [self frameWithItems:courseQuestions];
    if (self.imageFrame_courseQuestions.count > 0) {
        NSValue *last = self.imageFrame_courseQuestions.lastObject;
        self.cell_courseQuestions_height = CGRectGetMaxY(last.CGRectValue);
    }else{
        self.cell_courseQuestions_height = HEIGHT_ZERO;
    }
}


- (void)setCourseOutline:(NSArray *)courseOutline{
    
    _courseOutline =  courseOutline;
    
    self.imageFrame_courseOutline = [self frameWithItems:courseOutline];
    if (self.imageFrame_courseOutline.count > 0) {
        NSValue *last = self.imageFrame_courseOutline.lastObject;
        self.cell_courseOutline_height = CGRectGetMaxY(last.CGRectValue);
    }else{
        self.cell_courseOutline_height = HEIGHT_ZERO;
    }
    
}

- (void)setCourseDescription:(NSArray *)courseDescription{
    _courseDescription = courseDescription;
    
    self.imageFrame_courseDescription = [self frameWithItems:courseDescription];
    
    if (self.imageFrame_courseDescription.count > 0) {
        
        NSValue *last = self.imageFrame_courseDescription.lastObject;
        self.cell_courseDescription_height = CGRectGetMaxY(last.CGRectValue);
    }else{
        self.cell_courseDescription_height = HEIGHT_ZERO;
    }
    
}


- (NSArray *)cell_heigh_arr{
    
    
    if (!_cell_heigh_arr) {
        
        CGFloat mini_height = XSCREEN_HEIGHT * 0.8;
        if (self.cell_courseDescription_height < mini_height && self.cell_courseDescription_height > HEIGHT_ZERO) {
            self.cell_courseDescription_height = mini_height;
        }
        if (self.cell_courseOutline_height < mini_height && self.cell_courseDescription_height > HEIGHT_ZERO) {
            self.cell_courseOutline_height = mini_height;
        }
        if (self.cell_courseQuestions_height < mini_height && self.cell_courseDescription_height > HEIGHT_ZERO) {
            self.cell_courseQuestions_height = mini_height;
        }
        if (self.cell_courseCaveat_height < mini_height && self.cell_courseDescription_height > HEIGHT_ZERO) {
            self.cell_courseCaveat_height = mini_height;
        }
        
        _cell_heigh_arr = @[
                              @(self.cell_courseDescription_height),
                              @(self.cell_courseOutline_height),
                              @(self.cell_courseCaveat_height),
                              @(self.cell_courseQuestions_height)
                      ];
    }
    
    return _cell_heigh_arr;
}


- (NSArray *)imagesFrame_arr{
    
    if (!_imagesFrame_arr) {
        
        NSArray *items = @[[NSValue valueWithCGRect:CGRectZero]];
        
        NSMutableArray *items_tmp = [NSMutableArray array];
        if (self.imageFrame_courseDescription.count > 0) {
            [items_tmp addObject:self.imageFrame_courseDescription];
        }else{
            [items_tmp addObject:items];
        }
        
        if (self.imageFrame_courseOutline > 0) {
            [items_tmp addObject:self.imageFrame_courseOutline];
        }else{
            [items_tmp addObject:items];
        }

        if (self.imageFrame_courseCaveats > 0) {
            [items_tmp addObject:self.imageFrame_courseCaveats];
        }else{
            [items_tmp addObject:items];
        }
        
        if (self.imageFrame_courseQuestions > 0) {
            [items_tmp addObject:self.imageFrame_courseQuestions];
        }else{
            [items_tmp addObject:items];
        }
        
        _imagesFrame_arr = items_tmp;
    }
    
    return _imagesFrame_arr;
}


@end


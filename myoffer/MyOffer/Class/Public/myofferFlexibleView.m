//
//  myofferFlexibleView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/8.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "myofferFlexibleView.h"

@implementation myofferFlexibleView

+ (instancetype)flexibleViewWithFrame:(CGRect)frame{
    
    myofferFlexibleView *flexiableView = [[myofferFlexibleView alloc] initWithFrame:frame];
    flexiableView.clipsToBounds = YES;

    return flexiableView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
  
            UIImageView *coverView = [[UIImageView alloc] init];
            coverView.contentMode = UIViewContentModeScaleAspectFill;
            coverView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            self.coverView = coverView;
            [self addSubview:coverView];
        
    }
    return self;
}




- (void)layoutSubviews{

    [super layoutSubviews];
    
    if (CGRectContainsRect(CGRectZero, self.coverView.frame) ){
      
        self.coverView.frame = self.bounds;
        
    }
    
}

- (void)setImage_url:(NSString *)image_url{

    _image_url = image_url;
    
    NSString *path = [image_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
     [self.coverView sd_setImageWithURL:[NSURL URLWithString:path] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         
    }];
    
}

- (void)setImage_name:(NSString *)image_name{
    
    _image_name = image_name;
    
    [self.coverView setImage:[UIImage imageNamed:image_name]];
    
}


- (void)flexWithContentOffsetY:(CGFloat)offsetY{

    
    //下拉图片处理
    if (offsetY > 0) {
        
        self.coverView.frame = self.bounds;
        
        self.coverView.mj_y = -offsetY;
        
        return;
    }
    
    CGRect newRect = self.bounds;
    newRect.size.height = self.bounds.size.height - offsetY * 2;
    newRect.size.width  = self.bounds.size.width * newRect.size.height / self.bounds.size.height;
    self.coverView.frame = newRect;
    self.coverView.center = self.center;
    
}


@end

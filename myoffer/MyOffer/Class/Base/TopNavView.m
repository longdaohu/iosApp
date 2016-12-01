//
//  TopNavView.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/30.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "TopNavView.h"
@interface TopNavView ()
@property(nonatomic,strong)UIImageView *bgImageView;

@end

@implementation TopNavView

+ (instancetype)topView{

    TopNavView *nav = [[TopNavView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XNav_Height)];
    
    return nav;
}

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeUI];

    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
      
        [self makeUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self makeUI];
    }
    return self;
}

- (void)makeUI{

    self.clipsToBounds = YES;
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:bgImageView];
    
    NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"nav.png"];
    UIImage *bgImage =  [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
    bgImageView.image = bgImage;
    self.bgImageView = bgImageView;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
//    UIImage *bgImage = self.bgImageView.image;
    CGSize  contentSize = self.bounds.size;
    self.bgImageView.frame = CGRectMake(0, 0, contentSize.width,contentSize.height);

    
}


@end



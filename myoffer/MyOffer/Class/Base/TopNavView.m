//
//  TopNavView.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/30.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "TopNavView.h"
@interface TopNavView ()
@property(nonatomic,strong)UIImageView *bgView;

@end

@implementation TopNavView

+ (instancetype)topView{

    TopNavView *nav = [[TopNavView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XNAV_HEIGHT)];
    
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
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:bgView];
    
    NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"nav.png"];
    UIImage *bgImage =  [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
    bgView.image = bgImage;
    self.bgView = bgView;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    CGSize  contentSize = self.bounds.size;
    self.bgView.frame = CGRectMake(0, 0, contentSize.width,contentSize.height);
    
}


@end



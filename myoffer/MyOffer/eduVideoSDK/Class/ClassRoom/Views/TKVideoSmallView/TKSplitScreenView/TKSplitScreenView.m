//
//  TKSplitScreenView.m
//  EduClassPad
//
//  Created by lyy on 2017/11/21.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKSplitScreenView.h"
#import "TKVideoOneView.h"
#import "TKVideoTwoLinesView.h"
#import "TKVideoThreeLinesView.h"
#import "TKVideoThirteenView.h"
@class TKRoomUser;

@interface TKSplitScreenView()
@property (nonatomic, strong) NSMutableArray *videoSmallViewBackArray;
@end

@implementation TKSplitScreenView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)layoutSubviews{
    [self refreshUI];
}

- (void)addVideoSmallView:(TKVideoSmallView *)view{
    
    NSArray *arr = [NSArray arrayWithArray:self.videoSmallViewArray];
    
    for (TKVideoSmallView *videoView in arr) {
        if (!videoView.iRoomUser) {
            [self.videoSmallViewArray removeObject:videoView];
        }
    }
    for (TKVideoSmallView *videoView in self.videoSmallViewArray) {
        if (view.iVideoViewTag == videoView.iVideoViewTag ) {
            return;
        }
        
    }
    
    [self.videoSmallViewArray addObject:view];
    [self refreshUI];
    
}




- (void)refreshUI{
    
    CGFloat splitViewWidth = self.frame.size.width;
    CGFloat splitViewHeight = self.frame.size.height;
    
    
    NSInteger count = self.videoSmallViewArray.count;
    
    switch (count) {
        case 0:
        {
            for(UIView *subv in [self subviews])
            {
                [subv removeFromSuperview];
            }
        }
            break;
        case 1:
        case 2:
        case 3:
        {
            for(UIView *subv in [self subviews])
            {
                [subv removeFromSuperview];
            }
            TKVideoOneView *videoOneView = [[TKVideoOneView alloc]initWithFrame:CGRectMake(0, 0, splitViewWidth, splitViewHeight)];
            [self addSubview:videoOneView];
            videoOneView.videoSmallViewArray = self.videoSmallViewArray;
            
        }
            break;
        case 4:
        case 5:
        case 6:
        case 7:
        {
            for(UIView *subv in [self subviews])
            {
                [subv removeFromSuperview];
            }
            TKVideoTwoLinesView *videoView = [[TKVideoTwoLinesView alloc]initWithFrame:CGRectMake(0, 0, splitViewWidth, splitViewHeight)];
            [self addSubview:videoView];
            videoView.videoSmallViewArray = self.videoSmallViewArray;
            
        }
            break;
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
        {
            for(UIView *subv in [self subviews])
            {
                [subv removeFromSuperview];
            }
            TKVideoThreeLinesView *videoView = [[TKVideoThreeLinesView alloc]initWithFrame:CGRectMake(0, 0, splitViewWidth, splitViewHeight)];
            [self addSubview:videoView];
            videoView.videoSmallViewArray = self.videoSmallViewArray;
            
        }
            break;
        case 13:
        {
            for(UIView *subv in [self subviews])
            {
                [subv removeFromSuperview];
            }
            TKVideoThirteenView *videoView = [[TKVideoThirteenView alloc]initWithFrame:CGRectMake(0, 0, splitViewWidth, splitViewHeight)];
            [self addSubview:videoView];
            videoView.videoSmallViewArray = self.videoSmallViewArray;
            
        }
            break;
        default:
            break;
    }
}

- (void)deleteVideoSmallView:(TKVideoSmallView *)view{
    
    NSArray *array = [NSArray arrayWithArray:self.videoSmallViewArray];
    
    for (TKVideoSmallView *videoView in array) {
        if (videoView.iVideoViewTag == view.iVideoViewTag) {
            [self.videoSmallViewArray removeObject:videoView];
        }
    }
    [self refreshUI];
}

- (void)refreshSplitScreenView{
    
    NSArray *arr = [NSArray arrayWithArray:self.videoSmallViewArray];
    
    for (TKVideoSmallView *videoView in arr) {
        if (!videoView.iRoomUser) {
            [self.videoSmallViewArray removeObject:videoView];
        }
    }
    [self refreshUI];
}
- (void)deleteAllVideoSmallView{
    if (self.videoSmallViewArray) {
        
        [self.videoSmallViewArray removeAllObjects];
    }
    
}

- (NSMutableArray *)videoSmallViewArray{
    if (!_videoSmallViewArray) {
        self.videoSmallViewArray = [NSMutableArray array];
    }
    return _videoSmallViewArray;
}

- (NSMutableArray *)videoSmallViewBackArray{
    if (!_videoSmallViewBackArray) {
        self.videoSmallViewBackArray = [NSMutableArray array];
    }
    return _videoSmallViewBackArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

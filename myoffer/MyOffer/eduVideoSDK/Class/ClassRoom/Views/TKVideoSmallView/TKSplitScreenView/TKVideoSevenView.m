//
//  TKVideoSevenView.m
//  EduClassPad
//
//  Created by lyy on 2017/11/23.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKVideoSevenView.h"
#import "TKVideoSmallView.h"

@implementation TKVideoSevenView

- (void)setVideoSmallViewArray:(NSMutableArray *)videoSmallViewArray{
    
    CGFloat videoBackWidth = CGRectGetWidth(self.frame);
    CGFloat videoBackHeight = CGRectGetHeight(self.frame);
    
    TKVideoSmallView *oneView =(TKVideoSmallView *) videoSmallViewArray[0];
    [self addSubview:oneView];
    oneView.frame = CGRectMake(0, 0, videoBackWidth/3, videoBackHeight/2);
    
    TKVideoSmallView *secondView =(TKVideoSmallView *) videoSmallViewArray[1];
    [self addSubview:secondView];
    secondView.frame = CGRectMake(videoBackWidth/3, 0, videoBackWidth/3, videoBackHeight/2);
    
    
    TKVideoSmallView *threeView =(TKVideoSmallView *) videoSmallViewArray[2];
    [self addSubview:threeView];
    threeView.frame = CGRectMake(videoBackWidth/3*2, 0, videoBackWidth/3, videoBackHeight/2);
    
    
    TKVideoSmallView *fourView =(TKVideoSmallView *) videoSmallViewArray[3];
    [self addSubview:fourView];
    fourView.frame = CGRectMake(0, videoBackHeight/2, videoBackWidth/4, videoBackHeight/2);
    
    
    TKVideoSmallView *fiveView =(TKVideoSmallView *) videoSmallViewArray[4];
    [self addSubview:fiveView];
    fiveView.frame = CGRectMake(videoBackWidth/4, videoBackHeight/2, videoBackWidth/4, videoBackHeight/2);
    
    
    TKVideoSmallView *sixView =(TKVideoSmallView *) videoSmallViewArray[5];
    [self addSubview:sixView];
    sixView.frame = CGRectMake(videoBackWidth/4*2, videoBackHeight/2, videoBackWidth/4, videoBackHeight/2);
    
    
    TKVideoSmallView *sevenView =(TKVideoSmallView *) videoSmallViewArray[6];
    [self addSubview:sevenView];
    sevenView.frame = CGRectMake(videoBackWidth/4*3, videoBackHeight/2, videoBackWidth/4, videoBackHeight/2);
    
    
    CGRect twoRect = secondView.frame;
    //交换老师位置到第二个的位置
    if (oneView.iVideoViewTag == -1) {
        CGRect oneRect = oneView.frame;

        oneView.frame = twoRect;
        secondView.frame = oneRect;


    }else if (secondView.iVideoViewTag == -1){

    }else if (threeView.iVideoViewTag == -1){
        CGRect oneRect = threeView.frame;

        threeView.frame = twoRect;
        secondView.frame = oneRect;

    }else if (fourView.iVideoViewTag == -1){

        CGRect oneRect = fourView.frame;

        fourView.frame = twoRect;
        secondView.frame = oneRect;
    }else if (fiveView.iVideoViewTag == -1){

        CGRect oneRect = fiveView.frame;

        fiveView.frame = twoRect;
        secondView.frame = oneRect;
    }else if (sixView.iVideoViewTag == -1){

        CGRect oneRect = sixView.frame;

        sixView.frame = twoRect;
        secondView.frame = oneRect;
    }else if (sevenView.iVideoViewTag == -1){

        CGRect oneRect = sevenView.frame;

        sevenView.frame = twoRect;
        secondView.frame = oneRect;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

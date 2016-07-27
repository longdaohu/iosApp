//
//  XWGJScrollView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/4.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJScrollView.h"

@implementation XWGJScrollView


+(instancetype)view{

    XWGJScrollView *scrollView = [[self alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight - 64)];
    
    scrollView.contentSize = CGSizeMake(3*XScreenWidth, XScreenHeight);
    scrollView.pagingEnabled = YES;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.directionalLockEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    return scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
    CGPoint location = [gestureRecognizer locationInView:self];
    // 自定义scrollView监听滚动
    //    NSLog(@"velocity.x:%f----location.x:%d",velocity.x,(int)location.x%(int)[UIScreen mainScreen].bounds.size.width);
    if (velocity.x > 0.0f&&(int)location.x%(int)[UIScreen mainScreen].bounds.size.width<60) {
        return NO;
    }
    return YES;
}

@end

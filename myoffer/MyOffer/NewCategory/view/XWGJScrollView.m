//
//  XWGJScrollView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/4.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJScrollView.h"

@implementation XWGJScrollView


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

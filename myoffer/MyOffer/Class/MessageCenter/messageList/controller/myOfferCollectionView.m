//
//  myOfferCollectionView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/8.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "myOfferCollectionView.h"

@implementation myOfferCollectionView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
        CGPoint location = [gestureRecognizer locationInView:self];
        // 自定义scrollView监听滚动
        //        NSLog(@"velocity.x:%f----location.x:%d",velocity.x,(int)location.x%(int)[UIScreen mainScreen].bounds.size.width);
        if (velocity.x > 0.0f&&(int)location.x%(int)[UIScreen mainScreen].bounds.size.width < 60) {
            
            
            return NO;
            
            
        }else{
            
            
            CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
            
            return  fabs(translation.x) >  fabs(translation.y);
        }
        
        
    }else{
        
        return YES;
    }
    
}


@end

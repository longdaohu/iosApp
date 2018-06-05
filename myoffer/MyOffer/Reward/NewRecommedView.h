//
//  NewRecommedView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/1.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewRecommedView : NSObject

+ (NewRecommedView *)defaultView;
@property(nonatomic,assign)BOOL hadBeenDone;

- (void)showRecommend;
- (void)hidenAnimate:(BOOL)animate;
- (void)hadBeenSaw;

@end

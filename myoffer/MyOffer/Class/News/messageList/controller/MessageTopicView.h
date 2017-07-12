//
//  MessageTopicView.h
//  MYOFFERDEMO
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^MessageTopicViewBlock)(NSString *,NSInteger);
@interface MessageTopicView : UIView
@property(nonatomic,strong)NSArray *catigories;
@property(nonatomic,copy)MessageTopicViewBlock actionBlock;

- (void)secrollToCatigoryIndex:(NSInteger)index;

//- (void)superViewScrollViewDidScrollContentOffset:(CGPoint)offset;


@end

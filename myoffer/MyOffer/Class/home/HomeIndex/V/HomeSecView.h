//
//  HomeSecView.h
//  newOffer
//
//  Created by xuewuguojie on 2018/6/4.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeSecView : UIView
@property(nonatomic,strong)myofferGroupModel  *group;
@property(nonatomic,assign)CGFloat leftMargin;
@property(nonatomic,assign)BOOL titleInMiddle;
@property(nonatomic,copy)void(^actionBlock)(SectionGroupType);

@end

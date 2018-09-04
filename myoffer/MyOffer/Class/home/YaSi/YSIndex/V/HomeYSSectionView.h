//
//  HomeYSSectionView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeYSSectionView : UIView
@property(nonatomic,copy)void(^actionBlock)(NSInteger index);
@property(nonatomic,assign)NSInteger index_selected;
@end

//
//  IntroCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroCell : UICollectionViewCell
@property(nonatomic,strong)NSDictionary *item;
@property(nonatomic,copy)void(^acitonBlock)(void);
@end

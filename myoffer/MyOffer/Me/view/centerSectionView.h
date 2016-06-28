//
//  centerSectionView.h
//  myOffer
//
//  Created by xuewuguojie on 15/11/24.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^centerSectionViewBlock)(UIButton *sender);
@interface centerSectionView : UIView
@property(nonatomic,copy)centerSectionViewBlock sectionBlock;
@property(nonatomic,assign)NSInteger FavoriteCount;   
@property(nonatomic,assign)NSInteger PipeiCount;
@property(nonatomic,strong)NSArray *items;
@end

//
//  HomeRecommendProdoctView.h
//  MyOffer
//
//  Created by sara on 2018/7/1.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeRecommendProdoctView : UIView
@property(nonatomic,strong)myofferGroupModel *group;
@property(nonatomic,copy)void(^actionBlock)(NSString *name);

@end

@interface HomeCommoditieLayout : UICollectionViewFlowLayout

@end

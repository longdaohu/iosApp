//
//  XWGJCityCollectionViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CatigaryHotCity;
#import "MessageHotTopicMedel.h"

@interface CatigaryCityCollectionCell : UICollectionViewCell
@property(nonatomic,strong)CatigaryHotCity *city;
@property(nonatomic,strong)MessageHotTopicMedel *topic;

@end

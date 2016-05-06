//
//  SecondCollectionViewCell.h
//  myOffer
//
//  Created by sara on 16/3/27.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondCollectionViewCell : UICollectionViewCell
//蒙版
@property(nonatomic,strong)UIImageView *mengView;

@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)NSDictionary *itemInfo;

@end

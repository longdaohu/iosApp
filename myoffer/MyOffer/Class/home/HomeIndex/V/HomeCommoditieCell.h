//
//  HomeCommoditieCell.h
//  newOffer
//
//  Created by xuewuguojie on 2018/6/8.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCommoditieCell : UITableViewCell
@property(nonatomic,strong)myofferGroupModel *group;
@property(nonatomic,copy)void(^actionBlock)(NSString *name);

@end

@interface HomeCommoditieLayout : UICollectionViewFlowLayout

@end

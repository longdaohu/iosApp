//
//  centerSectionView.h
//  myOffer
//
//  Created by xuewuguojie on 15/11/24.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeCenterHeaderViewFrame.h"
typedef enum {
    centerItemTypepipei,
    centerItemTypefavor,
    centerItemTypetest
}centerItemType;//表头按钮选项

typedef void(^centerSectionViewBlock)(centerItemType type);

@interface CenterHeaderView : UIView

@property(nonatomic,copy)centerSectionViewBlock actionBlock;
@property(nonatomic,strong)NSDictionary *response;
@property(nonatomic,strong)MeCenterHeaderViewFrame *headerFrame;

+ (instancetype)centerSectionViewWithResponse:(NSDictionary * )response actionBlock:(centerSectionViewBlock)actionBlock;

@end

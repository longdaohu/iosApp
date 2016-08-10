//
//  centerSectionView.h
//  myOffer
//
//  Created by xuewuguojie on 15/11/24.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    centerItemTypepipei,
    centerItemTypefavor,
    centerItemTypeservice
}centerItemType;//表头按钮选项

typedef void(^centerSectionViewBlock)(centerItemType type);

@interface centerSectionView : UIView
@property(nonatomic,copy)centerSectionViewBlock sectionBlock;
@property(nonatomic,strong)NSDictionary *response;
@end

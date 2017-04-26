//
//  CatigaryRankkCell.h
//  myOffer
//
//  Created by xuewuguojie on 2017/4/26.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatigoryRank.h"
@interface CatigaryRankkCell : UITableViewCell
@property(nonatomic,strong)CatigoryRank *rank;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

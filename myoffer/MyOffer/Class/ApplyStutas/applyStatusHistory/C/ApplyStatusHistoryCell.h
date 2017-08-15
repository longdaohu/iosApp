//
//  ApplyStatusHistoryCell.h
//  myOffer
//
//  Created by xuewuguojie on 2017/8/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyStatusHistoryItemFrame.h"

@interface ApplyStatusHistoryCell : UITableViewCell

@property(nonatomic,strong)ApplyStatusHistoryItemFrame *histroyFrame;

+ (instancetype)cellWithTableView:(UITableView *)talbeView;

@end

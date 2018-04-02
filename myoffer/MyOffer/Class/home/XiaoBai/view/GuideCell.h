//
//  GuideCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/11/15.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuideProcess.h"


@interface GuideCell : UITableViewCell

@property(nonatomic,strong)GuideProcess *process;
@property (weak, nonatomic) IBOutlet UILabel *line_left;
@property(nonatomic,copy)void(^actionBlock)(NSString *url);

@end


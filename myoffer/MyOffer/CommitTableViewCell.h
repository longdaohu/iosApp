//
//  CommitTableViewCell.h
//  MyOffer
//
//  Created by xuewuguojie on 15/10/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "peronInfoItem.h"

@interface CommitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *contentTextF;

@property(nonatomic,strong)peronInfoItem *item;


@end

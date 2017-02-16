//
//  MeViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/7/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ItemTypeClickNO = 0,
    ItemTypeClickPipei,
    ItemTypeClickFavor,
    ItemTypeClickApplyList,
    ItemTypeClickApplyStatus,
    ItemTypeClickApplyMatial,
    ItemTypeClickMyoffer
}ItemTypeClick;


@interface MeViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *OptionButton;
//已选择服务项
@property(nonatomic,assign)ItemTypeClick clickType;

-(void)leftViewMessage;


@end

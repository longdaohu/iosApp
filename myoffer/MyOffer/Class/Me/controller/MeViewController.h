//
//  MeViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/7/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CenterClickItemTypeNoClick,
    CenterClickItemTypePipei,
    CenterClickItemTypeFavor,
    CenterClickItemTypeServiceMall,
    CenterClickItemTypeApplyList,
    CenterClickItemTypeApplyStatus,
    CenterClickItemTypeApplyMatial,
    CenterClickItemTypeMyoffer
}CenterClickItemType;

@interface MeViewController : BaseViewController {

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *OptionButton;
//已选择服务项
@property(nonatomic,assign)CenterClickItemType clickType;

-(void)leftViewMessage;


@end

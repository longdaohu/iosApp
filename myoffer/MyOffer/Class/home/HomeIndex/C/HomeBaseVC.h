//
//  HomeBaseVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeRoomIndexCityObject.h"
#import "HomeRoomIndexCommentsObject.h"
#import "HomeRoomIndexEventsObject.h"
#import "HomeRoomIndexFlatsObject.h"
#import "HomeRoomIndexFrameObject.h"
#import "HomeSecView.h"

@interface HomeBaseVC : BaseViewController
@property(nonatomic,strong)HomeRoomIndexFrameObject *roomFrameObj;
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,assign)UITableViewStyle type;
@property(nonatomic,strong)UITableView *tableView;

- (void)toReLoadTable;
- (void)toLoadView;
- (void)toSetTabBarhidden;
- (void)reloadSection:(NSInteger)section;

@end

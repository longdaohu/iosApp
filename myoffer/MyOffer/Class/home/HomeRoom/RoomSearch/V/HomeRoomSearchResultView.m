//
//  HomeRoomSearchResultView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/15.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomSearchResultView.h"
#import "RoomSearchResultItemModel.h"

@interface HomeRoomSearchResultView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)void(^hideBlock)(BOOL);
@end

@implementation HomeRoomSearchResultView

+ (instancetype)viewWithHidenCompletion:(void (^)(BOOL))completion{
    
    HomeRoomSearchResultView *item = [[HomeRoomSearchResultView alloc] init];
    item.hideBlock = completion;
    
    return item;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeTableView];
    }
    return self;
}

- (void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = XCOLOR_WHITE;
    [self addSubview:self.tableView];
    self.tableView.rowHeight = 60;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)setItems:(NSArray *)items{
    _items = items;
    [self.tableView reloadData];
}

#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.items.count;
}

static NSString *identify = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    RoomSearchResultItemModel *item = self.items[indexPath.row];
    cell.textLabel.text = item.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hide];
    if (self.actionBlock) {
        RoomSearchResultItemModel *item = self.items[indexPath.row];
        self.actionBlock(item.item_id);
    }
    
}

- (void)show{
    
    [self coverShow:YES];
}

- (void)hide{
    [self coverShow:NO];
}

- (void)coverShow:(BOOL)show{
    
    CGFloat alp = show ? 1 : 0;
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.alpha = alp;
    } completion:^(BOOL finished) {
        if (!show) {
            
            self.items = nil;
            [self.tableView reloadData];
            self.alpha = 0;
            
            if (self.hideBlock) {
                self.hideBlock(finished);
            }
        }
    }];
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (void)dealloc{
    
    NSLog(@"输入结果 +  HomeRoomSearchResultView + dealloc");
}

@end


//
//  HomeRoomSearchResultView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/15.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomSearchResultView.h"

@interface HomeRoomSearchResultView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) UILabel *alerLab;
@property(nonatomic,copy)void(^hideBlock)(BOOL);
@property(nonatomic,assign)BOOL currentTableState;
@property(nonatomic,strong) RoomSearchResultItemModel *item_selected;

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
    self.tableView.backgroundColor = XCOLOR_WHITE;
    [self addSubview:self.tableView];
    self.tableView.rowHeight = 60;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 80)];
    UILabel *alerLab = [[UILabel alloc] initWithFrame:footer.bounds];
    alerLab.textColor = XCOLOR_TITLE;
    alerLab.font = XFONT(14);
    alerLab.textAlignment = NSTextAlignmentCenter;
    alerLab.numberOfLines = 0;
    [footer addSubview:alerLab];
    self.alerLab = alerLab;
    self.tableView.tableFooterView = footer;

}

- (void)setItems:(NSArray *)items{
    _items = items;
    
    [self.tableView reloadData];
    self.alerLab.text = @"";
}

#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.items.count;
}

static NSString *identify = @"HomeRoomSearchResultView";
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
     self.item_selected = self.items[indexPath.row];

    [self hide];
 
}

#pragma mark : 事件处理

- (BOOL)state{
    
    return self.currentTableState;
}

- (void)show{
    
    [self coverShow:YES];
}

- (void)hide{
    
    [self coverShow:NO];
}

- (void)coverShow:(BOOL)show{
    
    self.currentTableState = show;
    
    CGFloat alp = show ? 1 : 0;
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.alpha = alp;
    } completion:^(BOOL finished) {
        if (!show) {
            
            if (self.actionBlock && self.self.item_selected) {
                self.actionBlock(self.item_selected);
            }
            
            if (self.hideBlock) {
                self.hideBlock(finished);
            }
            [self clearAllData];
            self.alpha = 0;
            self.self.item_selected = nil;
        }
    }];
}

- (void)showError:(NSString *)error{

    self.alerLab.text = error;
    
    if (self.items) {
        
        self.items = nil;
        [self.tableView reloadData];
        
    }
}

- (void)clearAllData{
    
    self.alerLab.text = @"";
    self.items = nil;
    [self.tableView reloadData];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (void)dealloc{
    
    NSLog(@"输入结果 +  HomeRoomSearchResultView + dealloc");
}

@end


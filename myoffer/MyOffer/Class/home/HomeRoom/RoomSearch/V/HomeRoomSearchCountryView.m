//
//  HomeRoomSearchCountryView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/6.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomSearchCountryView.h"
#import "Masonry.h"

@interface HomeRoomSearchCountryView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,assign)BOOL isTableViewShow;

@end

@implementation HomeRoomSearchCountryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeTableView];
         self.backgroundColor = XCOLOR(0, 0, 0, 0);
    }
    return self;
}

- (NSArray *)items{
    
    if (!_items) {
    
        _items = @[
                   @{ @"icon": @"uk",@"name": @"英国"},
                   @{ @"icon": @"au",@"name": @"澳大利亚"}
                   ];
    }
    return _items;
}

- (void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIButton *footer = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT)];
    [footer addTarget:self action:@selector(caseCover:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footer;
    self.tableView.backgroundColor = XCOLOR_CLEAR;
    [self addSubview:self.tableView];
    self.tableView.rowHeight = 60;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_y =  -self.items.count * self.tableView.rowHeight;
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
    
    NSDictionary *item = self.items[indexPath.row];
//    cell.imageView setImage:XImage(item[@"icon"]);
    [cell.imageView setImage:XImage(@"home_room_uk")];
    cell.textLabel.text = item[@"name"];
 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = self.items[indexPath.row];
    if (self.actionBlock) {
        self.actionBlock(item);
    }
    [self hide];
    
}

- (void)show{
    
    self.alpha = 1;
    [self coverShow:YES];
}

- (void)hide{
    
    [self coverShow:NO];
}

- (void)coverShow:(BOOL)show{
 
    UIColor *bg_color = show ? XCOLOR_COVER : XCOLOR_CLEAR;
    CGFloat bg_height = self.items.count * self.tableView.rowHeight;
    CGFloat toBeY = show ?  0 : -bg_height;
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
 
        self.tableView.mj_y = toBeY;
        self.backgroundColor = bg_color;
        
    } completion:^(BOOL finished) {
        
        if (!show) {
            self.alpha = 0;
        }
        self.isTableViewShow = show;
    }];
}

- (BOOL)coverIsHiden{
 
    return  !self.isTableViewShow;
}

- (void)caseCover:(UIButton *)sender{
    
    [self hide];
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    self.tableView.frame = self.bounds;
//}

- (void)dealloc{
 
    NSLog(@"HomeRoomSearchCountryView + dealloc + 选择国家");
}


@end

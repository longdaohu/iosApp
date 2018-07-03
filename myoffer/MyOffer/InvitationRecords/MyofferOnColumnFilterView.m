//
//  MyofferOnColumnFilterView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "MyofferOnColumnFilterView.h"
#import "UniversityCourseFilterCell.h"
#import "AppButton.h"

@interface MyofferOnColumnFilterView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)NSMutableArray *btns;
@property(nonatomic,strong)NSMutableArray *tbs;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIButton *cover;
@property(nonatomic,strong)UIButton *current_btn;

@end

@implementation MyofferOnColumnFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.topView_h = 50;
        
        UIView *topView = [UIView new];
        topView.backgroundColor = XCOLOR_WHITE;
        self.topView = topView;
        [self addSubview:topView];
        
        UIView *bgView = [UIView new];
        self.bgView = bgView;
        [self addSubview:bgView];
        
        UIView *line = [UIView new];
        self.line = line;
        line.backgroundColor = XCOLOR_line;
        [self.topView  addSubview:line];
        
        UIButton *cover = [UIButton new];
        [cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
        _cover = cover;
        cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [bgView insertSubview:cover atIndex:0];
        
    }
    return self;
}


- (NSMutableArray *)btns{
    
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)tbs{
    
    if (!_tbs) {
        _tbs = [NSMutableArray array];
    }
    return _tbs;
}

 
- (void)setGroups:(NSArray *)groups{
    
    _groups = groups;
    
    for (NSInteger index = 0; index < groups.count; index++) {
       
        NSArray *items =  groups[index];
        NSString *title = items.firstObject;
        AppButton *item = [[AppButton alloc] init];
        item.type = MyofferButtonTypeImageRight;
        item.margin = 5;
        [item setImage:XImage(@"Triangle_Black_Down") forState:UIControlStateNormal];
        [self.topView addSubview:item];
        item.titleLabel.font = XFONT(16);
        [item setTitle:title forState:UIControlStateNormal];
        [item setTitleColor:XCOLOR_BLACK forState:UIControlStateNormal];
        [item setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateSelected];
        item.tag = index;
        [item addTarget:self action:@selector(topItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btns addObject:item];
 
        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.bgView addSubview:tb];
        tb.delegate = self;
        tb.dataSource = self;
        tb.tag = index;
        tb.rowHeight =  CELL_HEIGHT_DAFAULT;
        [tb setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tb reloadData];
        [self.tbs addObject:tb];
        
        if (!self.current_btn) self.current_btn = item;
        
        [self setNeedsLayout];
    }
    
}

- (void)topItemClick:(UIButton *)sender{
    
    if (!self.current_btn) {
        self.current_btn = sender;
    }
    
    if (self.current_btn.selected) {
       
        [self hidenTopView];
        self.current_btn.selected = NO;
        
    }else{
        
        self.current_btn = sender;
        self.current_btn.selected = YES;
        [self showTableViewWithIndex:sender.tag];
    }
  
    
}

- (void)showTableViewWithIndex:(NSInteger)index{
    
//    NSLog(@">>>> %@",sender.currentTitle);
    self.bgView.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        self.mj_h = XSCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hidenTopView{
    
    self.current_btn.selected = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.mj_h = self.topView_h;

    }];
    
}

#pragma mark :  UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger tag = tableView.tag;
    NSArray *items = self.groups[tag];
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger tag = tableView.tag;
    NSArray *items = self.groups[tag];
    static NSString *identify = @"UniversityCourseFilterCell";
    UniversityCourseFilterCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell =[[UniversityCourseFilterCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identify];
    }
    NSString *title = items[indexPath.row];
    cell.title = title;
    cell.onSelected = (self.current_btn.currentTitle  == title);
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    //选中筛选项后隐藏
    [self hidenTopView];
 
    NSInteger tag = tableView.tag;
    NSArray *items = self.groups[tag];
    NSString *title = items[indexPath.row];
    
    if (self.current_btn.currentTitle == title) return;
    [self.current_btn setTitle:title forState:UIControlStateNormal];
    
    [tableView reloadData];
 
    if (self.filterBlock) {
        self.filterBlock(tag,indexPath.row);
    }
    
}

- (void)coverClick:(UIButton *)sender{
    
    [self hidenTopView];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat top_x = 0;
    CGFloat top_y = 0;
    CGFloat top_w = contentSize.width;
    CGFloat top_h = self.topView_h;
    self.topView.frame = CGRectMake(top_x, top_y, top_w, top_h);
    
    CGFloat line_x = 0;
    CGFloat line_h = LINE_HEIGHT;
    CGFloat line_y = top_h - 1;
    CGFloat line_w = top_w;
    self.line.frame = CGRectMake(line_x, line_y, line_w, line_h);
    
    CGFloat bg_x = 0;
    CGFloat bg_y = top_h;
    CGFloat bg_w = contentSize.width;
    CGFloat bg_h = XSCREEN_HEIGHT - bg_y;
    self.bgView.frame = CGRectMake(bg_x, bg_y, bg_w, bg_h);
    
    self.cover.frame = self.bgView.bounds;
    
    if (self.btns.count > 0) {
        
        CGFloat btn_y = 0;
        CGFloat btn_w = contentSize.width/self.btns.count;
        CGFloat btn_x = 0;
        CGFloat btn_h = top_h;
        for (NSInteger index = 0; index<self.btns.count; index++) {
            btn_x = btn_w * index;
            UIButton *item = self.btns[index];
            item.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
        }
        
    }
    
    
    if (self.tbs.count > 0) {
        
        CGFloat tb_y = 0;
        CGFloat tb_x = 0;
        CGFloat tb_w = contentSize.width;
        CGFloat tb_h = 0;
        CGFloat max_height = XSCREEN_HEIGHT - top_h;
        for (NSInteger index = 0; index<self.tbs.count; index++) {
            UITableView *item = self.tbs[index];
            NSArray *ims = self.groups[item.tag];
            tb_h = ims.count * CELL_HEIGHT_DAFAULT;
            if (tb_h > max_height) {
                tb_h = max_height;
            }
            item.frame = CGRectMake(tb_x, tb_y, tb_w, tb_h);
        }
        
    }
    
}


@end


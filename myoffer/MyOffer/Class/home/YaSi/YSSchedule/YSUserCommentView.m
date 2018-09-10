//
//  YSUserCommentView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YSUserCommentView.h"
#import "YSCommentItem.h"
#import "YSUserCommentCell.h"

@interface YSUserCommentView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *items;

@end

@implementation YSUserCommentView

+ (instancetype)commentView{
    
    YSUserCommentView *view = [[YSUserCommentView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    return view;
}

- (NSArray *)items{
    
    if (!_items) {
        YSCommentItem *a_item = [[YSCommentItem alloc] init];
        a_item.title = @"系统流畅度";
        
        YSCommentItem *b_item = [[YSCommentItem alloc] init];
        b_item.title = @"课程内容实用性";
        
        YSCommentItem *c_item = [[YSCommentItem alloc] init];
        c_item.title = @"教师讲解清晰易懂";
        
        YSCommentItem *d_item = [[YSCommentItem alloc] init];
        d_item.title = @"是否按时开课";
        
        YSCommentItem *e_item = [[YSCommentItem alloc] init];
        e_item.title = @"教学过程中是否有互动";
        
        _items = @[a_item,b_item,c_item,d_item,e_item];
    }
    
    return _items;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XCOLOR_COVER;
        
        CGRect new_frame = frame;
        new_frame.origin.x = 20;
        new_frame.size.width = frame.size.width - 40;
        
        self.tableView =[[UITableView alloc] initWithFrame:new_frame style:UITableViewStyleGrouped];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView =[[UIView alloc] init];
        [self addSubview:self.tableView];
        self.tableView.rowHeight = 40;
        self.tableView.sectionHeaderHeight = 20;
        self.tableView.sectionFooterHeight= HEIGHT_ZERO;
        self.tableView.backgroundColor = XCOLOR_WHITE;
        self.tableView.layer.cornerRadius = 8;
 
        CGFloat footer_w = self.tableView.mj_w;
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0,footer_w, 60)];
        self.tableView.tableFooterView = footer;
        
        CGFloat cm_w =  80;
        CGFloat cm_x =  footer_w * 0.5 - cm_w - 13;
        CGFloat cm_y = 10;
        CGFloat cm_h = 30;
        UIButton *commitBnt = [[UIButton alloc] initWithFrame:CGRectMake(cm_x, cm_y, cm_w, cm_h)];
        [commitBnt setBackgroundImage:XImage(@"button_blue_nomal") forState:UIControlStateNormal];
        [commitBnt setBackgroundImage:XImage(@"button_blue_highlight" ) forState:UIControlStateHighlighted];
        [footer addSubview:commitBnt];
        [commitBnt addTarget:self action:@selector(caseCommit) forControlEvents:UIControlEventTouchUpInside];
        [commitBnt setTitle:@"提交" forState:UIControlStateNormal];
        commitBnt.titleLabel.font = XFONT(12);
        
        UIButton *quitBnt = [[UIButton alloc] initWithFrame:CGRectMake(footer_w * 0.5 + 13, cm_y, cm_w, 30)];
        [quitBnt setBackgroundImage:XImage(@"button_light_unable") forState:UIControlStateNormal];
        [footer addSubview:quitBnt];
        [quitBnt addTarget:self action:@selector(caseQuit) forControlEvents:UIControlEventTouchUpInside];
        [quitBnt setTitle:@"退出" forState:UIControlStateNormal];
        quitBnt.titleLabel.font = XFONT(12);

        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.mj_w, 0)];
        self.tableView.tableHeaderView = header;
        
        UILabel *titleLab = [UILabel new];
        titleLab.text = @"恭喜您完成本次课程学习，为了给您提供更优质的课程，请您对本次课程进行评价~";
        titleLab.numberOfLines = 0;
        titleLab.textColor = XCOLOR_TITLE;
        titleLab.font = [UIFont boldSystemFontOfSize:14];
        [header addSubview:titleLab];
        
        CGFloat title_x  = 15;
        CGFloat title_y  = 25;
        CGFloat title_w  = self.tableView.mj_w - title_x * 2;
        CGFloat  title_h  = [titleLab.text sizeWithfontSize:14 maxWidth:title_w].height + 6;
        titleLab.frame = CGRectMake(title_x, title_y, title_w, title_h);
        header.mj_h = title_h + title_y + 20;
        self.tableView.tableHeaderView = header;
        self.tableView.mj_h = (self.items.count  + 0.5) * self.tableView.rowHeight + header.mj_h + footer.mj_h;
        self.tableView.center = CGPointMake(XSCREEN_WIDTH * 0.5, XSCREEN_HEIGHT * 0.5);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollEnabled = NO;
        
    }
    return self;
}
 
#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YSUserCommentCell *cell =[tableView dequeueReusableCellWithIdentifier:@"YSUserCommentCell"];
    if (!cell) {
        cell = Bundle(@"YSUserCommentCell");
    }
    cell.item = self.items[indexPath.row];
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return Bundle(@"YSUserCommentSectionView");
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)caseCommit{
 
    for (YSCommentItem *item in self.items) {
       
        if (item.index_selected == 0) {
            [MBProgressHUD showMessage:[NSString stringWithFormat:@"%@",item.title]];
            return;
        }
        
    }
    
    
    NSArray *stars = [self.items valueForKey:@"index_selected"];
    if (self.actionBlock) {
        self.actionBlock(stars);
    }
}

- (void)caseQuit{
    [self hide];
}

- (void)show{
    
    self.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide{
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dealloc{
    
    KDClassLog(@"日历 + YSUserCommentView + dealloc");
}


@end

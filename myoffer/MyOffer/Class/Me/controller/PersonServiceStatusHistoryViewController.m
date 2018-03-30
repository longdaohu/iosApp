//
//  PersonServiceStatusHistoryViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/22.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "PersonServiceStatusHistoryViewController.h"
#import "ApplyStatusHistoryCell.h"
#import "ApplyStatusModelFrame.h"
#import "ApplyStatusHistoryFrameModel.h"
#import "ApplyStatusHistoryHeaderView.h"
#import "ApplyStutasCenterViewController.h"

@interface PersonServiceStatusHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *group;
@property(nonatomic,strong)ApplyStatusHistoryFrameModel *historyFrameModel;
@property(nonatomic,strong)ApplyStatusHistoryHeaderView *headerView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *closeView;

@end

@implementation PersonServiceStatusHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
}

- (void)makeUI{

    self.view.alpha = 0;
    
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.view.bounds;
    [self.view addSubview:effectView];
    //设置模糊透明度
    effectView.alpha = 1;
    
    
    CGFloat bg_x = 20;
    CGFloat bg_w = XSCREEN_WIDTH - 2 * bg_x;
    CGFloat bg_h = 400;
    CGFloat bg_y = (XSCREEN_HEIGHT - bg_h) * 0.4;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bg_x, bg_y, bg_w, bg_h)];
    self.bgView = bgView;
    [self.view addSubview:bgView];
    bgView.layer.cornerRadius = CORNER_RADIUS;
    bgView.layer.masksToBounds = YES;
    
    [self makeTableView];
    
    
    UIButton *footer = [UIButton new];
    [footer setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
    footer.titleLabel.font = [UIFont systemFontOfSize:14];
    [footer setTitle:@"查看全部状态" forState:UIControlStateNormal];
    [footer addTarget:self action:@selector(serivce) forControlEvents:UIControlEventTouchUpInside];
    CGFloat footer_h = 50;
    CGFloat footer_w = bg_w;
    CGFloat footer_y = bg_h - footer_h;
    footer.frame = CGRectMake(0, footer_y, footer_w, footer_h);
    [bgView addSubview:footer];
    footer.backgroundColor = XCOLOR_WHITE;
    footer.layer.shadowColor = XCOLOR_WHITE.CGColor;
    footer.layer.shadowOffset = CGSizeMake(0,-20);
    footer.layer.shadowRadius = 10;
    footer.layer.shadowOpacity = 0.9;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, footer_h, 0);
    
    
    UIImage *close = [UIImage imageNamed:@"close_status"];
    CGFloat close_w =  close.size.width;
    CGFloat close_h =  close.size.height;
    CGFloat close_y =  CGRectGetMaxY(bgView.frame) + 30;
    CGFloat close_x =  (XSCREEN_WIDTH - close_w) * 0.5;
    UIImageView *closeView = [[UIImageView alloc] initWithFrame:CGRectMake( close_x, close_y, close_w, close_h)];
    closeView.image = close;
    [self.view addSubview:closeView];
    
}

-(void)makeTableView
{
    
    self.tableView =[[UITableView alloc] initWithFrame:self.bgView.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bgView addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    
}




- (void)serivce{

    [self.navigationController  pushViewController:[ApplyStutasCenterViewController new] animated:YES];
    
    [self serviceHishtoryShow:NO];
}

 
- (void)setStatus_frame:(ApplyStatusModelFrame *)status_frame{
    
    _status_frame = status_frame;
    
    [self updateUIWithStatus:status_frame.statusModel];
    
    [self.tableView reloadData];
    
}


- (void)updateUIWithStatus:(ApplyStutasModel *)status{
    
    
    ApplyStatusHistoryFrameModel *historyFrameModel = [[ApplyStatusHistoryFrameModel alloc] init];
    historyFrameModel.statusModel = status;
    self.historyFrameModel = historyFrameModel;
    
    
    NSMutableArray *items_tmp = [NSMutableArray array];
    
    for (NSInteger index = 0; index < status.history.count; index++) {
        
        ApplyStutasHistoryModel *historyItem = status.history[index];
        historyItem.status_color  =  XCOLOR_SUBTITLE;
        historyItem.image_Name  =   @"dot";
        
        if (index == 0) {
            historyItem.status_color  =   XCOLOR_LIGHTBLUE;
            historyItem.image_Name  = @"dot_40x40.gif" ;
        }
        
        
        ApplyStatusHistoryItemFrame *frame_historyItem = [ApplyStatusHistoryItemFrame  frameWithHistoryItem:historyItem];
        [items_tmp addObject:frame_historyItem];
    }
    
    
    self.group = [items_tmp copy];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.group.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ApplyStatusHistoryCell *cell = [ApplyStatusHistoryCell cellWithTableView:tableView];
    
    cell.histroyFrame =self.group[indexPath.row];
    
    return cell;
}

//超出cell的bounds范围，不能显示
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.clipsToBounds = YES;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ApplyStatusHistoryItemFrame  *histroyFrame = self.group[indexPath.row];
    
    return  histroyFrame.cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return  self.historyFrameModel.header_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ApplyStatusHistoryHeaderView class]) owner:self options:nil].firstObject;
    
    _headerView.histoyFrame = self.historyFrameModel;
    
    return  _headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    
    if (scrollView.contentOffset.y <= 0 ) {
        
        [scrollView setContentOffset:CGPointZero animated:NO];
    }
    
}



#pragma mark :事件处理

- (void)serviceHishtoryShow:(BOOL)show{


    if (show) {
        
        
        self.bgView.transform =  CGAffineTransformScale(self.bgView.transform, 0.1, 0.1);

        self.view.alpha = 1;
        
        self.tabBarController.tabBar.hidden = YES;
        
        [UIView animateWithDuration:ANIMATION_DUATION animations:^{
            
            self.bgView.transform = CGAffineTransformIdentity;
            

//            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            
        } completion:^(BOOL finished) {
            
            
        }];
        
        
        return;
    }
    
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.view.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self.tableView setContentOffset:CGPointZero animated:NO];

//        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        self.tabBarController.tabBar.hidden = NO;
    }];
 
 
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self serviceHishtoryShow:NO];
}


@end

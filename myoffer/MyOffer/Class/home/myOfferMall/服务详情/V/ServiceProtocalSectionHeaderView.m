//
//  ServiceProtocalSectionHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/31.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceProtocalSectionHeaderView.h"


@interface ServiceProtocalSectionHeaderView ()
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIImageView *arrowView;
@property(nonatomic,strong)UIView *line;

@end

@implementation ServiceProtocalSectionHeaderView

+ (instancetype)tableView:(UITableView *)tableView sectionViewWithProtocalItem:(ServiceProtocalItem *)item{

    
    ServiceProtocalSectionHeaderView  *headerView  = [[ServiceProtocalSectionHeaderView alloc] init];
        
    
    headerView.item = item;
    
    
    return  headerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeUI];
    }
    return self;
    
}

- (void)makeUI{
    
    self.backgroundColor = XCOLOR_WHITE;
 
    
    UILabel *titleLab = [[UILabel  alloc] init];
    titleLab.textColor = XCOLOR_BLACK;
    self.titleLab = titleLab;
    [self addSubview:titleLab];
    titleLab.font = [UIFont boldSystemFontOfSize:16];
    titleLab.textAlignment = NSTextAlignmentLeft;
    
    UIImageView  *arrowView = [[UIImageView alloc] init];
    arrowView.image = [UIImage imageNamed:@"common_icon_arrow"];
    arrowView.contentMode = UIViewContentModeScaleAspectFill;
    self.arrowView = arrowView;
    [self addSubview:arrowView];
    
    UIView *line = [[UIView alloc] init];
    [self addSubview:line];
    self.line = line;
    line.backgroundColor = XCOLOR_line;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)];
    [self addGestureRecognizer:tap];
    
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;

    CGFloat arrow_H = 24;
    CGFloat arrow_W = arrow_H;
    CGFloat arrow_Y = 0.5 * (contentSize.height - arrow_H);
    CGFloat arrow_X = contentSize.width - arrow_W - 10;
    self.arrowView.frame = CGRectMake(arrow_X, arrow_Y, arrow_W, arrow_H);
    
    CGFloat title_X = 10;
    CGFloat title_Y = 0;
    CGFloat title_W = self.bounds.size.width - title_X - arrow_W;
    CGFloat title_H = self.bounds.size.height;
    self.titleLab.frame = CGRectMake(title_X, title_Y, title_W, title_H);

    self.line.frame = CGRectMake(5, title_H - 1, self.bounds.size.width - 10, 1);

}

- (void)onClick{
    
    if (self.actionBlock) {
        
        self.actionBlock();
    }
    
}

- (void)setItem:(ServiceProtocalItem *)item{

    _item = item;
    
    [self.titleLab setText:item.title];
    
    NSString *arrow = item.isClose ?  @"common_icon_arrow" : @"arrow_down" ;
    
    self.arrowView.image =  [UIImage imageNamed:arrow];

    
    
/*
 
    item.itemStatus
    改变arrow图片方向
    
 */
    
}


- (void)dealloc{
    
    KDClassLog(@"dealloc 留学 服务协议 详情 ServiceProtocalSectionHeaderView");
}


@end

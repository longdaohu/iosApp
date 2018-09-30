//
//  HomeRoomTopView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomTopView.h"


@interface HomeRoomTopView ()
@property(nonatomic,strong)UIButton *UK_BTN;
@property(nonatomic,strong)UIButton *AU_BTN;
@property(nonatomic,strong)UIView *actionView;
@property(nonatomic,strong)UIButton *searchBtn;
@property(nonatomic,strong)UIButton *mapView;
@property(nonatomic,strong)CAShapeLayer *shadow_layer;
@property(nonatomic,assign)BOOL isLoaded;
@end

@implementation HomeRoomTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    
    
    UIView *actionView = UIView.new;
    actionView.backgroundColor = XCOLOR_LIGHTBLUE;
    [self addSubview:actionView];
    self.actionView = actionView;
    
    UIButton *UK_BTN = [UIButton new];
    [UK_BTN setTitleColor:XCOLOR(128, 128, 128, 1) forState:UIControlStateNormal];
    [UK_BTN setTitleColor:XCOLOR_TITLE forState:UIControlStateDisabled];
    UK_BTN.titleLabel.font = XFONT(16);
    UK_BTN.enabled = NO;
    [UK_BTN addTarget:self action:@selector(toUK:) forControlEvents:UIControlEventTouchUpInside];
    [UK_BTN setTitle:@"英国" forState:UIControlStateNormal];
    [UK_BTN sizeToFit];
    [self addSubview:UK_BTN];
    self.UK_BTN = UK_BTN;
    UK_BTN.tag = HomeRoomTopViewButtonTypeUK;
    
    UIButton *AU_BTN = [UIButton new];
    [AU_BTN setTitleColor:XCOLOR(128, 128, 128, 1) forState:UIControlStateNormal];
    [AU_BTN setTitleColor:XCOLOR_TITLE forState:UIControlStateDisabled];
    AU_BTN.titleLabel.font = XFONT(16);
    [AU_BTN addTarget:self action:@selector(toAU:) forControlEvents:UIControlEventTouchUpInside];
    [AU_BTN setTitle:@"澳大利亚" forState:UIControlStateNormal];
    [AU_BTN sizeToFit];
    [self addSubview:AU_BTN];
    self.AU_BTN = AU_BTN;
    AU_BTN.tag = HomeRoomTopViewButtonTypeAU;
    
    UIButton *mapView = [UIButton new];
    mapView.imageView.contentMode = UIViewContentModeScaleToFill;
    [mapView setImage:XImage(@"home_Room_map")  forState:UIControlStateNormal];
    [mapView setImage:XImage(@"home_Room_map")  forState:UIControlStateHighlighted];
    [self addSubview:mapView];
    self.mapView = mapView;
    [mapView addTarget:self action:@selector(toMap:) forControlEvents:UIControlEventTouchUpInside];
    mapView.tag = HomeRoomTopViewButtonTypeMap;

    
    CAShapeLayer *shaper = [CAShapeLayer layer];
    shaper.shadowColor = XCOLOR_BLACK.CGColor;
    shaper.shadowOffset = CGSizeMake(0, 0);
    shaper.shadowRadius = 5;
    shaper.shadowOpacity = 0.1;
    self.shadow_layer = shaper;
    [self.layer addSublayer:shaper];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    [searchBtn setTitle:@"输入关键字城市，大学，公寓" forState:UIControlStateNormal];
    [searchBtn setImage: XImage(@"home_application_search_icon") forState:UIControlStateNormal];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    searchBtn.contentHorizontalAlignment  =  UIControlContentHorizontalAlignmentLeft;
    [self addSubview:searchBtn];
    searchBtn.backgroundColor = XCOLOR_WHITE;
    [searchBtn setTitleColor:XCOLOR(216, 216, 216, 1) forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(caseSearch:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.titleLabel.font = XFONT(12);
    self.searchBtn = searchBtn;
    self.searchBtn.layer.masksToBounds  = YES;
    searchBtn.tag = HomeRoomTopViewButtonTypeSearch;
 
    self.backgroundColor = XCOLOR_WHITE;
    self.clipsToBounds = YES;
    
}

- (void)caseSearch:(UIButton *)sender{
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
}

- (void)toUK:(UIButton *)sender{
    
   [self actionViewAnimate:sender];

    if (self.actionBlock) {
        self.actionBlock(sender);
    }
    self.AU_BTN.enabled = YES;
    sender.enabled = NO;
    self.AU_BTN.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    sender.titleLabel.font = XFONT(16);
}

- (void)toAU:(UIButton *)sender{
    
    [self actionViewAnimate:sender];

    if (self.actionBlock) {
        self.actionBlock(sender);
    }
    
    self.UK_BTN.enabled = YES;
    sender.enabled = NO;
    self.UK_BTN.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    sender.titleLabel.font = XFONT(16);
}

- (void)toMap:(UIButton *)sender{
 
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
 
}

- (void)actionViewAnimate:(UIButton *)sender{
 
    CGPoint ct = self.actionView.center;
    ct.x = sender.center.x;
    CGSize sender_size = [sender.currentTitle sizeWithfontSize:14  maxWidth:XSCREEN_WIDTH];
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.actionView.mj_w = sender_size.width;
        self.actionView.center = ct;
    }];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.isLoaded) return;
    
    CGSize content_size = self.bounds.size;
    
    CGFloat  uk_w = self.UK_BTN.mj_w + 20;
    CGFloat  uk_y = 24;
    CGFloat  uk_x = 0;
    CGFloat  uk_h = self.UK_BTN.mj_h + 10;
    
    CGFloat au_w  = self.AU_BTN.mj_w + 20;
    CGFloat au_y  = uk_y;
    CGFloat au_x  = 0;
    CGFloat au_h  = uk_h;

    uk_x = (content_size.width - uk_w - au_w) * 0.5;
    au_x = uk_x + uk_w;
    CGFloat action_w  = self.UK_BTN.mj_w;
    
    self.UK_BTN.frame = CGRectMake(uk_x, uk_y, uk_w, uk_h);
    self.AU_BTN.frame = CGRectMake(au_x, au_y, au_w, au_h);
    
 
    CGFloat search_x = 20;
    CGFloat search_y = au_y + au_h + 20;
    CGFloat search_w = content_size.width - search_x * 2;
    CGFloat search_h = 37;
    self.searchBtn.frame = CGRectMake(search_x, search_y, search_w, search_h);
    self.searchBtn.layer.cornerRadius = search_h * 0.5;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.searchBtn.frame cornerRadius:search_h * 0.5];
    self.shadow_layer.shadowPath = path.CGPath;
    
    CGFloat map_x = 0;
    CGFloat map_y = CGRectGetMaxY(self.searchBtn.frame) - 7;
    CGFloat map_w = content_size.width;
    CGFloat map_h = map_w * self.mapView.currentImage.size.height/self.mapView.currentImage.size.width;
    self.mapView.frame = CGRectMake(map_x, map_y, map_w, map_h);
    
    if (CGRectEqualToRect(self.actionView.frame, CGRectZero)) {
        CGFloat action_x  = uk_x + 10;
        CGFloat action_y  = CGRectGetMaxY(self.UK_BTN.frame) - 16;
        CGFloat action_h  = 7;
        self.actionView.frame = CGRectMake(action_x, action_y, action_w, action_h);
    }
    
    self.mj_h = CGRectGetMaxY(self.mapView.frame);
    UITableView *tb = (UITableView *)self.superview;
    tb.tableHeaderView = self;
    
    self.isLoaded = YES;
    
}

@end

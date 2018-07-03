//
//  HomeApplicationTopView.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/8.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeApplicationTopView.h"
#import "AppButton.h"

//typedef NS_ENUM(NSInteger,HomeClickButtonType) {
//    HomeClickButtonTypeWY = 0,
//    HomeClickButtonTypeGuide,
//    HomeClickButtonTypePipei,
//    HomeClickButtonTypeAsk
//};

@interface  HomeApplicationTopView()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *searchView;
@property(nonatomic,strong)UIImageView *leftView;
@property(nonatomic,strong)CAShapeLayer *shadow_layer;
@property(nonatomic,strong)UIButton *searchBtn;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)NSArray *items;

@end


@implementation HomeApplicationTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (NSArray *)items{
    
    if (!_items) {

        _items = @[@"我要留学",@"留学指南",@"智能匹配",@"资讯宝典"];
    }

    return _items;
}

- (void)makeUI{
 
    self.backgroundColor = XCOLOR_WHITE;
 
    CAShapeLayer *shaper = [CAShapeLayer layer];
//    shaper.lineWidth = 5;
    shaper.shadowColor = XCOLOR_BLACK.CGColor;
    shaper.shadowOffset = CGSizeMake(0, 0);
    shaper.shadowRadius = 5;
    shaper.shadowOpacity = 0.1;
    self.shadow_layer = shaper;
    [self.layer addSublayer:shaper];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    self.searchBtn  = searchBtn;
    [searchBtn setTitle:@"搜索梦想学校／专业／城市" forState:UIControlStateNormal];
    [searchBtn setImage: XImage(@"home_application_search_icon") forState:UIControlStateNormal];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    searchBtn.contentHorizontalAlignment  =  UIControlContentHorizontalAlignmentLeft;
    [self addSubview:searchBtn];
    searchBtn.backgroundColor = XCOLOR_WHITE;
    [searchBtn setTitleColor:XCOLOR(216, 216, 216, 1) forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(caseSearch) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.titleLabel.font = XFONT(12);

    UIView *bgView = [UIView new];
    self.bgView = bgView;
    [self addSubview:bgView];
    
    for (NSInteger i = 0; i<self.items.count; i++) {
        
        AppButton *item = [[AppButton alloc] init];
        item.tag = i;
        item.type = MyofferButtonTypeImageTop;
        item.margin =  7;
        item.titleLabel.font = XFONT(12);
        NSString *icon = [NSString stringWithFormat:@"home_menu_0%ld",(long)i];
        [item setImage: XImage(icon) forState:UIControlStateNormal];
        [item setTitle:self.items[i] forState:UIControlStateNormal];
        [item setTitleColor:XCOLOR(158, 159, 167, 1) forState:UIControlStateNormal];
        [item addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:item];
    }
    
}

- (void)menuClick:(UIButton *)sender{
    
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
}

- (void)caseSearch{
    if (self.actionBlock) {
        self.actionBlock(nil);
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize content_size = self.bounds.size;
 
    if (CGRectEqualToRect(self.searchBtn.frame, CGRectZero)) {
        
        CGFloat search_x = 40;
        CGFloat search_y = 24;
        CGFloat search_w = content_size.width - search_x * 2;
        CGFloat search_h = 37;
        self.searchBtn.frame = CGRectMake(search_x, search_y, search_w, search_h);
        self.searchBtn.layer.cornerRadius = search_h * 0.5;
        self.searchBtn.layer.masksToBounds  = YES;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.searchBtn.frame cornerRadius:search_h * 0.5];
        self.shadow_layer.shadowPath = path.CGPath;
        
        CGFloat bg_w = content_size.width;
        CGFloat bg_h = 60;
        CGFloat bg_x = 0;
        CGFloat bg_y = CGRectGetMaxY(self.searchBtn.frame) + 25;
        self.bgView.frame = CGRectMake(bg_x, bg_y, bg_w, bg_h);
        
        NSInteger item_count = self.bgView.subviews.count;
        CGFloat  padding = (content_size.width - 60 * item_count) / (item_count + 1) * 0.5;
        CGFloat  item_w =  (content_size.width - padding * 2)/ item_count;
        CGFloat  item_h = bg_h;
        CGFloat  item_y = 0;
        CGFloat  item_x = 0;
         for (NSInteger i = 0; i<self.bgView.subviews.count; i++) {
             UIButton *item = self.bgView.subviews[i];
             item_x = (item_w * i) + padding;
             item.frame = CGRectMake(item_x, item_y, item_w, item_h);
        }

        UIBezierPath *corner_path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.fillColor = [UIColor redColor].CGColor;
        shaper.path = corner_path.CGPath;
        self.layer.mask = shaper;
        
    }
}
    


@end

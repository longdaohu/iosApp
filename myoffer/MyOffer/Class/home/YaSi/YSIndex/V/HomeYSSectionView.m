//
//  HomeYSSectionView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeYSSectionView.h"

@interface HomeYSSectionView ()
@property(nonatomic,strong)UIButton *last_button;
@property(nonatomic,strong)NSArray *Btn_items;
@property(nonatomic,assign)CGFloat total_width;

@end

@implementation HomeYSSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = XCOLOR(0, 22, 34, 1);

        NSArray *titles = @[@"嘿客课程介绍",@"嘿客课程大纲",@"报名须知",@"常见问题"];
        CGFloat title_x  = 0;
        CGFloat title_y  = 15;
        CGFloat title_w  = 0;
        CGFloat title_h  = 35;
        CGFloat total_width  = 0;
        NSMutableArray *item_arr = [NSMutableArray array];
        for (NSInteger index = 0; index < titles.count; index ++ ) {
            
            UIButton *sender = [UIButton new];
            sender.tag = index;
            NSString *title = titles[index];
            [sender setTitle:title forState:UIControlStateNormal];
            sender.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [sender setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
            [sender setTitleColor:XCOLOR_BLACK forState:UIControlStateDisabled];
            [sender setBackgroundImage:nil forState:UIControlStateNormal];
            [sender setBackgroundImage:XImage(@"button_blue_nomal") forState:UIControlStateDisabled];
            [self addSubview:sender];
            [item_arr addObject:sender];
            [sender addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
            
            CGSize title_size = [title stringWithfontSize:12];
            title_w = title_size.width + 20;
            sender.frame = CGRectMake(title_x, title_y, title_w, title_h);
            total_width += title_w;
            if (index == 0 ) {
                sender.enabled = NO;
                self.last_button = sender;
            }
        }
        self.Btn_items = item_arr;
        
        self.total_width = total_width;
        
    }
    
    return self;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize content_size = self.bounds.size;
    CGFloat left_margin = 10;
    
    CGFloat padding = content_size.width - self.total_width - left_margin * 2;
    if (self.Btn_items.count > 0) {
        
        CGFloat item_x  = left_margin;
        CGFloat item_padding = padding / (self.Btn_items.count - 1);
        for (NSInteger index = 0; index < self.Btn_items.count; index++) {
            UIButton *sender = self.Btn_items[index];
            sender.mj_x = item_x;
            item_x += (sender.mj_w + item_padding);
        }
        
    }
    
}


- (void)titleClick:(UIButton *)sender{

    self.last_button.enabled = YES;
    sender.enabled = NO;
    self.last_button = sender;
    
    if (self.actionBlock) {
        self.actionBlock(sender.tag);
    }
    
}




@end

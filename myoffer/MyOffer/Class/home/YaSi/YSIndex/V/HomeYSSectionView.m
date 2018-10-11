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
@property(nonatomic,strong)UIView *bottom_line;
@property(nonatomic,strong)NSArray *Btn_items;
@property(nonatomic,assign)CGFloat total_width;

@end

@implementation HomeYSSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = XCOLOR_WHITE;

        NSArray *titles = @[@"嘿客课程介绍",@"嘿客课程大纲",@"报名须知",@"常见问题"];
        CGFloat title_x  = 0;
        CGFloat title_y  = 15;
        CGFloat title_w  = 0;
        CGFloat title_h  = 34;
        CGFloat total_width  = 0;
        NSMutableArray *item_arr = [NSMutableArray array];
        for (NSInteger index = 0; index < titles.count; index ++ ) {
            
            UIButton *sender = [UIButton new];
            sender.tag = index;
            NSString *title = titles[index];
            [sender setTitle:title forState:UIControlStateNormal];
            sender.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [sender setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
            [sender setTitleColor:XCOLOR_WHITE forState:UIControlStateDisabled];
            [sender setBackgroundImage:nil forState:UIControlStateNormal];
            [sender setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_TITLE] forState:UIControlStateDisabled];
            sender.layer.cornerRadius = title_h * 0.5;
            sender.layer.masksToBounds = YES;
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
        
        
        UIView *line = [UIView new];
        self.bottom_line = line;
        line.backgroundColor = XCOLOR(232, 232, 232, 1);
        [self addSubview:line];

    }
    
    return self;
}

- (void)setIndex_selected:(NSInteger)index_selected{
    _index_selected = index_selected;
    
    [self titleClick:self.Btn_items[index_selected]];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize content_size = self.bounds.size;
    CGFloat left_margin = 20;
    if (content_size.width<=320) {
        left_margin = 0;
    }
    
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
    
    self.bottom_line.frame = CGRectMake(20, content_size.height - LINE_HEIGHT, content_size.width - 40, LINE_HEIGHT);
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

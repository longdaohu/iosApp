//
//  HomeMenuBarView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/14.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeMenuBarView.h"

#define Across_Height 8
#define Indicator_Width 12
#define Indicator_Height Across_Height
#define Indicator_Width_half Indicator_Width * 0.5
#define Sender_Scale 1.5
#define Sender_Scale_add 0.5
#define TitleFontSize 14
#define Ani_Duration 0.3
#define Font_Regular  [UIFont systemFontOfSize:TitleFontSize weight:UIFontWeightRegular]
#define Font_Black  [UIFont systemFontOfSize:TitleFontSize weight:UIFontWeightBlack]


@interface  HomeMenuBarView()<CAAnimationDelegate>
@property(nonatomic,strong)UIScrollView *bgView;
@property(nonatomic,strong)NSArray *btn_arr;
@property(nonatomic,strong)UIButton *current_btn;
@property(nonatomic,assign)BOOL isMuneClick;
@property (strong, nonatomic)UIView *acrossView;
@property(nonatomic,strong)UIView *indicator;
@property (strong, nonatomic) CAShapeLayer *indicator_shaper;
@property(nonatomic,strong)UIBezierPath *down_path;
@property(nonatomic,strong)UIBezierPath *up_path;
@property(nonatomic,copy)void(^actionBlock)(NSInteger);

@end

@implementation HomeMenuBarView

+ (instancetype)menuInitWithTitles:(NSArray *)titles clickButton:(void(^)(NSInteger index))click{
    
    HomeMenuBarView *menu = [[HomeMenuBarView alloc] init];
    menu.actionBlock = click;
    menu.titles = titles;
    
    return menu;
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
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    UIScrollView *bgView = [[UIScrollView alloc] init];
    bgView.showsHorizontalScrollIndicator = NO;
    self.bgView = bgView;
    [self addSubview:bgView];
    
    UIView *acrossView = [[UIView alloc] init];
    self.acrossView = acrossView;
    [self.bgView addSubview:acrossView];
    
    UIView *spod =[[UIView alloc] init];
    self.indicator = spod;
    [acrossView addSubview:spod];
    CGFloat sp_x = 0;
    CGFloat sp_w = Indicator_Width;
    CGFloat sp_h = Indicator_Height;
    CGFloat sp_y = 0;
    self.indicator.frame = CGRectMake(sp_x, sp_y, sp_w, sp_h);
    
    CAShapeLayer *indicator_shaper = [[CAShapeLayer alloc] init];
    indicator_shaper.path = self.down_path.CGPath;
    indicator_shaper.backgroundColor = [UIColor clearColor].CGColor;
    indicator_shaper.fillColor = [UIColor clearColor].CGColor;
    indicator_shaper.strokeColor = XCOLOR_BLACK.CGColor;
    indicator_shaper.lineWidth = 3;
    indicator_shaper.lineJoin = @"round";
    indicator_shaper.strokeStart  = 0;
    indicator_shaper.strokeEnd = 1;
    self.indicator_shaper = indicator_shaper;
    [self.indicator.layer addSublayer:indicator_shaper];
    
}

- (UIBezierPath *)up_path{
    
    if (!_up_path) {
        
        UIBezierPath *up_path = [UIBezierPath bezierPath];
        [up_path moveToPoint:CGPointMake(0, Indicator_Height * 0.5 )];
        [up_path addLineToPoint:CGPointMake(Indicator_Width* 0.5, 0)];
        [up_path addLineToPoint:CGPointMake(Indicator_Width ,Indicator_Height * 0.5)];
        _up_path = up_path;
    }
    
    return _up_path;
}

- (UIBezierPath *)down_path{
    
    if (!_down_path) {
        UIBezierPath *down_path = [UIBezierPath bezierPath];
        [down_path moveToPoint:CGPointMake(0, Indicator_Height * 0.5 )];
        [down_path addLineToPoint:CGPointMake(Indicator_Width * 0.5, Indicator_Height)];
        [down_path addLineToPoint:CGPointMake(Indicator_Width ,Indicator_Height * 0.5)];
        _down_path = down_path;
    }
    
    return _down_path;
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    
    NSMutableArray *tmp = [NSMutableArray array];
    
    for (NSInteger index = 0; index < titles.count; index++) {
        
        UIButton *btn = [UIButton new];
        [tmp addObject:btn];
        [btn setTitle:titles[index] forState:UIControlStateNormal];
        [btn setTitleColor:XCOLOR_BLACK forState:UIControlStateNormal];
        btn.titleLabel.font = Font_Regular;
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = index;
        [self.bgView addSubview:btn];
        btn.transform =  CGAffineTransformMakeScale(1, 1);
        
    }
    
    self.btn_arr = [tmp copy];
}

- (void)initFirstResponse{
    
    self.current_btn.transform =  CGAffineTransformMakeScale(Sender_Scale, Sender_Scale);
    self.current_btn.titleLabel.font = Font_Black;
}

- (void)titleClick:(UIButton *)sender{
    
    if (self.current_btn == sender) return;
    self.isMuneClick = YES;
    [self moveToIndex:sender.tag];
    
    if (self.actionBlock) {
        self.actionBlock(sender.tag);
    }
}

- (CABasicAnimation *)indicatorAnimationWithPath:(UIBezierPath *)path duration:(CGFloat)duration{
    
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"path"];
    ani.delegate = self;
    ani.duration = duration;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.toValue = (__bridge id _Nullable)(path.CGPath);
    ani.timingFunction = [CAMediaTimingFunction functionWithName:@"easeOut"];
    
    return ani;
}

- (void)moveToIndex:(NSInteger)index{
    
    UIButton *sender = self.btn_arr[index];
    if (self.current_btn == sender) return;
    
    self.indicator_shaper.strokeColor = XCOLOR_WHITE.CGColor;
    if (index == 0) {
        self.indicator_shaper.strokeColor = XCOLOR_BLACK .CGColor;
    }
    if (self.isMuneClick) {
        //下脚标动画   完成一半动画，up动画结束后，再完成另一半动画
        CABasicAnimation *ani_up = [self indicatorAnimationWithPath:self.up_path duration:Ani_Duration * 0.5];
        [self.indicator_shaper addAnimation:ani_up forKey:@"up"];
    }
    
    
    CGFloat offset_x = sender.center.x - self.mj_w * 0.5;
    if (offset_x < 0) {
        offset_x = 0;
    }
    CGFloat  offset_max = self.bgView.contentSize.width - self.mj_w;
    if (offset_x > offset_max) {
        offset_x = offset_max;
    }
    [UIView animateWithDuration:Ani_Duration animations:^{
        self.indicator.center = CGPointMake(sender.center.x , self.indicator.center.y);
        self.bgView.mj_offsetX = offset_x;
        self.current_btn.transform =  CGAffineTransformIdentity;
        sender.transform =  CGAffineTransformMakeScale(Sender_Scale, Sender_Scale);
    } completion:^(BOOL finished) {
        self.isMuneClick = NO;
        self.bgView.userInteractionEnabled = true;
    }];
    
    
    //防止多次遍历
    if (sender.tag == 0 && self.current_btn.tag != 0) {
        for (UIButton *btn in self.btn_arr) {
            [btn setTitleColor:XCOLOR_BLACK forState:UIControlStateNormal];
        }
    }else{
        if (sender.tag > 0 && self.current_btn.tag == 0) {
            for (UIButton *btn in self.btn_arr) {
                [btn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
            }
        }
    }
    
    self.current_btn.titleLabel.font = Font_Regular;
    self.current_btn.selected = NO;
    self.current_btn = sender;
    self.current_btn.selected = YES;
    self.current_btn.titleLabel.font = Font_Black;
    
}

- (void)menuDidScrollWithScrollView:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.mj_offsetX;
    //内容在移动过程防止菜单被再次点击
    
    if (self.isMuneClick) return;
    
    if ( offsetX > scrollView.mj_w * (self.btn_arr.count - 1)) {
        offsetX = scrollView.mj_w * (self.btn_arr.count - 1);
    }
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    //改变文字大小
    CGFloat page_fl = offsetX/scrollView.mj_w;
    NSInteger left_index = (NSInteger)page_fl;
    NSInteger right_index = left_index + 1;
    UIButton *leftBtn = self.btn_arr[left_index];
    UIButton *rightBtn;
    if (right_index < self.btn_arr.count) {
        rightBtn = self.btn_arr[right_index];
    }
    CGFloat right_percent = page_fl - left_index;
    CGFloat left_percent =  1 - right_percent;
    leftBtn.transform =  CGAffineTransformMakeScale(1+left_percent*Sender_Scale_add, 1+left_percent*Sender_Scale_add);
    rightBtn.transform =  CGAffineTransformMakeScale(1+right_percent*Sender_Scale_add, 1+right_percent*Sender_Scale_add);
    
    
    //移动下角标中心点
    CGFloat offset_x = (self.current_btn.tag * scrollView.mj_w) - offsetX;
    NSInteger current_index = self.current_btn.tag;
    NSInteger next_index = current_index +1;
    if(next_index == self.btn_arr.count){
        next_index = self.btn_arr.count -1;
    }
    UIButton *next_btn = self.btn_arr[next_index];
    if (offset_x > 0) {
        next_index =  current_index -1;
        next_btn = self.btn_arr[next_index];
    }
    CGFloat move_distance = (self.current_btn.center.x - next_btn.center.x);
    CGFloat spod_move =  (offset_x > 0) ?  (move_distance  *  offset_x/scrollView.mj_w):(- move_distance  *  offset_x/scrollView.mj_w);
    self.indicator.center = CGPointMake(self.current_btn.center.x - spod_move, self.indicator.center.y);
    
    //更新下角标 path
    CGFloat pc =  offsetX / scrollView.mj_w;
    if(pc>1){
        pc = pc - (NSInteger)pc;
    }
    CGFloat middle = 0;
    if (pc > 0.5) {
        middle = (pc - 0.5) * 2 * Across_Height;
    }else{
        middle = Across_Height - 2*pc * Across_Height;
    }
    UIBezierPath *sc_path = [UIBezierPath bezierPath];
    [sc_path moveToPoint:CGPointMake(0, Across_Height * 0.5 )];
    [sc_path addLineToPoint:CGPointMake(Indicator_Width* 0.5 , middle)];
    [sc_path addLineToPoint:CGPointMake(Indicator_Width ,Across_Height * 0.5)];
    UIColor *title_color = [UIColor colorWithWhite: (1 - left_percent) alpha:1];
    if (leftBtn.tag == 0) {
        for (NSInteger index = 0; index < self.btn_arr.count; index++) {
            [self.btn_arr[index] setTitleColor:title_color forState:UIControlStateNormal];
        }
    }else{
        title_color = XCOLOR_WHITE;
    }
    
    if (self.indicator_shaper) {
        [self.indicator_shaper removeFromSuperlayer];
    }
    CAShapeLayer *indicator_shaper = [[CAShapeLayer alloc] init];
    indicator_shaper.path = sc_path.CGPath;
    indicator_shaper.fillColor = [UIColor clearColor].CGColor;
    indicator_shaper.strokeColor = title_color.CGColor;
    indicator_shaper.lineWidth = 3;
    indicator_shaper.lineJoin = @"round";
    indicator_shaper.strokeStart  = 0;
    indicator_shaper.strokeEnd = 1;
    self.indicator_shaper = indicator_shaper;
    [self.indicator.layer addSublayer:indicator_shaper];
    
    //在滚动过程中不让点击 Button
    self.bgView.userInteractionEnabled = false;
    
}
- (void)menuDidDidEndDeceleratingWithScrollView:(UIScrollView *)scrollView{
    
    self.bgView.userInteractionEnabled = true;
    if (!self.isMuneClick) {
        CGFloat page_fl = scrollView.mj_offsetX/scrollView.mj_w;
        NSInteger index = (NSInteger)page_fl;
        [self moveToIndex:index];
    }
}

#pragma mark : CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if ([anim isEqual:[self.indicator_shaper animationForKey:@"up"]]) {
        CABasicAnimation *ani = [self indicatorAnimationWithPath:self.down_path duration:Ani_Duration * 0.5];
        [self.indicator_shaper addAnimation:ani forKey:@"down"];
    }else{

        //动画结束后可以点击
        self.bgView.userInteractionEnabled = true;
    }
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize contentSize  = self.bounds.size;
    
    CGFloat bg_h = 50;
    CGFloat bg_x = 0;
    CGFloat bg_y = contentSize.height - bg_h;
    CGFloat bg_w = contentSize.width;
    self.bgView.frame = CGRectMake(bg_x, bg_y, bg_w, bg_h);
    
    CGFloat width_all = 0;
    if (self.btn_arr.count > 0 && width_all == 0) {
        CGFloat padding = 15;
        width_all = padding;
        CGFloat btn_x = 0;
        CGFloat btn_y = 0;
        CGFloat btn_h = 40;
        CGFloat btn_w = 0;
        for (NSInteger index = 0; index < self.btn_arr.count; index++) {
            
            UIButton *btn = self.btn_arr[index];
            CGSize btn_size = [btn.currentTitle stringWithfontSize:TitleFontSize];
            btn_w = (btn_size.width + 15);
            btn_x = width_all;
            btn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
            width_all +=  (btn_w + padding);
            
            if (index == 0) {
                self.current_btn = btn;
                self.current_btn.selected = YES;
                self.indicator.center = CGPointMake(btn.center.x , self.indicator.center.y);
            }
        }
        self.bgView.mj_contentW = width_all;
        self.bgView.scrollEnabled = (width_all > contentSize.width);
    }
    
    CGFloat bt_x = 0;
    CGFloat bt_h = Across_Height;
    CGFloat bt_y = self.bgView.mj_h - bt_h - 10;
    CGFloat bt_w = self.bgView.contentSize.width;
    self.acrossView.frame = CGRectMake(bt_x, bt_y, bt_w, bt_h);
    
}



@end

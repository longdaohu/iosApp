
#import "YasiCourseCell.h"

@interface YasiCourseCell ()

@end

@implementation YasiCourseCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UILabel *titleLab = [UILabel new];
        titleLab.font = [UIFont boldSystemFontOfSize:14];
        self.titleLab = titleLab;
        titleLab.textColor = XCOLOR_TITLE;
        [self.contentView addSubview:titleLab];
        titleLab.text = @"雅思6分精讲强化班";
        titleLab.textAlignment = NSTextAlignmentLeft;
        UIButton  *dateBtn = [UIButton new];
        self.dateBtn = dateBtn;
        dateBtn.titleLabel.font = XFONT(12);
        [dateBtn setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateNormal];
        [self.contentView addSubview:dateBtn];
        dateBtn.userInteractionEnabled = NO;
        [dateBtn setTitle:@"2018.01.11 — 2018.08.12" forState:UIControlStateNormal];
        [dateBtn setImage:XImage(@"ys_clock") forState:UIControlStateNormal];
        dateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        dateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        
        UIButton  *playBtn = [UIButton new];
        self.playBtn = playBtn;
        playBtn.titleLabel.font = XFONT(12);
        [playBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
        [self.contentView addSubview:playBtn];
        [playBtn setTitle:@"观看回放" forState:UIControlStateNormal];
        [playBtn setTitle:@"已过期" forState:UIControlStateDisabled];
        [playBtn setBackgroundImage:XImage(@"button_blue_nomal") forState:UIControlStateNormal];
        [playBtn setBackgroundImage:XImage(@"button_blue_highlight") forState:UIControlStateHighlighted];
        [playBtn setBackgroundImage:XImage(@"button_light_unable") forState:UIControlStateDisabled];
        playBtn.userInteractionEnabled = NO;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}



- (void)setItem:(YSCourseModel *)item{
    _item = item;
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize content_size = self.contentView.bounds.size;
    
    CGFloat left_margin = 20;
    
    CGFloat pl_w = 68;
    CGFloat pl_h = 24;
    CGFloat pl_x = content_size.width  -  left_margin - pl_w;
    CGFloat pl_y = (content_size.height - pl_h) * 0.5;
    self.playBtn.frame = CGRectMake(pl_x, pl_y, pl_w, pl_h);
    
    CGFloat title_x = left_margin;
    CGFloat title_y = 15;
    CGFloat title_w = pl_x;
    CGFloat title_h = 20;
    self.titleLab.frame = CGRectMake(title_x, title_y, title_w, title_h);
    
    CGFloat dt_x = title_x;
    CGFloat dt_y = title_y + title_h;
    CGFloat dt_w = title_w;
    CGFloat dt_h = 20;
    self.dateBtn.frame = CGRectMake(dt_x, dt_y, dt_w, dt_h);
}

@end

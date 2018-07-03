//
//  HomeUVICImmigrationProjectCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/25.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeUVICImmigrationProjectCell.h"

@interface HomeUVICImmigrationProjectCell ()
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property(nonatomic,strong)CAShapeLayer *shadowLayer;
@property(nonatomic,strong)NSMutableArray *celles;
@end

@implementation HomeUVICImmigrationProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = XCOLOR_WHITE;
    self.contentView.layer.cornerRadius = CORNER_RADIUS;
    self.contentView.layer.masksToBounds = true;
    self.titleBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setItem:(NSDictionary *)item{
    _item = item;
    
    [self.titleBtn setImage:XImage(@"home_uvic_white_icon.jpg") forState:UIControlStateNormal];
    [self.titleBtn setTitle:item[@"title"] forState:UIControlStateNormal];
    
    for (NSDictionary *dic in item[@"items"]) {
        
        ItemCellView *cell = [ItemCellView new];
        cell.item = dic;
        [self.contentView addSubview:cell];
        [self.celles addObject:cell];
    }
 
}

- (NSMutableArray *)celles{
    
    if (!_celles) {
        _celles = [NSMutableArray array];
    }
    return _celles;
}

- (CAShapeLayer *)shadowLayer{
    if (!_shadowLayer) {
        
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.shadowColor = XCOLOR_BLACK.CGColor;
        shaper.shadowOffset = CGSizeMake(0, 0);
        shaper.shadowRadius = 5;
        shaper.shadowOpacity = 0.05;
        _shadowLayer = shaper;
        
        [self.layer insertSublayer:shaper below:self.contentView.layer];
        
    }
    
    return _shadowLayer;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.shadowLayer.shadowPath) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
        self.shadowLayer.shadowPath = path.CGPath;
    }
    
    
    CGFloat ce_x = 0;
    CGFloat ce_y = CGRectGetMaxY(self.titleBtn.frame) + 5;
    CGFloat ce_w = self.bounds.size.width;
    CGFloat ce_h = 16;
    for (NSInteger index = 0; index < self.celles.count; index++) {
      
        ItemCellView *cell = self.celles[index];
        ce_h = cell.cell_height;
        cell.frame = CGRectMake(ce_x, ce_y, ce_w, ce_h);
        ce_y += (ce_h + 5);
    }
    
}

@end






@interface ItemCellView ()
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *subLab;

@end
@implementation ItemCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self makeUI];
    }
    return self;
}

- (void)makeUI{

    UILabel *titleLab = [UILabel new];
    titleLab.textAlignment = NSTextAlignmentRight;
    titleLab.font = [UIFont boldSystemFontOfSize:11];
    [self addSubview:titleLab];
    self.titleLab = titleLab;
    
    UILabel *subLab = [UILabel new];
    subLab.font = XFONT(11);
    subLab.numberOfLines = 0;
    subLab.textColor = XCOLOR(162, 162, 162, 1);
    [self addSubview:subLab];
    self.subLab = subLab;
}

- (void)setItem:(NSDictionary *)item{
    
    _item = item;
    self.titleLab.text = item[@"key"];
    self.subLab.text = item[@"value"];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
 
    if (CGRectEqualToRect(self.subLab.frame,CGRectZero)) {
        
        CGFloat title_x = 0;
        CGFloat title_y = 0;
        CGFloat title_h = 16;
        CGFloat title_w = 75;
        self.titleLab.frame = CGRectMake(title_x, title_y, title_w, title_h);
        
        CGFloat sub_x = title_w + 10;
        CGFloat sub_y = 0;
        CGFloat sub_w = 180;
        CGSize sub_size = [self.subLab.text sizeWithfontSize:12 maxWidth:sub_w];
        CGFloat sub_h =   sub_size.height > title_h ? sub_size.height : title_h;
        self.subLab.frame = CGRectMake(sub_x, sub_y, sub_w, sub_h);
        
        self.cell_height = CGRectGetMaxY(self.subLab.frame);
        
    }
    
}

@end





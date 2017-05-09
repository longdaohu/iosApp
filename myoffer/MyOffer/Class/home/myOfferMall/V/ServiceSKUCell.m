//
//  ServiceSKUCell.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceSKUCell.h"
#import "ServiceSKU.h"

@interface ServiceSKUCell ()
@property(nonatomic,strong)UIImageView *zheView;
@property(nonatomic,strong)UIImageView *coverView;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *price;
@property(nonatomic,strong)UIView *top_line;
@property(nonatomic,strong)UILabel *line;
@property(nonatomic,strong)UILabel *display_price;
@property(nonatomic,strong)UILabel *present_Value;
@property(nonatomic,strong)UIImageView *present_Key;



@end

@implementation ServiceSKUCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath SKU_Frame:(ServiceSKUFrame *)SKU_Frame{

     ServiceSKUCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SKU"];
    
    if (!cell) {
        
        cell =[[ServiceSKUCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SKU"];
        
    }
    
    tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    cell.SKU_Frame = SKU_Frame;
    
    cell.top_line.hidden =  indexPath.row != 0;
    
    return cell;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) [self makeUI];
    
    return self;
}


- (void)makeUI{
    

    // 0 、 分隔线
    UIView *top_line = [UIView new];
    self.top_line = top_line;
    top_line.backgroundColor = XCOLOR_line;
    [self.contentView addSubview:top_line];
    
    // 1 、 cover图片
    UIImageView *coverView = [[UIImageView alloc] init];
    coverView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverView = coverView;
    coverView.clipsToBounds = YES;
    [self addImageView:coverView];
    
    // 2 、 折图片
    UIImageView *zheView = [[UIImageView alloc] init];
    self.zheView = zheView;
    [self addImageView:zheView];
    zheView.image = [UIImage imageNamed:@"zhekou"];
    
    // 3 、 标题
    UILabel *name = [[UILabel alloc] init];
    self.name = name;
    [self addLable:name fontSize:16 textColor:XCOLOR_TITLE];
    
    // 4 、 价格
    UILabel *price = [[UILabel alloc] init];
    self.price = price;
    [self addLable:price fontSize:18 textColor:XCOLOR_RED];
    
    // 5 、 分隔线
    UILabel *line = [[UILabel alloc] init];
    self.line = line;
    [self addLable:line fontSize:18 textColor:XCOLOR_SUBTITLE];
    line.backgroundColor = XCOLOR_line;
    
    // 6 、原价
    UILabel *display_price = [[UILabel alloc] init];
    self.display_price = display_price;
    [self addLable:display_price fontSize:13 textColor:XCOLOR_SUBTITLE];
    
    // 7 、 赠
    UIImageView *zengSongView = [[UIImageView alloc] init];
    self.present_Key = zengSongView;
    [self addImageView:zengSongView];
    zengSongView.image = [UIImage imageNamed:@"mall_gift"];

    // 8 、 赠送描述
    UILabel *present_Value = [[UILabel alloc] init];
    self.present_Value = present_Value;
    [self addLable:present_Value fontSize:14 textColor:XCOLOR_SUBTITLE];
    present_Value.numberOfLines = 0;

}

- (void)addLable:(UILabel *)itemLable fontSize:(CGFloat)size textColor:(UIColor *)textColor{

    itemLable.font = [UIFont systemFontOfSize:size];
    itemLable.textColor = textColor;
    itemLable.numberOfLines = 2;
    [self.contentView addSubview:itemLable];

}

- (void)addImageView:(UIImageView *)itemView{

    itemView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:itemView];
    
}


- (void)setSKU_Frame:(ServiceSKUFrame *)SKU_Frame{

    _SKU_Frame = SKU_Frame;
    
   
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:SKU_Frame.SKU.cover_path] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    
    
    self.name.text = SKU_Frame.SKU.name;
    self.price.text = SKU_Frame.SKU.price_str;
    
    
    self.display_price.hidden = SKU_Frame.SKU.isZheKou;
    self.zheView.hidden = self.display_price.hidden;
    
    if (!SKU_Frame.SKU.isZheKou) {
        
         self.display_price.text = SKU_Frame.SKU.display_price_str;
        NSRange dis_price_Rangne = NSMakeRange(0, self.display_price.text.length);
        NSMutableAttributedString *attribueStr = [[NSMutableAttributedString alloc] initWithString:SKU_Frame.SKU.display_price_str];
        [attribueStr addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0)} range:dis_price_Rangne];

        self.display_price.attributedText = attribueStr;
    }
    
    self.present_Value.text = SKU_Frame.SKU.comment_present[@"value"];
    
    
    self.top_line.frame = SKU_Frame.top_line_Frame;
    self.coverView.frame = SKU_Frame.cover_Frame;
    self.zheView.frame = SKU_Frame.zhe_Frame;
    self.name.frame = SKU_Frame.name_Frame;
    self.price.frame = SKU_Frame.price_Frame;  
    self.display_price.frame = SKU_Frame.display_price_Frame;
    self.present_Key.frame = SKU_Frame.present_Key_Frame;
    self.present_Value.frame = SKU_Frame.present_Value_Frame;
    self.line.frame = SKU_Frame.line_Frame;
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

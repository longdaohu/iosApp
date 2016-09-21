//
//  UpdateCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/9/8.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UpdateCell.h"
@interface UpdateCell ()
//@property(nonatomic,strong)ServiceItemView *serviceItem;
@property(nonatomic,strong)UIView *bgView;              //1、背景
@property(nonatomic,strong)UIImageView *recommentView;  //2、推荐图标
@property(nonatomic,strong)UILabel *titleLab;           //3、套餐名称
@property(nonatomic,strong)UILabel *priceLab;           //4、套餐价格
@property(nonatomic,strong)UIImageView *priceIconView;  //5、套餐价格
@property(nonatomic,strong)UILabel *subTittleLab;       //6、套餐小标题
@property(nonatomic,strong)UIButton *selectBtn;         //7、选择边框
@property(nonatomic,strong)NSIndexPath *xindexPath;
@end

@implementation UpdateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView selectedIndexPaht:(NSIndexPath *)indexPath
{
    UpdateCell *cell =[tableView dequeueReusableCellWithIdentifier:@"update"];
    if (!cell) {
        
        cell =[[UpdateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"update"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = XCOLOR_BG;
    cell.xindexPath = indexPath;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //1、背景
        self.bgView =[[UIView alloc] init];
        self.bgView.backgroundColor = XCOLOR_WHITE;
        [self.contentView  addSubview:self.bgView];
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.borderColor =  XCOLOR(204, 204, 204).CGColor;
        self.bgView.layer.borderWidth = 0.5;
        
        //2、推荐图标
        self.recommentView =[[UIImageView alloc] init];
        self.recommentView.image = [UIImage imageNamed:@"TJ_recoment"];
        [self addSubview:self.recommentView];
        
        //3、套餐名称
        self.titleLab =[UILabel labelWithFontsize:KDUtilSize(16) TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        [self.bgView addSubview:self.titleLab];
        
        //4、套餐价格
        self.priceLab =[UILabel labelWithFontsize:KDUtilSize(20) TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentRight];
        self.priceLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:KDUtilSize(22)];
        [self.bgView addSubview:self.priceLab];
        
        //5、套餐价格
        //        self.priceIconView =[[UIImageView alloc] init];
        //        self.priceIconView.contentMode =  UIViewContentModeScaleAspectFit;
        //        [self.bgView addSubview:self.priceIconView];
        
        //6、套餐小标题
        self.subTittleLab =[UILabel labelWithFontsize:KDUtilSize(13) TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentRight];
        //        self.subTittleLab.text = @"*仅为押金，拿到offer并留学成功后返还";
        [self.bgView addSubview:self.subTittleLab];
        
        //7、选择边框
        self.selectBtn =[[UIButton alloc] init];
        [self.selectBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        self.selectBtn.layer.cornerRadius = 5;
        self.selectBtn.layer.borderColor = XCOLOR_RED.CGColor;
        [self addSubview:self.selectBtn];
        
        
    }
    
    return self;
}


- (void)setSku:(NSDictionary *)sku{

    _sku = sku;
    
    
    
    self.titleLab.text = sku[@"name"];
    
    self.subTittleLab.text = sku[@"note"] ? sku[@"note"]: @"";
    
    self.recommentView.hidden = !sku[@"recommended"];
    
    NSString *price  =[NSString stringWithFormat:@"￥%@元",sku[@"total_fee"]];
    
    NSMutableAttributedString *attribStr = [[NSMutableAttributedString alloc] initWithString:price];
    [attribStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:KDUtilSize(16)] range:NSMakeRange(price.length - 1, 1)];
    [attribStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:KDUtilSize(16)] range:NSMakeRange(0, 1)];
    [attribStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:156/255.0 green:132/255.0 blue:63/255.0 alpha:1] range:NSMakeRange(0, 1)];
    self.priceLab.attributedText = attribStr;
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat bgX = 15;
    CGFloat bgY = 2;
    CGFloat bgW = contentSize.width - 2 * bgX;
    CGFloat bgH = contentSize.height - 4;
    self.bgView.frame = CGRectMake(bgX, bgY, bgW, bgH);
    
    
    CGFloat selectX = 13;
    CGFloat selectY = 0;
    CGFloat selectW = contentSize.width - 2 * selectX;
    CGFloat selectH = contentSize.height;
    self.selectBtn.frame = CGRectMake(selectX, selectY, selectW, selectH);
    
    CGFloat rmX = 14;
    CGFloat rmY = 0;
    CGFloat rmW = bgH * 0.6;
    CGFloat rmH = rmW;
    self.recommentView.frame = CGRectMake(rmX, rmY, rmW, rmH);
    
    CGFloat titleX = 15;
    CGFloat titleH = 20;
    CGFloat titleY = 0.5 * (contentSize.height - titleH);
    CGFloat titleW = bgW * 0.6;
    self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    
//    CGSize priceSize = [self.priceLab.text  KD_sizeWithAttributeFont:[UIFont fontWithName:@"Helvetica-Bold" size:KDUtilSize(20)]];
    CGFloat priceW = bgW * 0.3;
    CGFloat priceH = KDUtilSize(20);
    CGFloat priceY = 0.5 * (bgH - priceH);
    CGFloat priceX = bgW - priceW - 10;
    self.priceLab.frame = CGRectMake(priceX, priceY, priceW, priceH);
    
    
    CGFloat subTitleX = 0;
    CGFloat subTitleH = KDUtilSize(13);
    CGFloat subTitleY = CGRectGetMaxY(self.priceLab.frame) + 5;
    CGFloat subTitleW = bgW - 10;
    self.subTittleLab.frame = CGRectMake(subTitleX, subTitleY, subTitleW, subTitleH);
    
    
}


-(void)onClick:(UIButton *)sender{
    
    sender.selected =  !sender.selected;
    sender.layer.borderWidth = sender.selected ? 1 : 0;
    
    if (self.actionBlock) {
        
         self.actionBlock(self.xindexPath,self.sku[@"_id"]);
        
     }
    
}

-(void)click{
    
    self.selectBtn.selected =  NO;
    self.selectBtn.layer.borderWidth =  self.selectBtn.selected ? 1 : 0;
}







@end

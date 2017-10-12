//
//  ServiceProductDescriptCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/9/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceProductDescriptCell.h"
@interface ServiceProductDescriptCell()
@property (weak, nonatomic) IBOutlet UILabel *valueLab;
@property (weak, nonatomic) IBOutlet UILabel *keyLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueHeightConstant;

@end

@implementation ServiceProductDescriptCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    ServiceProductDescriptCell *cell_product = [tableView dequeueReusableCellWithIdentifier:@"serviceProduct"];
    
    if (!cell_product) {
        
        cell_product = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ServiceProductDescriptCell class]) owner:self options:nil].lastObject;
    }
    
    cell_product.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell_product;
}

- (void)setCell_height:(CGFloat)cell_height{
    
    _cell_height = cell_height;
 
    self.valueHeightConstant.constant = cell_height;
}

- (void)setComment:(NSDictionary *)comment{
    
    _comment =  comment;
    self.keyLab.text = comment[@"key"];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = 20;
 
    NSDictionary *attr = @{
                           NSFontAttributeName:[UIFont systemFontOfSize:14],
                           NSParagraphStyleAttributeName : paragraphStyle
//                           NSBaselineOffsetAttributeName : @(-1)
                           };
    self.valueLab.attributedText = [[NSAttributedString alloc] initWithString:comment[@"value"] attributes:attr];
 
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

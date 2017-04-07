//
//  ServiceItemHeaderCell.m
//  myOffer
//
//  Created by xuewuguojie on 2017/4/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceItemHeaderCell.h"
#import "ServiceItemAttribute.h"

@interface ServiceItemHeaderCell ()
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIView *itemsBgView;

@end


@implementation ServiceItemHeaderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeUI];
        
    }
    return self;
}

- (void)makeUI{

    UILabel *titleLab = [[UILabel alloc] init];
    self.titleLab = titleLab;
    [self addLabel:titleLab textColor:XCOLOR_BLACK fontSize:16];
    self.titleLab.font =  [UIFont boldSystemFontOfSize:16];
    
    UIView *itemsBgView  = [UIView new];
    [self addSubview:itemsBgView];
    self.itemsBgView = itemsBgView;
    
 
}

- (void)addLabel:(UILabel *)sender textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize{
    
    sender.textColor = textColor;
    sender.font = [UIFont systemFontOfSize:fontSize];
    [self addSubview:sender];
    
}

- (void)setCellFrame:(ServiceItemCellFrame *)cellFrame{

    _cellFrame = cellFrame;
    
    ServiceItemAttribute *attribute = cellFrame.attribute;
    self.titleLab.text = attribute.key;
    
    self.titleLab.frame = cellFrame.title_frame.CGRectValue;
    self.itemsBgView.frame = cellFrame.itemBg_frame.CGRectValue;
    
    [self itemsWithOptions:attribute.options  containView:self.itemsBgView itemFrames:cellFrame.cell_items_frames];
    
}


- (void)itemsWithOptions:(NSArray *)options containView:(UIView *)containView itemFrames:(NSArray *)itemsFrames{
    
    
//    if (containView.subviews.count > 0)  [containView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    for (NSInteger a = 0; a < options.count; a++) {
        
        NSDictionary *itemDic = options[a];
        
        UIButton *sender =  [[UIButton alloc] init];
        UIColor *sender_Color = itemDic[@"selected"] ? XCOLOR_RED : XCOLOR(170, 170, 170);
        sender.layer.cornerRadius = CORNER_RADIUS;
        sender.layer.borderColor = sender_Color.CGColor;
        sender.layer.borderWidth = 1;
        [sender setTitleColor:sender_Color forState:UIControlStateNormal];
        sender.enabled =  !itemDic[@"selected"];
        [sender setTitle:itemDic[@"value"] forState:UIControlStateNormal];
        [containView addSubview:sender];
        sender.titleLabel.font = [UIFont systemFontOfSize:16];
        NSValue *countryItemRect =  itemsFrames[a];
        sender.frame = [countryItemRect CGRectValue];
        [sender addTarget:self action:@selector(senderOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}


- (void)senderOnClick:(UIButton *)sender{
    
    UIView *temp_view = sender.superview;
    
    NSString *service_id;
    
    if (temp_view.tag == 1) {
        
        for (NSDictionary *option in self.cellFrame.attribute.options) {
            
            if ([sender.currentTitle isEqualToString:option[@"value"]]) {
                
                service_id  = option[@"_id"];
                
                break;
            }
            
        }
        
    }else{
        
        
        for (NSDictionary *option in self.cellFrame.attribute.options) {
            
            if ([sender.currentTitle isEqualToString:option[@"value"]]) {
                
                service_id  = option[@"_id"];
                
                break;
            }
            
        }
        
    }
    
    
    
    if (self.actionBlcok) {
        
        self.actionBlcok(service_id);
    }
    
}




@end

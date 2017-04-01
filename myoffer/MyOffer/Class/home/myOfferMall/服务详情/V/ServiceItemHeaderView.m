//
//  ServiceItemHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/29.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceItemHeaderView.h"
@interface ServiceItemHeaderView ()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *price;
@property(nonatomic,strong)UILabel *display_price;
@property(nonatomic,strong)UILabel *first_line;
@property(nonatomic,strong)UILabel *country;
@property(nonatomic,strong)UIView *countrybgView;
@property(nonatomic,strong)UILabel *typeLab;
@property(nonatomic,strong)UIView *typeBgView;
@property(nonatomic,strong)UILabel *second_line;
@property(nonatomic,strong)UILabel *people;
@property(nonatomic,strong)UILabel *peopleDiscLab;
@property(nonatomic,strong)UILabel *third_line;
@property(nonatomic,strong)UILabel * present;
@property(nonatomic,strong)UILabel *presentDiscLab;
@property(nonatomic,copy)NSString *current_service_id;
@property(nonatomic,strong)UIView *bottomView;

@end

@implementation ServiceItemHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    
    
    UIColor *baseColor = XCOLOR(170, 170, 170);
    
    UIFont  *cellTitleFont = [UIFont boldSystemFontOfSize:16];
    
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = XCOLOR_BG;
    [self addSubview:bottomView];
    self.bottomView =  bottomView;
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = XCOLOR_WHITE;
    self.bgView = bgView;
    [self addSubview:bgView];
    bgView.layer.cornerRadius = CORNER_RADIUS;
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor =  XCOLOR_line.CGColor;
    
    //1、服务名称
    UILabel *name = [[UILabel alloc] init];
    self.name = name;
    name.numberOfLines = 0;
    [self addLabel:name textColor:[UIColor blackColor] fontSize:18];
    
    //2、价格
    UILabel *price = [[UILabel alloc] init];
    self.price = price;
    [self addLabel:price textColor:XCOLOR_RED fontSize:16];
    price.font = [UIFont boldSystemFontOfSize:16];

    //3、原价
    UILabel *display_price = [[UILabel alloc] init];
    self.display_price = display_price;
    [self addLabel:display_price textColor:baseColor fontSize:13];
    
    //3、分隔线
    UILabel *first_line = [[UILabel alloc] init];
    self.first_line = first_line;
    first_line.backgroundColor = XCOLOR_line;
    [self addLabel:first_line textColor:baseColor fontSize:15];
    
    //4、国家
    UILabel *country = [[UILabel alloc] init];
    country.text = @"国家";
    self.country = country;
    [self addLabel:country textColor:XCOLOR_BLACK fontSize:16];
    country.font = cellTitleFont;

    //5、国家子项
    UIView *countryBgView  = [UIView new];
    [bgView addSubview:countryBgView];
    self.countrybgView = countryBgView;
    countryBgView.tag  = 1;

    //6、类型
    UILabel *typeLab = [[UILabel alloc] init];
    self.typeLab = typeLab;
    typeLab.text = @"类型";
    [self addLabel:typeLab textColor:XCOLOR_BLACK fontSize:16];
    typeLab.font = cellTitleFont;

    //7、类型子项
    UIView *typeBgView  = [UIView new];
    [bgView addSubview:typeBgView];
    self.typeBgView = typeBgView;
    typeBgView.tag  = 2;
    
    //8、分隔线
    UILabel *second_line = [[UILabel alloc] init];
    self.second_line = second_line;
    [self addLabel:second_line textColor:baseColor fontSize:15];
    second_line.backgroundColor = XCOLOR_line;
    //9、适合人群
    UILabel *people = [[UILabel alloc] init];
    self.people = people;
    people.text = @"适合人群";
    [self addLabel:people textColor:XCOLOR_BLACK fontSize:16];
    people.font = cellTitleFont;

    //9、适合人群描述
    UILabel *peopleDiscLab = [[UILabel alloc] init];
    self.peopleDiscLab = peopleDiscLab;
    [self addLabel:peopleDiscLab textColor:baseColor fontSize:12];
    peopleDiscLab.numberOfLines = 0;
    //10、分隔线
    UILabel *third_line = [[UILabel alloc] init];
    self.third_line = third_line;
    [self addLabel:third_line textColor:baseColor fontSize:15];
    third_line.backgroundColor = XCOLOR_line;
    
    //11、买赠
    UILabel *present = [[UILabel alloc] init];
    present.text = @"买即赠";
    self.present = present;
    [self addLabel:present textColor:XCOLOR_BLACK fontSize:16];
    present.font = cellTitleFont;

    //12、买赠描述
    UILabel *presentDiscLab = [[UILabel alloc] init];
    self.presentDiscLab = presentDiscLab;
    [self addLabel:presentDiscLab textColor:baseColor fontSize:12];
    presentDiscLab.numberOfLines = 0;
    
}


- (void)addLabel:(UILabel *)sender textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize{
    
    sender.textColor = textColor;
    sender.font = [UIFont systemFontOfSize:fontSize];
    [self.bgView addSubview:sender];
    
}


- (void)setItemFrame:(ServiceItemFrame *)itemFrame{
    
    _itemFrame = itemFrame;
    
    self.name.text = itemFrame.item.name;
    
    self.price.text = [NSString stringWithFormat:@"￥%@",itemFrame.item.price];
    NSMutableAttributedString *attributePrice = [[NSMutableAttributedString alloc] initWithString:self.price.text];
    
    [attributePrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
    self.price.attributedText = attributePrice;
    
    
    self.display_price.text = [NSString stringWithFormat:@"原价￥%@",itemFrame.item.display_price];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.display_price.text];
    [attributeStr addAttribute:NSStrikethroughStyleAttributeName value:
     [NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, self.display_price.text.length)]; // 下划线
    self.display_price.attributedText = attributeStr;
    
    
    self.peopleDiscLab.text = itemFrame.item.peopleDisc;
    self.presentDiscLab.text = itemFrame.item.presentDisc;
    
    
 
    NSArray *country_Options =  itemFrame.item.country_Attibute[@"options"];
    
    [self  itemsWithOptions:country_Options containView:self.countrybgView itemFrames:itemFrame.countryItemFrames];

    NSArray *service_type_Options =  itemFrame.item.serviceType_Attibute[@"options"];
    [self  itemsWithOptions:service_type_Options containView:self.typeBgView itemFrames:itemFrame.serviceItemFrames];
  
    
    self.name.frame = itemFrame.nameFrame;
    self.price.frame = itemFrame.priceFrame;
    self.display_price.frame = itemFrame.display_priceFrame;
    self.first_line.frame = itemFrame.firstlineFrame;
    self.country.frame = itemFrame.countryFrame;
    self.countrybgView.frame = itemFrame.countryBgFrame;
    self.typeLab.frame = itemFrame.serviceTypeFrame;
    self.typeBgView.frame = itemFrame.serviceTypeBgFrame;
    self.second_line.frame = itemFrame.secondFrame;
    self.people.frame = itemFrame.peopleFrame;
    self.peopleDiscLab.frame = itemFrame.personDisc_Frame;
    self.third_line.frame = itemFrame.thirdFrame;
    self.present.frame = itemFrame.presentFrame;
    self.presentDiscLab.frame = itemFrame.presentDisc_Frame;
    self.bgView.frame = itemFrame.header_BgViewFrame;
    self.bottomView.frame = itemFrame.header_bottomView_Frame;
    
}



- (void)itemsWithOptions:(NSArray *)options containView:(UIView *)containView itemFrames:(NSArray *)itemsFrames{

    
    if (containView.subviews.count > 0) {
        
        [containView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    
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
    
        for (NSDictionary *option in self.itemFrame.item.country_Attibute[@"options"]) {
            
            if ([sender.currentTitle isEqualToString:option[@"value"]]) {
                
                service_id  = option[@"_id"];
                
                break;
            }
            
        }
        
    }else{
    
        
        for (NSDictionary *option in self.itemFrame.item.serviceType_Attibute[@"options"]) {
            
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

- (void)dealloc{
    
    KDClassLog(@"dealloc 留学 服务 详情 ServiceItemHeaderView");
}



@end




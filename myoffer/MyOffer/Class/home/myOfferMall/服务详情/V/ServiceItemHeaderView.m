//
//  ServiceItemHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/29.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceItemHeaderView.h"
#import "ServiceItemHeaderCell.h"
#import "ServiceItemCellFrame.h"

@interface ServiceItemHeaderView ()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *price;
@property(nonatomic,strong)UILabel *display_price;
@property(nonatomic,strong)UIView *first_line;
@property(nonatomic,strong)UIView *centerView;
@property(nonatomic,strong)UIView *second_line;
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
    [self addLabel:display_price textColor:XCOLOR_SUBTITLE fontSize:13];
    
    //3、分隔线
     UIView *first_line  = [UIView new];
    first_line.backgroundColor = XCOLOR_line;
    [self.bgView addSubview:first_line];
    self.first_line = first_line;

    //4 attributes 部分信息
    UIView *centerView = [UIView new];
    self.centerView = centerView;
    [bgView addSubview:centerView];
    
    //5、分隔线
    UIView *second_line  = [UIView new];
    second_line.backgroundColor = XCOLOR_line;
    [self.bgView addSubview:second_line];
    self.second_line = second_line;
    
    //9、适合人群
    UILabel *people = [[UILabel alloc] init];
    self.people = people;
    people.text = @"适合人群";
    [self addLabel:people textColor:XCOLOR_BLACK fontSize:16];
    people.font = cellTitleFont;

    //9、适合人群描述
    UILabel *peopleDiscLab = [[UILabel alloc] init];
    self.peopleDiscLab = peopleDiscLab;
    [self addLabel:peopleDiscLab textColor:XCOLOR_SUBTITLE fontSize:14];
    peopleDiscLab.numberOfLines = 0;
    //10、分隔线
    UILabel *third_line = [[UILabel alloc] init];
    self.third_line = third_line;
    [self addLabel:third_line textColor:XCOLOR_SUBTITLE fontSize:15];
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
    [self addLabel:presentDiscLab textColor:XCOLOR_SUBTITLE fontSize:14];
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
    self.price.text = itemFrame.item.price_str;
    self.peopleDiscLab.text = itemFrame.item.peopleDisc;
    self.presentDiscLab.text = itemFrame.item.presentDisc;
    self.display_price.hidden = !itemFrame.item.isZheKou;
    
 
    if (itemFrame.item.isZheKou) {
        
        NSString *display_price =  itemFrame.item.display_price_str;
        NSRange dis_price_Rangne = NSMakeRange(0, display_price.length);
        if (itemFrame.item.reduce_flag) {
          display_price = [NSString stringWithFormat:@"%@  (已减价格)",display_price];
        }
        
        NSMutableAttributedString *attribueStr = [[NSMutableAttributedString alloc] initWithString:display_price];
        [attribueStr addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0)} range:dis_price_Rangne];
        self.display_price.attributedText = attribueStr;
    }
    

    
    self.name.frame = itemFrame.name_Frame;
    self.price.frame = itemFrame.priceFrame;
    self.display_price.frame = itemFrame.display_priceFrame;
    self.first_line.frame = itemFrame.firstlineFrame;
    
    if (self.centerView.subviews.count > 0)  [self.centerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    XWeakSelf
    for (NSInteger index = 0; index < itemFrame.centerViewCell_Frames.count; index++) {
        
        ServiceItemHeaderCell *cell = [[ServiceItemHeaderCell alloc] init];
        
        cell.actionBlcok = ^(NSString *service_id){
        
            [weakSelf actionWithId:service_id];
        };
        
        ServiceItemCellFrame *aFrame =  itemFrame.centerViewCell_Frames[index];
        cell.cellFrame = aFrame;
        cell.frame = aFrame.cell_frame.CGRectValue;
        [self.centerView addSubview:cell];
    }
  
    self.centerView.frame = itemFrame.centerView_Frame;
    self.second_line.frame = itemFrame.second_line_Frame;
    self.people.frame = itemFrame.peopleFrame;
    self.peopleDiscLab.frame = itemFrame.personDisc_Frame;
    self.third_line.frame = itemFrame.thirdFrame;
    self.present.frame = itemFrame.presentFrame;
    self.presentDiscLab.frame = itemFrame.presentDisc_Frame;
    self.bgView.frame = itemFrame.header_BgViewFrame;
    self.bottomView.frame = itemFrame.header_bottomView_Frame;
    
    
    self.frame = itemFrame.headerViewFrame;
    
}


- (void)actionWithId:(NSString *)service_id{
    
    if (self.actionBlcok)  self.actionBlcok(service_id);
    
}


- (void)dealloc{
    
    KDClassLog(@" 留学 服务 详情 + ServiceItemHeaderView + dealloc");
}



@end




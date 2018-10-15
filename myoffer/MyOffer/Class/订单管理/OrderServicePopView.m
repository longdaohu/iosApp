//
//  orderServiceAlertView.m
//  MyOffer
//
//  Created by longdao on 2018/10/10.
//  Copyright © 2018 UVIC. All rights reserved.
//

#import "OrderServicePopView.h"
#import "TTTAttributedLabel.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#define WPERCENT          XSCREEN_WIDTH/375
#define HPERCENT          XSCREEN_HEIGHT/668
#define XCOLOR(r,g,b,alp) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alp]
@interface OrderServicePopView()<TTTAttributedLabelDelegate>
{
    
}

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)TTTAttributedLabel *contentLabel;
@property(nonatomic,strong)TTTAttributedLabel *linkLabel;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)NSString *copStr;

@end

@implementation OrderServicePopView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self makeAlertView];
    }
return self;
}

-(void)makeAlertView{
    //圆角
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.path = path.CGPath;
    self.layer.mask = layer;
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    TTTAttributedLabel *contentLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
    TTTAttributedLabel *linkLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
    UIImageView *iconImage = [[UIImageView alloc]init];
    iconImage.backgroundColor = [UIColor redColor];
    UIButton *closeBtn = [[UIButton alloc]init];

    [self addSubview:titleLabel];
    [self addSubview:contentLabel];
    [self addSubview:linkLabel];
    [self addSubview:closeBtn];
    [self addSubview:iconImage];
    
    self.titleLabel = titleLabel;
    self.contentLabel = contentLabel;
    self.linkLabel = linkLabel;
    self.closeBtn = closeBtn;
    self.iconImage = iconImage;
    
}

-(void)setOrderServiceDict:(NSDictionary *)orderServiceDict
{
    self.orderServiceDict = orderServiceDict;
    
}
-(void)onclick:(UIButton*)btn
{
    if (self.actionBlock) {
        
        self.actionBlock(btn);
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //title
    NSString *title = @"您已获取\n【myOffer雅思单词打卡社群】通道";
    NSMutableAttributedString *attriStr =[[NSMutableAttributedString alloc]initWithString:title];
    [attriStr addAttribute:NSForegroundColorAttributeName value:XCOLOR(51, 51, 51, 1) range:NSMakeRange(0, [title length])];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:15] range:NSMakeRange(0, [title length])];
    CGFloat lineHeight = 35*WPERCENT;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.minimumLineHeight = lineHeight;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    CGFloat baselineOffset = (lineHeight - self.titleLabel.font.lineHeight) / 4;
    attributes[NSBaselineOffsetAttributeName] = @(baselineOffset);
    //[style setLineSpacing:20.0];
    [attriStr addAttributes:attributes range:NSMakeRange(0, [title length])];
    self.titleLabel.attributedText = attriStr;
    self.titleLabel.numberOfLines = 0;
    
    //content
    NSString *content = @"请微信扫描二维码或手动复制添加微信号：xwgj2016\n并备注“雅思打卡”，发送好友请求\n添加成功后，即可入群打卡，开启高效背单词之旅！\n\n如有疑问，请联系 4000-666-522";

    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
    self.contentLabel.delegate = self;
    self.contentLabel.tag = 1;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.contentLabel.textColor = XCOLOR(128, 128, 128, 1);
    [self.contentLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    self.contentLabel.linkAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:NO],(NSString *)kCTUnderlineStyleAttributeName,nil];
    
    [self.contentLabel setText:content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
          NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"xwgj2016" options:NSCaseInsensitiveSearch];
           [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[XCOLOR(5, 203, 249, 1)CGColor] range:boldRange];
        boldRange = [[mutableAttributedString string] rangeOfString:@"4000-666-522" options:NSCaseInsensitiveSearch];
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[XCOLOR(51, 51, 51, 1)CGColor] range:boldRange];
        
        if ([UIScreen mainScreen].bounds.size.width > 320) {
            
            CGFloat lineHeight = 26*WPERCENT;
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.maximumLineHeight = lineHeight;
            paragraphStyle.minimumLineHeight = lineHeight;
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            attributes[NSParagraphStyleAttributeName] = paragraphStyle;
            [mutableAttributedString addAttributes:attributes range:NSMakeRange(0, [content length])];
            
        }else{
            CGFloat lineHeight = 20;
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.maximumLineHeight = lineHeight;
            paragraphStyle.minimumLineHeight = lineHeight;
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            attributes[NSParagraphStyleAttributeName] = paragraphStyle;
            [mutableAttributedString addAttributes:attributes range:NSMakeRange(0, [content length])];
        }
        
           return mutableAttributedString;
    }];
    NSRange selRange=[content rangeOfString:@"xwgj2016"];
    [self.contentLabel addLinkToTransitInformation:@{@"select":@"xwgj2016"} withRange:selRange];
    
    //link
    NSString *link = @"链接：https://m.myoffer.cn/";
    attriStr = [[NSMutableAttributedString alloc]initWithString:link];
    [self.linkLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    linkAttributes = [NSMutableDictionary dictionary];
    [linkAttributes setObject:[NSNumber numberWithInt:kCTUnderlineStyleDouble] forKey:(id)kCTUnderlineStyleAttributeName];
    [linkAttributes setValue:(__bridge id)XCOLOR(5, 203, 249, 1).CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    self.linkLabel.delegate = self;
    self.linkLabel.linkAttributes = linkAttributes;
    self.linkLabel.textColor = XCOLOR(51, 51, 51, 1);
    self.linkLabel.tag = 2;
    [self.linkLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    self.linkLabel.text = link;
    self.linkLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    
    //close
    [self.closeBtn setImage:[UIImage imageNamed:@"APP icon"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
    //适配
    [self layoutView];
    
}
//约束
-(void)layoutView{
    CGFloat margin_x = 20*WPERCENT;
    CGFloat margin_y = 24*HPERCENT;
    CGFloat margin_w = 240*WPERCENT;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(margin_y);
        make.right.equalTo(self.iconImage.mas_left).offset(-3);
        make.bottom.equalTo(self.contentLabel.mas_top).offset(0);
        
    }];
    
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left).offset(0);
        make.right.equalTo(self.titleLabel.mas_right).offset(0);
        make.bottom.equalTo(self.linkLabel.mas_top).offset(-5);
    }];
    
    [self.linkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left).offset(0);
        make.right.equalTo(self.titleLabel.mas_right).offset(0);
    }];
    CGFloat margin_h3 = self.frame.size.width - margin_x*2 - margin_w ;
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.linkLabel.mas_bottom).offset(0);
        make.width.mas_equalTo(margin_h3);
        make.height.mas_equalTo(margin_h3);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_top).offset(0);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
}
#pragma TTTAttributedLabel Delegate

//文字的点击事件
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
     NSLog(@"didSelectLinkWithTransitInformation :%@",components);
    
    NSString *copyStr = components[@"select"];
    self.copStr = copyStr;
    //复制
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.string = copyStr;
    if (pab == nil) {
       // [MBProgressHUD showError:@"复制失败"];
    }else
    {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:HUD];
        HUD.labelText = @"微信号已复制";
        HUD.mode = MBProgressHUDModeText;
        
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
            
        }
           completionBlock:^{
               [HUD removeFromSuperview];
           }];
    
    }
    
    
   
}
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
    //这里可以对点击的url进行操作
    if(label.tag== 2)
    {
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
    }
    else
    {
        
    }
}
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithDate:(NSDate *)date {
    NSLog(@"didSelectLinkWithDate :%@",date);
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents {
    NSLog(@"didSelectLinkWithAddress :%@",addressComponents);
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    NSLog(@"didSelectLinkWithPhoneNumber :%@",phoneNumber);
   
}
-(void)menuCopyBtnPressed:(UIMenuItem *)menuItem

{
    [UIPasteboard generalPasteboard].string = self.copStr;
    
}
//文字的长按事件
- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithURL:(NSURL *)url atPoint:(CGPoint)point {
    NSLog(@"didLongPressLinkWithURL  :%@",url);
}


- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithDate:(NSDate *)date atPoint:(CGPoint)point {
    NSLog(@"didLongPressLinkWithDate  :%@",date);
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithAddress:(NSDictionary *)addressComponents atPoint:(CGPoint)point {
    NSLog(@"didLongPressLinkWithAddress  :%@",addressComponents);
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithPhoneNumber:(NSString *)phoneNumber atPoint:(CGPoint)point {
    NSLog(@"didLongPressLinkWithPhoneNumber  :%@",phoneNumber);
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithTransitInformation:(NSDictionary *)components atPoint:(CGPoint)point {
    NSLog(@"didLongPressLinkWithTransitInformation  :%@",components);
    
}

@end

//
//  ServiceProtocalBottomView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/31.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceProtocalBottomView.h"

@interface ServiceProtocalBottomView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *noAgreeBtn;


@end

@implementation ServiceProtocalBottomView

- (void)awakeFromNib{

    [super awakeFromNib];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    UIColor *colorOne = [UIColor colorWithWhite:1 alpha:0];
    UIColor *colorTwo = [UIColor colorWithWhite:1 alpha:1];
    gradient.colors           = [NSArray arrayWithObjects:
                                 (id)colorOne.CGColor,
                                 (id)colorTwo.CGColor,
                                 nil];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 0.3);
    [self.bgView.layer insertSublayer:gradient atIndex:0];
    gradient.frame = CGRectMake(0, 0, self.bgView.bounds.size.width, 110);
    

    
    self.noAgreeBtn.layer.borderColor = XCOLOR_LIGHTGRAY.CGColor;
    [self.noAgreeBtn setTitleColor:XCOLOR_LIGHTGRAY forState:UIControlStateNormal];
}


- (IBAction)onClick:(UIButton *)sender {
    
    BOOL agree =  [sender.currentTitle isEqualToString:@"同意"] ? true : false;
    
    if (self.actionBlock) {
        
        self.actionBlock(agree);
    }
}


- (void)dealloc{
    
    KDClassLog(@"dealloc 留学 服务协议 详情 ServiceProtocalBottomView");
}

@end


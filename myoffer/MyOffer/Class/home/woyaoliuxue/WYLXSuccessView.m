//
//  XliuxueSuccessView.m
//  myOffer
//
//  Created by xuewuguojie on 16/7/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "WYLXSuccessView.h"

@interface WYLXSuccessView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;



@end


@implementation WYLXSuccessView

+(instancetype)successViewWithBlock:(successBlock)actionBlock
{
    WYLXSuccessView  *SuccessView =  [[NSBundle mainBundle] loadNibNamed:@"WYLXSuccessView" owner:self options:nil].lastObject;
   
    SuccessView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT);
    
    SuccessView.actionBlock = actionBlock;
    
    SuccessView.alpha = 0;
    
    return SuccessView;
}

- (IBAction)popBack:(id)sender {
    
    if (self.actionBlock) self.actionBlock();

}

- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.bgView.layer.shadowOpacity = 0.6;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.shadowColor = XCOLOR_BLACK.CGColor;
}

@end

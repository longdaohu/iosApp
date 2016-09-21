//
//  UniversityNavView.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityNavView.h"

@implementation UniversityNavView

-(void)awakeFromNib{

    
    NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"nav.png"];
    self.bgImageView.image =  [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
    self.clipsToBounds = YES;
    self.bgImageView.alpha = 0;
    
    
    XJHUtilDefineWeakSelfRef
    self.rightView = [[NSBundle mainBundle] loadNibNamed:@"UniversityRightView" owner:self options:nil].lastObject;
    [self.rightView.shareBtn setImage:[UIImage imageNamed:@"Uni_share"] forState:UIControlStateNormal];
     self.rightView.actionBlock = ^(UIButton *sender){
        [weakSelf onclick:sender];
    };
    [self insertSubview:self.rightView  aboveSubview:self.bgImageView];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    self.titleLab.font = [UIFont boldSystemFontOfSize:17];
    
    [super awakeFromNib];
    
    
    self.frame = CGRectMake(0, 0, XScreenWidth, NAV_HEIGHT);
    
 
}

- (IBAction)backClick:(id)sender {
    
    [self onclick:sender];
}

- (void)onclick:(UIButton *)sender{

    if (self.actionBlock) {
        
        self.actionBlock(sender);
    }
}

- (void)scrollViewContentoffset:(CGFloat)offsetY{
    
    self.bgImageView.alpha  =  offsetY / (XPERCENT * 200 - 40 - 20 - 64);
    
    CGFloat rightViewDistance = offsetY - (XPERCENT * 200 - 40 - 20 - 64);
    
    self.rightView.top = rightViewDistance >= 44 ? 20 : (64 - rightViewDistance);

}

- (void)scrollViewContentoffsetTest:(CGFloat)offsetY andHeight:(CGFloat)contentHeight{
  
    
//    NSLog(@"--------------------   %lf   %lf",offsetY,contentHeight);
    
    self.bgImageView.alpha =  offsetY / contentHeight;
    
}



-(void)layoutSubviews{

    [super layoutSubviews];
    
    CGRect rightRect = self.rightView.frame;
    rightRect.origin.y = NAV_HEIGHT;
    rightRect.size.width = 80  +  XMARGIN;
    rightRect.origin.x = XScreenWidth - rightRect.size.width - 2 * XMARGIN;
    self.rightView.frame = rightRect;
}


 


@end

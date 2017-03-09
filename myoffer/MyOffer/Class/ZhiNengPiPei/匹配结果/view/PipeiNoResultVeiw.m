//
//  PipeiNoResultVeiw.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "PipeiNoResultVeiw.h"
#define Content_FontSize  18

@interface PipeiNoResultVeiw ()
@property (weak, nonatomic) IBOutlet UIButton *pipeiBtn;

@end

@implementation PipeiNoResultVeiw

+ (instancetype)viewWithActionBlock:(PipeiNoResultVeiwBlock)actionBlock{

    PipeiNoResultVeiw *noDataView = [[NSBundle mainBundle] loadNibNamed:@"PipeiNoResultVeiw" owner:self options:nil].lastObject;
    
    noDataView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT - XNAV_HEIGHT);
    
    noDataView.actionBlock = actionBlock;
    
    return noDataView;
}



-(void)awakeFromNib{
    
    [super awakeFromNib];
    
     self.pipeiBtn.backgroundColor = XCOLOR_RED;
 
}

- (IBAction)onClick:(UIButton *)sender {
    
    if (self.actionBlock) {
        
        self.actionBlock();
    }
    
}





@end

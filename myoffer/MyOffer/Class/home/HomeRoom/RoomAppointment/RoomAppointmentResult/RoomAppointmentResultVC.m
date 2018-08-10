//
//  RoomAppointmentResultVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/7.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomAppointmentResultVC.h"

@interface RoomAppointmentResultVC ()
@property (weak, nonatomic) IBOutlet UIButton *meiqiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *keepBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic,strong) CAShapeLayer *shaper;

@end

@implementation RoomAppointmentResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title  = @"预约表单";
    
    self.keepBtn.backgroundColor = XCOLOR_RED;
    self.view.backgroundColor = XCOLOR_BG;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(caseMeiqia)];
    self.bgView.layer.cornerRadius = 8;
    self.bgView.layer.masksToBounds = YES;
    
    CAShapeLayer *shaper = [CAShapeLayer layer];
    shaper.shadowColor = XCOLOR_BLACK.CGColor;
    shaper.shadowOffset = CGSizeMake(0, 5);
    shaper.shadowRadius = 5;
    shaper.shadowOpacity = 0.5;
    [self.view.layer insertSublayer:shaper below:self.bgView.layer];
    self.shaper = shaper;
    
    [self.meiqiaBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
    NSDictionary *attribtDic = @{ NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribt_look = [[NSMutableAttributedString alloc] initWithString:self.meiqiaBtn.currentTitle];
    [attribt_look addAttributes:attribtDic range:NSMakeRange(0, self.meiqiaBtn.currentTitle.length)];
    [ self.meiqiaBtn  setAttributedTitle:attribt_look forState:UIControlStateNormal];
    
}

- (void)caseMeiqia{
    [self caseMeiqia:nil];
}

- (IBAction)caseMeiqia:(UIButton *)sender {
}
- (IBAction)caseBack:(UIButton *)sender {
}
- (IBAction)caseKeepLook:(UIButton *)sender {
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bgView.frame cornerRadius:8];
    self.shaper.path = path.CGPath;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

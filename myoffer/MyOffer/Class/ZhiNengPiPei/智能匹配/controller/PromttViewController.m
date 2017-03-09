//
//  PromttViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/9.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "PromttViewController.h"

@interface PromttViewController ()
@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;

@end

@implementation PromttViewController
+ (instancetype)promptViewWithBlock:(promptViewControllerBlock)actionBlock{
    
    PromttViewController  *prompt  = [[PromttViewController alloc] initWithNibName:@"PromttViewController" bundle:nil];
    
    prompt.actionBlock = actionBlock;
    
    return prompt;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.dismissBtn setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
    self.dismissBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(XPERCENT*22)];
    self.dismissBtn.layer.borderColor = XCOLOR_RED.CGColor;
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWithDismiss)];
    [self.view addGestureRecognizer:tap];
    
}

- (IBAction)dismissOnclick:(UIButton *)sender {
    
    if (self.actionBlock) {
        
        self.actionBlock();
    }
}

-(void)tapWithDismiss{
    
    
    [self dismissOnclick:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

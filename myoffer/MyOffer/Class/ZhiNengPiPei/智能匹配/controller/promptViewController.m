//
//  promptViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/3.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "promptViewController.h"

@interface promptViewController ()
@property(nonatomic,strong)UIImageView  *prompView;
@end

@implementation promptViewController

- (instancetype)initWithBlock:(promptViewControllerBlock)actionBlock{

    self = [super init];
    
    if (self) {
        
        self.actionBlock = actionBlock;
        
    }
    return self;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIImageView *prompView =   [[UIImageView alloc] initWithFrame:self.view.bounds];
    prompView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:prompView];
    prompView.image = XImage(@"guid_smart");
    self.prompView = prompView;
    
    
    CGFloat enterY = XScreenHeight  - (70 * XScreenHeight / 568.0);
    CGFloat enterW = 240 * XScreenWidth / 320.0;
    CGFloat enterH = 40 * XScreenWidth/ 320.0;
    CGFloat enterX =  0.5 *(XScreenWidth - enterW);
    UIButton *enterBtn =[[UIButton alloc] initWithFrame:CGRectMake(enterX, enterY, enterW, enterH)];
    [enterBtn setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
    [enterBtn setTitle:GDLocalizedString(@"Evaluate-pipei") forState:UIControlStateNormal];
    enterBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(22 * XScreenWidth / 320.0)];
    [enterBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
    enterBtn.layer.cornerRadius = CORNER_RADIUS;
    enterBtn.layer.masksToBounds = YES;
    enterBtn.layer.borderColor = XCOLOR_RED.CGColor;
    enterBtn.layer.borderWidth = 1;
    
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [self.view addGestureRecognizer:tap];
   
}



-(void)dismissView{

    if (self.actionBlock) {
        
        self.actionBlock();
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  promptViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/3.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "promptViewController.h"

@interface promptViewController ()
@property(nonatomic,strong)UIButton  *tapBtn;
@property(nonatomic,strong)UIImageView  *prompView;
//@property(nonatomic,strong)UIView *bgView;
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
    
    
    CGFloat Ty = XScreenHeight  - (70 * XScreenHeight / 568.0);
    CGFloat Tw = 240 * XScreenWidth / 320.0;
    CGFloat Th = 40 * XScreenWidth/ 320.0;
    CGFloat Tx =  0.5 *(XScreenWidth - Tw);
    self.tapBtn =[[UIButton alloc] initWithFrame:CGRectMake(Tx, Ty, Tw, Th)];
    [self.tapBtn setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
    [self.tapBtn setTitle:GDLocalizedString(@"Evaluate-pipei") forState:UIControlStateNormal];
    self.tapBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(22 * XScreenWidth / 320.0)];
    [self.tapBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tapBtn];
    self.tapBtn.layer.cornerRadius = CORNER_RADIUS;
    self.tapBtn.layer.masksToBounds = YES;
    self.tapBtn.layer.borderColor = XCOLOR_RED.CGColor;
    self.tapBtn.layer.borderWidth = 1;
    
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

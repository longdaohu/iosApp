//
//  ExchangeAVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/22.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "ExchangeAVC.h"
#import "ExtractionBVC.h"

@interface ExchangeAVC ()
@property (weak, nonatomic) IBOutlet UILabel *dollarLab;


@end

@implementation ExchangeAVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换和提取";
    self.dollarLab.text = self.dollor;

}

- (IBAction)next:(id)sender {
    
    ExtractionBVC *vc = [[ExtractionBVC alloc] init];
    PushToViewController(vc);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    KDClassLog(@"兑换和提取A + ExchangeAVC + dealloc");
}





@end

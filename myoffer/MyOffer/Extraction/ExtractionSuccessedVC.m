//
//  ExtractionSuccessedVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/22.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "ExtractionSuccessedVC.h"

@interface ExtractionSuccessedVC ()

@end

@implementation ExtractionSuccessedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
}

- (void)makeUI{
    
    self.title = @"兑换和提取";
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    KDClassLog(@"兑换和提取成功 + ExtractionSuccessedVC + dealloc");
}


@end

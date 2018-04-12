//
//  OrderEnjoyVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/3.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "OrderEnjoyVC.h"

@interface OrderEnjoyVC ()
@property (weak, nonatomic) IBOutlet UITextField *valueTF;
@property (weak, nonatomic) IBOutlet UIScrollView *bgView;
@property (weak, nonatomic) IBOutlet UIScrollView *commitBtn;

@end

@implementation OrderEnjoyVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
 
    [MobClick beginLogPageView:@"page尊享通道"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page尊享通道"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"尊享通道";
    [self.valueTF addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
}

- (IBAction)commitBtn:(UIButton *)sender {
 
    NSLog(@" %ld",self.valueTF.text.length);
    
    if (self.valueTF.text.length == 0) {
        [MBProgressHUD showMessage:@"请输入尊享码"];
        return;
    }
    
    if (self.valueTF.text.length < 9) {
        [MBProgressHUD showMessage:@"请输入9位数尊享码"];
         return;
    }
 
    NSDictionary *parameter = @{@"pId" : self.valueTF.text};
    XWeakSelf
    [self startAPIRequestWithSelector:@"GET svc/marketing/promote/check" parameters:parameter expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateResultWithResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        [weakSelf showError:@"网络请求失败！！！"];
    }];
 
}

- (void)updateResultWithResponse:(id)response{
  
    
    if ([response[@"code"] integerValue]  == 1) {
        [self showError:@"此尊享码不存在"];
        return ;
    }
    
    if ([response[@"code"] integerValue]  == 0) {
        
       NSDictionary *result = response[@"result"];
        
        if (self.price.floatValue < [result[@"rules"] floatValue]) {
            [self showError:@"该尊享码不在活动范围内"];
            return;
        }

        if (self.enjoyBlock) {
            self.enjoyBlock(result);
            [self dismiss];
        }
    }
}

- (void)showError:(NSString *)msg{
    [MBProgressHUD showMessage:msg];
}

- (void)valueChange:(UITextField *)sender{
 
    if (sender.text.length > 9) {
         sender.text = [sender.text substringToIndex:9];
    }
    
}


#pragma mark : UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
    [self.view endEditing:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    KDClassLog(@"尊享通道 +  OrderEnjoyVC + dealloc");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end




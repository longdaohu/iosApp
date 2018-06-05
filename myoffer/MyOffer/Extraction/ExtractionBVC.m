//
//  ExtractionBVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/22.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "ExtractionBVC.h"
#import "ExtractionSuccessedVC.h"

@interface ExtractionBVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *cardTF;
@property (weak, nonatomic) IBOutlet UITextField *bankTF;
@property(nonatomic,strong)NSMutableDictionary *parameters;
@property (weak, nonatomic) IBOutlet UIButton *nextBnt;

@end

@implementation ExtractionBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
}

- (void)makeUI{
    
    self.title = @"兑换和提取";
}
- (NSMutableDictionary *)parameters{
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
    }
    
    return _parameters;
}

- (IBAction)next:(UIButton *)sender {
    
//    [self.view endEditing:YES];
    
    NSString *bankAccount = self.cardTF.text;
    NSString *bankName = self.bankTF.text;
    NSString *bankReceiptName = self.nameTF.text;
    NSString *alert = @"";
    BOOL isAlert = NO;
    if (bankReceiptName.length == 0 && !isAlert) {
        alert = @"请输入持卡人姓名";
        isAlert = YES;
    }
    if (bankReceiptName.length > 16 && !isAlert) {
        alert = @"“持卡人姓名”格式错误，请输入16个字符以内的文本";
        isAlert = YES;
    }
    if (bankAccount.length == 0 && !isAlert) {
        alert = @"请输入储蓄卡卡号";
        isAlert = YES;
    }
    if (bankAccount.length > 19 && !isAlert) {
        alert = @"“银行卡卡号”格式错误，请输入19位以内的数字";
        isAlert = YES;
    }
    if (bankName.length == 0 && !isAlert) {
        alert = @"请输入开户银行名称";
        isAlert = YES;
    }
    if (bankName.length > 32 && !isAlert) {
        alert = @"“开户银行”格式错误，请输入32个字符以内的文本";
        isAlert = YES;
    }
    if (alert.length>0) {
        [MBProgressHUD showMessage:alert];
        return;
    }
 
    sender.enabled = NO;
    [self.parameters setValue:bankAccount forKey:@"bankAccount"];
    [self.parameters setValue:bankName forKey:@"bankName"];
    [self.parameters setValue:bankReceiptName forKey:@"bankReceiptName"];
    WeakSelf;
    [self startAPIRequestWithSelector:kAPISelectorPromotionCashApply  parameters:self.parameters expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateUIWithResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        [MBProgressHUD showMessage:NetRequest_ConnectError];
        sender.enabled = YES;
    }];

}

- (void)updateUIWithResponse:(id)response{
    
    self.nextBnt.enabled = YES;
    //网络请求出错
    if (!ResponseIsOK) {
        [MBProgressHUD showMessage:NetRequest_ConnectError];
        return;
    }
    ExtractionSuccessedVC *vc = [[ExtractionSuccessedVC alloc] init];
    PushToViewController(vc);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    
    KDClassLog(@"兑换和提取B + ExchangeBVC + dealloc");
}


@end

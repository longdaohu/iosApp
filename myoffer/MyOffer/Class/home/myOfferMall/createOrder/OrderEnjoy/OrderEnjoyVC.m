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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.valueTF addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
}


- (IBAction)commitBtn:(UIButton *)sender {
    
    
    if (self.valueTF.text.length < 9) {
        [MBProgressHUD showError:@"请输入9位数尊享码"];
         return;
    }
 
    NSDictionary *parameter = @{@"pId" : self.valueTF.text};
    XWeakSelf
    [self startAPIRequestWithSelector:@"GET svc/marketing/promote/check" parameters:parameter expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        if ([response[@"code"] integerValue]  == 1) {
            [weakSelf show:response[@"msg"]];
            return ;
        }
        
        if ([response[@"code"] integerValue]  == 0) {
 //                  NSLog(@"尊享码 %@",result);
            if (self.enjoyBlock) {
                self.enjoyBlock(response[@"result"]);
                [self dismiss];
            }
        }
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        [weakSelf show:@"网络请求失败！！！"];
    }];
    
 
}

- (void)show:(NSString *)msg{
 
    [MBProgressHUD showError:msg];
  
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//checkPromote
//验证推广id
//
//url: svc/marketing/promote/check
//method: GET
//query: {
//pId: string      //推广Id
//}
//res: {
//code: number,           // 0表示成功，其他表示出错，出错时result中有错误描述
//msg: string,            // 问题原因
//result: {
//    "id": "string",
//    "name": "string",
//    "rules": "number",
//    "promoteId": "string"
//}
//}


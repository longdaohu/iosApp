//
//  OrderDetailViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailHeaderView.h"
#import "OrderDetailFooterView.h"
#import "OrderItem.h"
#import "PayOrderViewController.h"
#import "ServiceMallViewController.h"
#import "OrderViewController.h"
#import "IDMPhotoBrowser.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *rightLab;
@property(nonatomic,strong)UIBarButtonItem *backBtn;

@property(nonatomic,strong)NSMutableArray *contracturlsImages;//计算下载合同图片
@property(nonatomic,strong)NSDictionary *contracturls_result;//合同数据
@property(nonatomic,assign)NSInteger contracturls_pages;//计算下载合同页数
@property(nonatomic,assign)BOOL contracturls_downloaded;//计算下载状态
@property(nonatomic,assign)OrderDetailDownloadStyle  downloadStyle;
@property(nonatomic,copy)NSString *skuID;
@property(nonatomic,strong) OrderDetailFooterView *footer;

@end

@implementation OrderDetailViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page订单详情"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"page订单详情"];
    
}

- (NSMutableArray *)contracturlsImages{
    
    if (!_contracturlsImages) {
        _contracturlsImages =  [NSMutableArray array];
    }
    return _contracturlsImages;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
  
    [self makeDataSourse];
    [self makeUI];
}

-(void)makeDataSourse{
    
    WeakSelf

    NSString *path = [NSString stringWithFormat:kAPISelectorOrderDetail,self.order.order_id];
    
        [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
            [weakSelf updateUIWithResponse:response];
        }];
}

- (void)updateUIWithResponse:(id)response{
    
    [self makeTableViewFooterView:response];
    [self statusWithTag:response[@"status"]];
    [self.tableView reloadData];
    
    NSArray *SKUs = response[@"SKUs"];
    if (SKUs.count > 0) {
        NSDictionary *item  = SKUs[0];
        self.skuID = item[@"_id"];
        [self makeContracturlsData];//合同文件地址
    }

}


#pragma mark : 合同文件地址【loginRequired】api/v1/contracts/contract-urls
- (void)makeContracturlsData{
    
    WeakSelf
    NSString  *path = [NSString stringWithFormat:@"GET %@api/v1/contracts/contract-urls",DOMAINURL_API];
    [self startAPIRequestWithSelector:path
                           parameters:@{@"skuId":self.skuID,@"orderId":self.order.order_id} expectedStatusCodes:nil showHUD:NO showErrorAlert:NO errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                               [weakSelf makeContracturlsDataResponse:response];
                           } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
                           }];
}

- (void)makeContracturlsDataResponse:(id)response{
    
    if (!ResponseIsOK) return;
    self.contracturls_result = response[@"result"];
    self.footer.contracturls_result = self.contracturls_result;
}
/* ------------------------------------- 合同文件地址 ------------------------------------- */

-(void)statusWithTag:(NSString *)status
{
    
     NSString *title;
    
    if ([status isEqualToString:@"ORDER_FINISHED"]) {
        
          title  = @"已付款";
        
    }else   if ([status isEqualToString:@"ORDER_PAY_PENDING"]) {
        
         title = @"待付款";
        
    }else  if ( [status isEqualToString:@"ORDER_CLOSED"]) {
        
        title = @"订单关闭";
        
    }else  if ( [status isEqualToString:@"ORDER_REFUNDED"]) {
        
        title = @"已退款";
        
    }

    self.rightLab.text = title;
}


-(void)makeUI{

    self.title  = @"订单详情";
   
    [self makeTableView];
    
    [self makeTableViewHeaderView];
    
    self.rightLab =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    self.rightLab.textColor =XCOLOR_WHITE;
    self.rightLab.font =[UIFont systemFontOfSize:16];
    self.rightLab.textAlignment = NSTextAlignmentRight;
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem  alloc] initWithCustomView:self.rightLab];
    
    self.backBtn =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(caseBack)];
     self.navigationItem.leftBarButtonItem = self.backBtn;
    
}


-(void)makeTableViewHeaderView{

    OrderDetailHeaderView *header = [[OrderDetailHeaderView alloc] init];
    header.order = self.order;
    header.frame = CGRectMake(0, 0, XSCREEN_WIDTH, header.headHeight);
    self.tableView.tableHeaderView = header;
}



-(void)makeTableViewFooterView:(NSDictionary *)respose{
    
    WeakSelf
    OrderDetailFooterView *footer = [[OrderDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 400)];
    footer.orderDict = respose;
    self.footer = footer;
    self.tableView.tableFooterView = footer;
    footer.actionBlock = ^(UIButton *sender){
        if (10 == sender.tag) {
            PayOrderViewController *pay =[[PayOrderViewController alloc] init];
            pay.order = weakSelf.order;
            [weakSelf.navigationController pushViewController:pay animated:YES];
        }else{
            [weakSelf cancelOrder];
        }
    };
    footer.orderDetailActionBlock = ^(BOOL isDownLoadButtonClick) {
        [weakSelf orderContactCellOnClick:isDownLoadButtonClick];
    };
    
}

-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XNAV_HEIGHT, 0);
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
}


#pragma mark : UITableViewDelegate,UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return HEIGHT_ZERO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}


#pragma mark : 取消订单
-(void)cancelOrder{
    
    WeakSelf
    UIAlertController *alert = [UIAlertController alertWithTitle:@"是否要取消订单" message:nil actionWithCancelTitle:@"取消" actionWithCancelBlock:nil actionWithDoneTitle:@"确定" actionWithDoneHandler:^{
        [weakSelf caseOrderClose];
    }];
    
    [alert alertShow:self];
}

- (void)caseOrderClose{
    WeakSelf
    NSString *path = [NSString stringWithFormat:kAPISelectorOrderClose,self.order.order_id];
    //先删除 已选择专业数组列表  > 再删除分区头
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
       
        if (![response[@"result"] isEqualToString:@"OK"]) return;
        if (weakSelf.actionBlock) {
             weakSelf.actionBlock(YES);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}

//返回
-(void)caseBack{
   
    if (self.navigationController.childViewControllers.count > 3) {
        
        UIViewController *child = self.navigationController.childViewControllers[1];
       
        if ([child isKindOfClass:[ServiceMallViewController class]]) {
            
            ServiceMallViewController *mall =(ServiceMallViewController *)child;
            mall.refresh = YES;
            [self.navigationController popToViewController:mall animated:YES];

        } else if([child isKindOfClass:[OrderViewController class]]){
        
            OrderViewController *orderList =(OrderViewController *)child;
            orderList.refresh = YES;
            [self.navigationController popToViewController:orderList animated:YES];
 
        }else{
        
            [self.navigationController popToRootViewControllerAnimated:YES];
            
         }
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
 
    }
    
}

#pragma mark : 合同cell点击事件处理
- (void)orderContactCellOnClick:(BOOL)isDownLoadButtonClick{
    
    if (!self.contracturls_result) {
        [self makeContracturlsData];
        return;
    }
    
    //点击下载
    if (isDownLoadButtonClick) {
        
        if (self.contracturls_downloaded) return;
        
        self.downloadStyle = OrderDetailDownloadStyleLoading;
        [self ContractCellReload];
        
        NSArray *imgUrls  = self.contracturls_result[@"imgUrls"];
        for (NSInteger index  = 0 ; index < imgUrls.count; index++) {
            
            NSString *path = imgUrls[index];
            __block BOOL downLoadfail = NO;
            WeakSelf;
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:path] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                
                
                if (error) {
                    
                    downLoadfail = YES;
                    
                    if (index != (imgUrls.count - 1)) return;
                    
                    [MBProgressHUD showMessage:@"合同下载失败，请重新下载！"];
                    weakSelf.contracturls_downloaded = NO;
                    weakSelf.contracturls_pages = 0;
                    //下载失败 恢复下载按钮状态
                    self.downloadStyle = OrderDetailDownloadStyleNomal;
                    [self ContractCellReload];
                    
                    return ;
                }
                
                if (finished) {
                    UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
                }
            }];
        }
        
        return;
    }
    
    //点击查看

    [self showPhotoView];
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self.contracturlsImages addObject:image];
    ++self.contracturls_pages;
    NSArray *imgUrls  = self.contracturls_result[@"imgUrls"];
    if (self.contracturls_pages >=  imgUrls.count) {
        self.contracturls_pages = 0;
        self.contracturls_downloaded = YES;
        [MBProgressHUD showMessage:@"合同已保存到相册，请到相册查看！"];
        self.downloadStyle = OrderDetailDownloadStyleLoaded;
        [self ContractCellReload];
        
    }else{
        
        self.contracturls_downloaded = NO;
        if (self.contracturls_pages >=  imgUrls.count) {
            //下载失败 恢复下载按钮状态
            self.downloadStyle = OrderDetailDownloadStyleNomal;
            [self ContractCellReload];
        }
    }
}



//点击图片浏览器
-(void)showPhotoView
{
    NSArray *imgUrls  = self.contracturls_result[@"imgUrls"];
    NSArray *photosWithURL;
    if (self.contracturlsImages.count > 0) {
        photosWithURL =   [IDMPhoto photosWithImages:self.contracturlsImages];
    }else{
        photosWithURL =  [IDMPhoto photosWithURLs:imgUrls];
    }
    NSMutableArray *photos = [NSMutableArray arrayWithArray:photosWithURL];
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    [browser setInitialPageIndex:0];
    browser.displayCounterLabel = YES;
    browser.displayActionButton = NO;
    [self presentViewController:browser animated:YES completion:nil];
    
}

- (void)ContractCellReload{
     self.footer.type = self.downloadStyle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)dealloc{
    //释放图片内存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    KDClassLog(@"订单详情 + OrderDetailViewController + dealloc");
}


@end

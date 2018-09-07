//
//  CreateOrderVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/3.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "CreateOrderVC.h"
#import "CreateOrderOneCell.h"
#import "CreateOrderItemCell.h"
#import "myofferGroupModel.h"
#import "OrderEnjoyVC.h"
#import "OrderActionVC.h"
#import "DiscountItem.h"
#import "serviceProtocolVC.h"
#import "PayOrderViewController.h"
#import "OrderItem.h"
#import "CreateOrderContractCell.h"
#import "CreateOrderUserInformationVC.h"
#import "CreateOrderWebVC.h"
#import "IDMPhotoBrowser.h"
#import "SDImageCache.h"

@interface CreateOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *discountLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;//价格标签
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;//提交按钮
@property(nonatomic,strong)NSArray *discount_items;
@property(nonatomic,strong)NSMutableArray *groups;//分组数据
@property(nonatomic,strong) UIButton *protocolBtn;
@property(nonatomic,strong) UIButton *optionBtn;//页尾标注信息
@property(nonatomic,strong)NSMutableDictionary *parameter;
@property(nonatomic,strong)serviceProtocolVC *protocalVC;//用户但看协议
@property(nonatomic,strong)CreateOrderUserInformationVC *userVC;//用户填写资料页
@property(nonatomic,assign)BOOL contractStatus;//签署状态
@property(nonatomic,assign)BOOL contractEnable;//是否有合同
@property(nonatomic,strong)NSDictionary *accountInformation;//获取账户身份信息
@property(nonatomic,strong)NSDictionary *contracturls_result;//合同文件地址
@property(nonatomic,assign)NSInteger contracturls_pages;//计算下载合同页数
@property(nonatomic,strong)NSMutableArray *contracturlsImages;//计算下载合同图片
@property(nonatomic,assign)BOOL contracturls_downloaded;//计算下载状态
@property(nonatomic,assign)CreateOrderContractDownloadStyle  downloadStyle;
@property(nonatomic,assign)BOOL fromWebViewRefresh;//签合同页面返回刷新

@end

@implementation CreateOrderVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NavigationBarHidden(NO);
    [MobClick beginLogPageView:@"page创建订单"];
    
    [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page创建订单"];
}

- (void)refresh{
    
    //签合同页面返回刷新
    if(self.fromWebViewRefresh){
        [self makeContractStatusData];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    
    
    //签署状态
    [self makeContractStatusData];
    //获取账户身份信息
    [self makeAccountData];
}

- (NSMutableArray *)groups{
    
    if (!_groups) {
        _groups =  [NSMutableArray array];
    }
    return _groups;
}

- (NSMutableDictionary *)parameter{
    if (!_parameter) {
        _parameter =  [NSMutableDictionary dictionary];
    }
    return _parameter;
}
- (NSMutableArray *)contracturlsImages{
    
    if (!_contracturlsImages) {
        _contracturlsImages =  [NSMutableArray array];
    }
    return _contracturlsImages;
}


- (void)makeUI{
    
    self.title  = @"订单确认页";
    [self makeTableView];
    self.priceLab.text = self.itemFrame.item.price_str;
    [self.parameter setValue:self.itemFrame.item.service_id  forKey:KEY_SKUID];
}

- (void)makeTableView
{
    self.tableView.backgroundColor = XCOLOR_BG;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 200;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
 
    CGFloat footer_h = 30;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, footer_h)];
    self.tableView.tableFooterView = footer;
    UIButton *optionBtn = [[UIButton alloc] initWithFrame:CGRectMake( 15, 0, footer_h, footer_h)];
    [optionBtn setImage:[UIImage imageNamed:@"protocol_nomal"] forState:UIControlStateNormal];
    [optionBtn setImage:[UIImage imageNamed:@"protocol_select"] forState:UIControlStateSelected];
    [footer addSubview:optionBtn];
    optionBtn.selected = YES;
    [optionBtn addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.optionBtn = optionBtn;
    
    UIButton *protocolBtn = [[UIButton alloc] init];
    self.protocolBtn = protocolBtn;
    
    [protocolBtn setTitle:@"购买条款与协议，买家须知" forState:UIControlStateNormal];
    protocolBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [protocolBtn.titleLabel setFont:XFONT(14)];
    [footer addSubview:protocolBtn];
    [protocolBtn addTarget:self action:@selector(protocolClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat sub_y = 0;
    CGFloat sub_h = footer_h;
    CGFloat sub_x = CGRectGetMaxX(optionBtn.frame) + 5;
    CGFloat sub_w = footer.mj_w - sub_x;
    protocolBtn.frame = CGRectMake(sub_x, sub_y, sub_w, sub_h);
    [self protocolAttribute:NO];// 下划线
    
}



- (serviceProtocolVC *)protocalVC{
    
    if (!_protocalVC) {
        _protocalVC = [[serviceProtocolVC alloc] init];
        _protocalVC.type = protocolViewTypeHtml;
        _protocalVC.view.frame = CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT);
        [[UIApplication sharedApplication].keyWindow addSubview:_protocalVC.view];
    }
    
    return _protocalVC;
}

- (CreateOrderUserInformationVC *)userVC{
    
    if (!_userVC) {
        
        WeakSelf
        CreateOrderUserInformationVC *vc = [[CreateOrderUserInformationVC alloc] initWithNibName:@"CreateOrderUserInformationVC" bundle:nil];
        _userVC = vc;
        vc.actionBlock = ^{
            [weakSelf makeContactFormData];
        };
        vc.view.frame = CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT);
        vc.view.backgroundColor = XCOLOR(0, 0, 0, 0.5);
        vc.view.alpha = 0;
        [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
    }
    
    return _userVC;
}

- (void)setItemFrame:(ServiceItemFrame *)itemFrame{
    
    _itemFrame = itemFrame;
    
    myofferGroupModel *group = [myofferGroupModel groupWithItems:@[itemFrame.item] header:nil];
    group.type = SectionGroupTypeCreateOrderMassage;
    [self.groups addObject:group];
   
    //reduce_flag为true优惠
    if (itemFrame.item.reduce_flag) {
        
        myofferGroupModel *enjoy = [myofferGroupModel groupWithItems:nil header:@"尊享通道"];
        enjoy.type = SectionGroupTypeCreateOrderEnjoy;
        [self.groups addObject:enjoy];
 
        [self makeCouponsData];
    }
}


#pragma mark :  UITableViewDelegate,UITableViewDataSourc

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    myofferGroupModel *group = self.groups[indexPath.section];
 
    if (group.type == SectionGroupTypeCreateOrderContact) {
        
        WeakSelf
        CreateOrderContractCell *cell = [[CreateOrderContractCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.contactStatus = self.contractStatus;
        cell.type = self.downloadStyle;
        cell.actionBlock = ^(BOOL isDownLoadButtonClick) {
            [weakSelf orderContactCellOnClick:isDownLoadButtonClick];
        };
        return cell;
        
    }else if (group.type == SectionGroupTypeCreateOrderMassage) {
        
        CreateOrderOneCell  *cell =  Bundle(@"CreateOrderOneCell");
        cell.item = group.items[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{
        
        CreateOrderItemCell  *cell = Bundle(@"CreateOrderItemCell");
        cell.item = group;
        return cell;
    }
 
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return HEIGHT_ZERO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    myofferGroupModel *group = self.groups[indexPath.section];

    if (group.type == SectionGroupTypeCreateOrderContact) {
        return  self.contractStatus ? 92 : 75;
    }
    
    return UITableViewAutomaticDimension;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    myofferGroupModel *group  = self.groups[indexPath.section];
    //如果顶部订单信息，不继续执行
    if (SectionGroupTypeCreateOrderMassage  == group.type) {
        return;
    }
    
    
    if (group.type == SectionGroupTypeCreateOrderContact) {
 
        if (self.contractStatus) return;
 
        self.userVC.view.alpha = 0.1;
        self.userVC.item = self.accountInformation;
        [UIView animateWithDuration:ANIMATION_DUATION animations:^{
            self.userVC.view.alpha = 1;
        }];
        
        return;
    }
    
  
    myofferGroupModel *enjoy = nil;
    myofferGroupModel *active = nil;
    for (myofferGroupModel *item in self.groups) {
        if (item.type == SectionGroupTypeCreateOrderEnjoy) {
            enjoy = item;
        }
        if (item.type == SectionGroupTypeCreateOrderActive) {
            active = item;
        }
    }
 
    //点击尊享通道
    if (group.type == SectionGroupTypeCreateOrderEnjoy) {
 
        if (active.sub.length > 0) {
            [self caseAlertWithGroup:group];
        }else{
            [self casePushEnjoy:group];
        }
     }
    
    //点击活动通道
    if (group.type == SectionGroupTypeCreateOrderActive) {
         if (enjoy.sub.length > 0) {
            [self caseAlertWithGroup:group];
        }else{
            [self casePushActive:group];
        }
     }
    
}

//push  尊享通道
- (void)casePushEnjoy:(myofferGroupModel *)group{
    
    WeakSelf
    OrderEnjoyVC *vc = [[OrderEnjoyVC alloc] initWithNibName:@"OrderEnjoyVC" bundle:nil];
    vc.price = self.itemFrame.item.price;
    vc.enjoyBlock = ^(NSDictionary *result) {
         [weakSelf caseEnjoyItemUpdateWithResult:result group:group];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
//push 尊享通道 > 数据更新
- (void)caseEnjoyItemUpdateWithResult:(NSDictionary *)result group:(myofferGroupModel *) group{

    NSString *rules = [NSString stringWithFormat:@"%@",result[@"rules"]];
    NSString *enjoy_price = [self reviseString:rules];
    //显示总金额
    [self discountMessage:enjoy_price];
    group.sub = [NSString stringWithFormat:@"尊享码立减优惠 -￥%@",enjoy_price];
    [self.tableView reloadData];
 
    //提交订单请求参数
    [self.parameter setValue:result[@"promote_id"]  forKey:@"pId"];
    [self.parameter setValue:@""  forKey:@"id"];
 
}

//push  活动通道
- (void)casePushActive:(myofferGroupModel *)group{
 
        WeakSelf
        OrderActionVC *vc =  [[OrderActionVC alloc] initWithNibName:@"OrderActionVC" bundle:nil];
        vc.items = self.discount_items;
        vc.actBlock = ^(DiscountItem *item) {
             [weakSelf caseActionUpdateWithItem:item group:group];
        };
    
        [self.navigationController pushViewController:vc animated:YES];
}

//push 活动通道 > 更新数据
- (void)caseActionUpdateWithItem:(DiscountItem *)item  group:(myofferGroupModel *)group{
    
     NSString *sub = item ? [NSString stringWithFormat:@"%@ -￥%@",item.name,item.rules] : @"";
     group.sub = sub;
    [self.tableView reloadData];
    
    //设置被选项
    for (DiscountItem *it  in self.discount_items) {
        it.selected = NO;
        if ([item.cId isEqualToString: it.cId]) {
            it.selected = YES;
        }
    }
    
    //更新总金额
    [self discountMessage:item.rules];
 
   //提交订单请求参数
    [self.parameter setValue:@""  forKey:@"pId"];
    [self.parameter setValue:item.item_id  forKey:@"id"];
}


//显示 Alert
- (void)caseAlertWithGroup:(myofferGroupModel *)group{
    
    WeakSelf
    NSString *message = (group.type == SectionGroupTypeCreateOrderActive) ? @"选择使用活动通道将无法同时使用尊享码" :  @"选择使用尊享通道将无法同时使用优惠券" ;
    UIAlertController *alert = [UIAlertController alertWithTitle:nil  message:message actionWithCancelTitle:@"取消" actionWithCancelBlock:nil actionWithDoneTitle:@"依然进入" actionWithDoneHandler:^{
       
        [weakSelf clearGroupSubstring];
        [weakSelf initBottom];
        if (group.type == SectionGroupTypeCreateOrderActive ) {
            //活动通道
            [weakSelf casePushActive:group];
        }else{
            //尊享通道
            [weakSelf clearActive];
            [weakSelf casePushEnjoy:group];
        }
        
        [weakSelf tableReload];
        
    }];
    [alert  alertShow:self];
    
}

 //更新总金额
- (void)discountMessage:(NSString *)value{
    
    self.discountLab.hidden = !value;
    self.discountLab.text = [NSString stringWithFormat:@"(已优惠￥%@) ",value];
    
    CGFloat nomal_price =  1000 * self.itemFrame.item.price.floatValue;
    CGFloat discount_price = 1000 * value.floatValue;
    NSInteger result_price = (NSInteger)nomal_price - (NSInteger)discount_price;
    result_price = result_price < 0 ? 0 : result_price;
    
    NSString *price = [self fomatterWithPrice:[NSString stringWithFormat:@"%.2f",(result_price * 0.001)]];
    self.priceLab.text = price;//[NSString stringWithFormat:@"￥%.2f",(result_price * 0.001)];
}

#pragma mark : 查看协议
- (void)protocolClick:(UIButton *)sender{
    
    if (!self.protocalVC.itemFrame) {
        self.protocalVC.itemFrame = self.itemFrame;
    }
    
    [self.protocalVC pageWithHiden:NO];
}

#pragma mark : 选择按钮
- (void)optionBtnClick:(UIButton *)sender{
    
    sender.selected  = !sender.selected;
 
     if (sender.selected) {
         [self protocolAttribute:NO];
     }
 
}
#pragma mark : 设置协议字符串颜色
- (void)protocolAttribute:(BOOL)colorful{
    
    
    UIColor *clr  = colorful ? XCOLOR_RED : XCOLOR(188, 188, 188, 1);
    NSDictionary *attribtDic = @{
                                 NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                 NSForegroundColorAttributeName: clr
                                 };
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.protocolBtn.currentTitle attributes:attribtDic];
    [self.protocolBtn setAttributedTitle:attribtStr  forState:UIControlStateNormal];
    [self.protocolBtn  setAttributedTitle: [[NSAttributedString alloc] initWithString:@"(注：需签署合同后才可购买)" attributes:@{NSForegroundColorAttributeName: XCOLOR(188, 188, 188, 1)}] forState:UIControlStateDisabled];
}

#pragma mark : 提交订单
- (IBAction)caseCommit:(UIButton *)sender {
    
    if (self.contractEnable) {
         if (!self.contractStatus)  return;
    }else{
        
        if (!self.optionBtn.selected) {
            [self protocolAttribute:YES];
            return;
        }
    }
 
    [self orderCreate];
}

//数据转换
- (NSString *)fomatterWithPrice:(NSString *)price{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSNumber *number = [NSNumber numberWithDouble:price.doubleValue];
    NSString *numberString = [numberFormatter stringFromNumber: number];
    
    return  numberString;
}

- (NSString *)reviseString:(NSString *)str{
    
    //直接传入精度丢失有问题的Double类型
    double conversionValue = [str doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

/*
     NSDictionary *parameter  = @{ KEY_SKUID: self.item.price};
     pId:@"",//推广码Id
     cId:@"",//优惠券码Id   优惠券id和推广码Id只可选传
 */
#pragma mark :  下单
- (void)orderCreate{
     WeakSelf
    [self startAPIRequestWithSelector:@"POST svc/emall/order/create" parameters:self.parameter showHUD:YES errorAlertDismissAction:nil success:^(NSInteger statusCode, id response) {
        [weakSelf orderCreateSuccessWithResponse:response];
    }];
    
}
#pragma mark :  下单成功
- (void)orderCreateSuccessWithResponse:(id)response{
    
    NSNumber *code = response[@"code"];
    // 0表示成功，其他表示出错，出错时result中有错误描述
    if(code.integerValue == 0){
 
        NSDictionary *result = response[@"result"];
        //创建订单
        OrderItem *order = [[OrderItem alloc] init];
        order.SKU = result[@"name"];
        NSString *amount =  [NSString stringWithFormat:@"%@",result[@"amount"] ];
        order.total_fee = [amount toDecimalStyleString];
        order.order_id = result[@"orderId"];
        PayOrderViewController *pay = [[PayOrderViewController alloc] init];
        pay.order = order;
        [self.navigationController pushViewController:pay animated:YES];
        
        [self updateOrderContactCell];
    
    }else if(code.integerValue == 2){
        [self showErrorAlert];
        return;
    }else{
        
        NSString *msg = response[@"msg"];
        [MBProgressHUD showMessage:msg];
        
        return;
    }
 
    //1、清空数据
    [self clearGroupSubstring];
    [self clearActive];
    [self tableReload];
 
    //4、请求参数也要更新 再次请求数据，刷新优惠券数据
    for (NSString *key in self.parameter.allKeys) {
         NSString *value = self.parameter[key];
        if ([key isEqualToString:@"id"]) {
            if (value.length > 0) {
                [self makeCouponsData];
                [self.parameter setValue:@"" forKey:key];
             }
         }
        
        if ([key isEqualToString:@"pId"]) {
             [self.parameter setValue:@"" forKey:key];
        }
        
    }
    
    //3 还原已添加优惠信息
    [self initBottom];
 
}

//清空分组下标数据
- (void)clearGroupSubstring{
    for (myofferGroupModel *group in self.groups) {
        group.sub = @"";
    }
}
// 清除优惠已选项
- (void)clearActive{
    for (DiscountItem *it  in self.discount_items) {
        it.selected = NO;
    }
}
//还原已添加优惠信息
- (void)initBottom{
    self.discountLab.text = @"";
    self.priceLab.text = self.itemFrame.item.price_str;
    
    //还原的时候顺便清空参数
    [self clearOtherParameter];
}
//表格刷新
- (void)tableReload{
    
    [self.tableView reloadData];
}
//清空非 skuid 参数
- (void)clearOtherParameter{
    
    for (NSString *key in self.parameter.allKeys) {
        if (![key isEqualToString:KEY_SKUID]) {
            [self.parameter setValue:@"" forKey:key];
         }
    }
}


//提交订单后 还原合同状态
- (void)updateOrderContactCell{
  
    if (!self.contractEnable) return;
 
    self.contractStatus = NO;
//    self.contractEnable = YES;
    self.contracturls_result = nil;
    [self.contracturlsImages removeAllObjects];
    self.contracturls_pages = 0;
    self.contracturls_downloaded = NO;
    self.downloadStyle = CreateOrderContractDownloadStyleNomal;
    self.commitBtn.backgroundColor = XCOLOR(180, 180, 180, 1);
 
    [self ContractCellReload];
    
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
        
        self.downloadStyle = CreateOrderContractDownloadStyleLoading;
        [self ContractCellReload];
        
        NSArray *imgUrls  = self.contracturls_result[@"imgUrls"];
        for (NSInteger index  = 0 ; index < imgUrls.count; index++) {
            
           NSString *path = imgUrls[index];
           __block BOOL downLoadfail = NO;
            WeakSelf;
            [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:path] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                
                if (error) {
                    
                    downLoadfail = YES;
                    if (index != (imgUrls.count - 1)) return;

                    [MBProgressHUD showMessage:@"合同下载失败，请重新下载！"];
                    weakSelf.contracturls_downloaded = NO;
                    weakSelf.contracturls_pages = 0;
                      //下载失败 恢复下载按钮状态
                    self.downloadStyle = CreateOrderContractDownloadStyleNomal;
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
    if (self.contracturls_pages >=  imgUrls.count && !error) {
        self.contracturls_pages = 0;
        self.contracturls_downloaded = YES;
        [MBProgressHUD showMessage:@"合同已保存到相册，请到相册查看！"];
        self.downloadStyle = CreateOrderContractDownloadStyleLoaded;
        [self ContractCellReload];

    }else{
        
        self.contracturls_downloaded = NO;
        if (self.contracturls_pages >=  imgUrls.count) {
            //下载失败 恢复下载按钮状态
            self.downloadStyle = CreateOrderContractDownloadStyleNomal;
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

    for (NSInteger index = 0; index < self.groups.count; index++) {
        
        myofferGroupModel *group = self.groups[index];
        if (group.type == SectionGroupTypeCreateOrderContact) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:index]] withRowAnimation:UITableViewRowAnimationFade];
            return;
        }
    }
}


- (void)showErrorAlert{

    WeakSelf;
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:@"该优惠券已失效，是否继续购买" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"  style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
       
        [weakSelf clearGroupSubstring];
        [weakSelf initBottom];
        [weakSelf clearActive];
        [weakSelf tableReload];
        [weakSelf clearOtherParameter];
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"原价购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [weakSelf clearGroupSubstring];
        [weakSelf initBottom];
        [weakSelf clearActive];
        [weakSelf tableReload];
        [weakSelf clearOtherParameter];
        [weakSelf orderCreate];
        
    }];
    [alertCtrl addAction:cancelAction];
    [alertCtrl addAction:okAction];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

#pragma mark : 网络请求

/*-----------获取用户优惠券--------------------------------------------------*/
- (void)makeCouponsData{
    NSString *path  = [NSString stringWithFormat:@"GET %@svc/marketing/coupons/get",DOMAINURL];
    WeakSelf
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateWithResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
    }];
}
//活动通道
- (void)updateWithResponse:(id)response{
    /*
     code == 0 网络请求成功
     code > 0  网络请求不成功 不继续执行
     */
    if ([response[@"code"] integerValue] != 0) return;
    
    NSArray *result  = response[@"result"];
    //数据为 0  不继续执行
    if (result.count == 0) return;
    
    CGFloat price = self.itemFrame.item.price.floatValue;
    NSMutableArray *able_arr = [NSMutableArray array];
    NSMutableArray *disable_arr = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *it  = (NSDictionary *)obj;
        if (obj&& (it.allKeys.count > 0)) {
            DiscountItem *item = [DiscountItem mj_objectWithKeyValues:it];
            //1  当优惠券价格>商品价格=此优惠券无效（同时，变为不可使用状态，置灰显示）
            if (item.rules.floatValue > price) {
                item.state = @"2";
            }
            //2  数据分组
            item.disabled ? [disable_arr addObject:item] :  [able_arr addObject:item];
        }
        
    }];
    
    self.discount_items = [able_arr arrayByAddingObjectsFromArray:disable_arr];
    
    //由于是多次刷新，所以要先排除活动通道
    for (NSInteger index = 0; index < self.groups.count; index++) {
        myofferGroupModel *group = self.groups[index];
        if (group.type == SectionGroupTypeCreateOrderActive) {
            [self.groups removeObject:group];
        }
    }
    
    if (result.count > 0) {
        myofferGroupModel *act = [myofferGroupModel groupWithItems:nil header:@"活动通道"];
        act.type = SectionGroupTypeCreateOrderActive;
        [self.groups insertObject:act atIndex:1];
    }
    
    [self.tableView reloadData];
}

#pragma mark :  签署状态【loginRequired】
- (void)makeContractStatusData{
    WeakSelf
    NSString  *path = [NSString stringWithFormat:@"GET %@api/v1/contracts/sign-status",DOMAINURL_API];
    [self startAPIRequestWithSelector:path
                           parameters:@{KEY_SKUID:self.itemFrame.item.service_id} expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                               [weakSelf makeContractStatusWithResponse:response];
                           } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
                           }];
}
- (void)makeContractStatusWithResponse:(id)response{
    
    if (!ResponseIsOK)return;
    NSDictionary *result  = response[@"result"];
    NSNumber *signStatus = result[@"signStatus"];
    NSNumber *contractEnable = result[@"contractEnable"];
    self.contractStatus = [signStatus boolValue];
    self.contractEnable = [contractEnable boolValue];
    
    if ([contractEnable boolValue]) {
        
        self.commitBtn.backgroundColor = self.contractStatus ? XCOLOR_RED : XCOLOR(180, 180, 180, 1);
        
        BOOL haveOrderContact  = NO;
        for ( myofferGroupModel *group  in self.groups) {
            if (group.type == SectionGroupTypeCreateOrderContact) {
                haveOrderContact = YES;
                break;
            }
        }
        
        if (!haveOrderContact) {
            myofferGroupModel *group = [myofferGroupModel groupWithItems:@[@"合同信息"] header:nil];
            group.type = SectionGroupTypeCreateOrderContact;
            [self.groups addObject:group];
        }
        
        [self.tableView reloadData];
        
        [self makeContracturlsData];
        
        self.protocolBtn.enabled = NO;
        self.protocolBtn.mj_x = self.optionBtn.mj_x;
        self.optionBtn.hidden = YES;
    }
    
}
/* ------------------------------------- 签署状态【loginRequired】 -------------------------------------  */


#pragma mark :  获取账户身份信息
- (void)makeAccountData{
    
    if(!LOGIN)return;
    NSString  *path = [NSString stringWithFormat:@"GET %@api/v1/accounts/id-card",DOMAINURL_API];
    WeakSelf
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                               [weakSelf makeAccountWithResponse:response];
                           } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
//                               NSLog(@"============获取账户身份信息===失败=====  %@",error);
                           }];
    
}
- (void)makeAccountWithResponse:(id)response{
    
    if (!ResponseIsOK) return;
    self.accountInformation = response[@"result"];
    
}

/* ------------------------------------- 签署状态【loginRequired】 ------------------------------------- */

#pragma mark : 获取合同表单数据【loginRequired】
- (void)makeContactFormData{
    
    NSString *redirect = [@"http://www.myoffer.cn/aboutus" toUTF8WithString];
    WeakSelf
    NSString  *path = [NSString stringWithFormat:@"GET %@api/v1/contracts/sign-view-form-data",DOMAINURL_API];
    [self startAPIRequestWithSelector:path
                           parameters:@{KEY_SKUID:self.itemFrame.item.service_id,@"redirect" : redirect} expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                               [weakSelf makeContactFormResponse:response];
                           } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
                           }];
    
}

- (void)makeContactFormResponse:(id)response{
    
    if (!ResponseIsOK) return;
    
    self.fromWebViewRefresh = YES;
    WeakSelf;
    NSDictionary *result  = response[@"result"];
    CreateOrderWebVC *vc = [[CreateOrderWebVC alloc] init];
    vc.path = @"https://sign.zqsign.com/mobileSignView";
    vc.item = result;
    PushToViewController(vc);
    vc.webSuccesedCallBack = ^{
        
        weakSelf.contractStatus = YES;
        weakSelf.commitBtn.backgroundColor = XCOLOR_RED;
        [weakSelf.tableView reloadData];
        [weakSelf makeContracturlsData];
        
    };
    
}
/* ------------------------------------- 获取合同表单数据  ------------------------------------- */


#pragma mark : 合同文件地址【loginRequired】api/v1/contracts/contract-urls
- (void)makeContracturlsData{
    
    self.fromWebViewRefresh = NO;
    NSString  *path = [NSString stringWithFormat:@"GET %@api/v1/contracts/contract-urls",DOMAINURL_API];
    
    WeakSelf
    [self startAPIRequestWithSelector:path
                           parameters:@{KEY_SKUID:self.itemFrame.item.service_id} expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                               [weakSelf makeContracturlsDataResponse:response];
                           } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
                           }];
}
- (void)makeContracturlsDataResponse:(id)response{
    
    if (!ResponseIsOK) return;
    self.contracturls_result = response[@"result"];
}
/* ------------------------------------- 合同文件地址 ------------------------------------- */



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    //释放图片内存
     [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
     KDClassLog(@"创建订单页面/订单确认页 + CreateOrderVC + dealloc");
}

@end

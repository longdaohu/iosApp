//
//  CountrySelectionViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/10.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "CountrySelectionViewController.h"
@interface CountrySelectionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *countryTextFx;
@property(nonatomic,strong)NSArray *countryList;
@property(nonatomic,strong)NSArray *resultList;
@property(nonatomic,strong)UITableView *countryTableView;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *UpdateBtn;
@property (weak, nonatomic) IBOutlet UILabel *countyLabel;


@end

@implementation CountrySelectionViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.countryTextFx becomeFirstResponder];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.countryTextFx.placeholder = GDLocalizedString(@"ExpectedCountry-003");
    self.countyLabel.text  = GDLocalizedString(@"ExpectedCountry-002");
    [self.UpdateBtn setTitle:GDLocalizedString(@"Evaluate-0017") forState:UIControlStateNormal];
    
    
    self.title = GDLocalizedString(@"ApplicationProfile-003");//@"国家地区";
    [self.countryTextFx addTarget:self action:@selector(ValueChangeTextField:) forControlEvents:UIControlEventEditingChanged];
    [self createSearchSource];
    [self makeViewUI];
    
    
    self.countryTextFx.text = [self.userInfo valueForKey:@"des_country"];
    
    self.UpdateBtn.backgroundColor = [UIColor colorWithRed:229.0/255 green:12.0/255 blue:105.0/255 alpha:1];
    
}

-(void)ValueChangeTextField:(UITextField *)sender
{
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", sender.text];
    self.resultList = [self.countryList filteredArrayUsingPredicate:pred];
    
    
    if ( self.resultList.count == 0 ) {
        
        self.countryTableView.hidden = YES;
    }else
    {
        self.countryTableView.hidden = NO;
        [self.countryTableView reloadData];
        
    }
    
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"country"];
    if (!cell) {
        cell =[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"country"];
    }
    
    cell.textLabel.text = self.resultList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    self.countryTextFx.text = self.resultList[indexPath.row];
    self.countryTableView.hidden = YES;
}






-(void)makeViewUI
{
    
    self.countryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+88, APPSIZE.width, APPSIZE.height- 64+88)];
    self.countryTableView.dataSource = self;
    self.countryTableView.delegate = self;
    [self.view addSubview:self.countryTableView];
    self.countryTableView.hidden = YES;
    
}


-(void)createSearchSource{
    NSString *countryString = @"['澳大利亚', '加拿大', '中国', '香港特别行政区，中国', '新加坡', '英国', '美国', '台湾', '阿富汗', '奥兰群岛', '阿尔巴尼亚', '阿尔及利亚', '美属萨摩亚群岛', '安道尔', '安哥拉', '安圭拉', '南极洲', '安提瓜和巴布达', '阿根廷', '亚美尼亚', '阿鲁巴', '澳大利亚', '奥地利', '阿塞拜疆', '巴哈马', '巴林', '孟加拉国', '巴巴多斯', '白俄罗斯', '比利时', '伯利兹', '贝宁', '百慕达群岛', '不丹', '玻利维亚', '波斯尼亚和黑塞哥维那', '博茨瓦那', '布维岛', '巴西', '英属印度洋领地', '英属维京群岛', '文莱', '保加利亚', '布基纳法索', '布隆迪', '柬埔寨', '喀麦隆', '加拿大', '佛得角', '荷兰加勒比区', '开曼群岛', '中非共和国', '乍得', '智利', '中国', '圣诞岛', '科科斯（基林）群岛', '哥伦比亚', '科摩罗', '刚果(布拉柴维尔)', '刚果(金沙萨)', '库克群岛', '哥斯达黎加', '克罗地亚', '古巴', '库拉索', '塞浦路斯', '捷克共和国', '丹麦', '吉布提', '多米尼加', '多米尼加共和国', '厄瓜多尔', '埃及', '萨尔瓦多', '赤道几内亚', '厄立特里亚', '爱沙尼亚', '埃塞俄比亚', '福克兰群岛', '法罗群岛', '斐济', '芬兰', '法国', '法属圭亚那', '法属波利尼西亚', '法属南部领土', '加蓬', '冈比亚', '格鲁吉亚', '德国', '加纳', '直布罗陀', '希腊', '格陵兰岛', '格林纳达', '瓜德罗普岛', '关岛', '危地马拉', '根西岛', '几内亚', '几内亚比绍', '圭亚那', '海地', '赫德岛和麦克唐纳群岛', '洪都拉斯', '香港特别行政区，中国', '匈牙利', '冰岛', '印度', '印度尼西亚', '伊朗', '伊拉克', '爱尔兰', '马恩岛', '以色列', '意大利', '象牙海岸', '牙买加', '日本', '泽西岛', '约旦', '哈萨克斯坦', '肯尼亚', '基里巴斯', '科威特', '吉尔吉斯斯坦', '老挝', '拉脱维亚', '黎巴嫩', '莱索托', '利比里亚', '利比亚', '列支敦士登', '立陶宛', '卢森堡', '澳门特别行政区，中国', '马其顿', '马达加斯加', '马拉维', '马来西亚', '马尔代夫', '马里', '马耳他', '马绍尔群岛', '马提尼克岛', '毛里塔尼亚', '毛里求斯', '马约特岛', '墨西哥', '密克罗尼西亚', '摩尔多瓦', '摩纳哥', '蒙古', '黑山', '蒙特塞拉特岛', '摩洛哥', '莫桑比克', '缅甸', '纳米比亚', '瑙鲁', '尼泊尔', '荷兰', '荷属安的列斯岛', '新喀里多尼亚', '新西兰', '尼加拉瓜', '尼日尔', '尼日利亚', '纽埃', '诺福克岛', '北马里亚纳群岛', '朝鲜', '挪威', '阿曼', '巴基斯坦', '帕劳群岛', '巴勒斯坦', '巴拿马', '巴布亚新几内亚', '巴拉圭', '秘鲁', '菲律宾', '皮特克恩岛', '波兰', '葡萄牙', '波多黎各', '卡塔尔', '留尼旺岛', '罗马尼亚', '俄罗斯', '卢旺达', '圣巴托洛缪岛', '圣海伦娜', '圣基茨和尼维斯', '圣卢西亚', '圣马丁(法属)', '圣皮埃尔和密克隆岛', '圣文森特和格林纳丁斯', '萨摩亚', '圣马力诺', '圣多美和普林西比', '沙特阿拉伯', '塞内加尔', '塞尔维亚', '塞舌尔群岛', '塞拉利昂', '新加坡', '圣马丁岛', '斯洛伐克', '斯罗文尼亚', '所罗门群岛', '索马里', '南非', '南乔治亚岛和南桑威奇群岛', '韩国', '南苏丹', '西班牙', '斯里兰卡', '苏丹', '苏里南河', '斯瓦尔巴岛和扬马延岛', '史瓦济兰', '瑞典', '瑞士', '叙利亚', '台湾', '塔吉克斯坦', '坦桑尼亚', '泰国', '东帝汶', '多哥', '托克劳群岛', '汤加', '特立尼达和多巴哥', '突尼斯', '土耳其', '土库曼尼斯坦', '特克斯和凯科斯群岛', '图瓦鲁', '美属维京群岛', '乌干达', '乌克兰', '阿拉伯联合酋长国', '英国', '美国', '美国本土外小岛屿', '乌拉圭', '乌兹别克斯坦', '南太平洋的岛国', '梵谛冈', '委内瑞拉', '越南', '瓦利斯和富图纳', '西撒哈拉', '也门', '赞比亚', '津巴布韦']";
    
    
    NSString *headcountryString = [countryString stringByReplacingOccurrencesOfString:@"['" withString:@""];
    NSString *middleCountryString = [headcountryString stringByReplacingOccurrencesOfString:@"']" withString:@""];
    
    self.countryList = [middleCountryString componentsSeparatedByString:@"', '"];
    
}

- (IBAction)updateButtonPressed:(UIButton *)sender {
 
    if (self.countryTextFx.text.length == 0) {
        // @"国家名称不能为空"
        [KDAlertView showMessage: GDLocalizedString(@"ExpectedCountry-001") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];
        return;
    }
    
 
     [self startAPIRequestWithSelector: @"POST api/account/applicationdata" parameters:@{@"applicationData":@{@"des_country":self.countryTextFx.text}} success:^(NSInteger statusCode, id response) {
        
         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
         [hud applySuccessStyle];
         [hud hideAnimated:YES afterDelay:1];
         [hud setHiddenBlock:^(KDProgressHUD *hud) {
             [self.navigationController popViewControllerAnimated:YES];
         }];
        
    }];
    
 
    
}

@end


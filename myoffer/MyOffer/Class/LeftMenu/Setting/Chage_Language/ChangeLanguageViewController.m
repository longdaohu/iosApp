//
//  ChangeLanguageViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/8.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "ChangeLanguageViewController.h"
#import "DoneButton.h"


@interface ChangeLanguageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *languageTableView;
@property(nonatomic,strong)NSArray         *cellItems;
@property(nonatomic,strong)UIView          *footView;
@property(nonatomic,strong)UITableViewCell *lastCell;
@property(nonatomic,assign)NSInteger        selectRow;


@end

@implementation ChangeLanguageViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page切换语言"];
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page切换语言"];
    
}


- (void)viewDidLoad {
   
    [super viewDidLoad];

    self.cellItems = @[@"简体中文",@"English"];

    [self makeUI];

}

-(void)makeUI
{
    self.title = GDLocalizedString(@"LanguageVC-001");//@"语言设置";
    self.languageTableView.backgroundColor = XCOLOR_BG;
    
   
    self.footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, 80)];

    KDEasyTouchButton *saveBtn =[[KDEasyTouchButton alloc] initWithFrame:CGRectMake( 0.5 *(XScreenWidth - 270), 20, 270, 40)];
    saveBtn.layer.cornerRadius = 5;
    saveBtn.layer.masksToBounds = YES;
    saveBtn.backgroundColor =XCOLOR_RED;//[UIColor colorWithRed:234.0/255 green:51.0/255 blue:125.0/255 alpha:1];
    [saveBtn addTarget:self action:@selector(changeAPPLanguage:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:GDLocalizedString(@"Evaluate-0017")  forState:UIControlStateNormal];
    [self.footView addSubview:saveBtn];
 

    self.languageTableView.tableFooterView = self.footView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"setCell"];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"setCell"];
        
        cell.accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        
        [(UIImageView *)cell.accessoryView setContentMode:UIViewContentModeCenter];
        
    }
    
    cell.textLabel.text = self.cellItems[indexPath.row];
    
    
    NSString *lan = [InternationalControl userLanguage];
    
    if( [lan containsString:@"en"] && indexPath.row == 1)
    {
        
        [(UIImageView *)cell.accessoryView setImage:[UIImage imageNamed:@"check-icons-yes"]];
        
        self.lastCell = cell;
        
    } else  if([lan containsString:@"zh"]  && indexPath.row == 0)
    {
        
        [(UIImageView *)cell.accessoryView setImage:[UIImage imageNamed:@"check-icons-yes"]];
        
        self.lastCell = cell;
        
    }
    else {
        [(UIImageView *)cell.accessoryView setImage:[UIImage imageNamed:@""]];

    }
    
    
    return cell;
}



//语言设置页面

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
         UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
         [(UIImageView *)self.lastCell.accessoryView setImage:[UIImage imageNamed:@""]];
         self.lastCell = cell;
         [(UIImageView *)self.lastCell.accessoryView setImage:[UIImage imageNamed:@"check-icons-yes"]];
         self.selectRow = indexPath.row + 10;
    
    if (indexPath.row ==0) {
        //@"提示"   @"您是否需要切换成中文环境？请点击保存按钮,重新启动myOffer!"
        UIAlertView *aler =[[UIAlertView alloc] initWithTitle:GDLocalizedString(@"LanguageVC-002")  message:GDLocalizedString(@"LanguageVC-005") delegate:self cancelButtonTitle:GDLocalizedString(@"Evaluate-0016") otherButtonTitles: nil];
        [aler show];
    }
    else
    {
        UIAlertView *aler =[[UIAlertView alloc] initWithTitle:GDLocalizedString(@"LanguageVC-002") message:GDLocalizedString(@"LanguageVC-004") delegate:self cancelButtonTitle:GDLocalizedString(@"Evaluate-0016") otherButtonTitles: nil];
        [aler show];
    }
    
}

-(void)changeAPPLanguage:(UIButton *)saveBtn
{

    
    if (self.selectRow == 10){
        
        [InternationalControl setUserlanguage:@"zh-Hans"];
        
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        UIWindow *window = app.window;
        
        [UIView animateWithDuration:1.0f animations:^{
            window.alpha = 0;
            window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
        } completion:^(BOOL finished) {
            exit(0);
        }];
        
     }
      else if (self.selectRow == 11)
     {
         [InternationalControl setUserlanguage:@"en"];
         AppDelegate *app = [UIApplication sharedApplication].delegate;
         UIWindow *window = app.window;
         
         [UIView animateWithDuration:1.0f animations:^{
             window.alpha = 0;
             window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
         } completion:^(BOOL finished) {
             exit(0);
         }];
        
      }
      else
     {
          AlerMessage(GDLocalizedString(@"LanguageVC-003"));
        return;
      }
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

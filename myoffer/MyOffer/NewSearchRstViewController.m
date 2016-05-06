//
//  NewSearchRstViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//
#define kCellIdentifier NSStringFromClass([SearchResultCell class])
#import "NewSearchRstViewController.h"
#import "SearchResultCell.h"
#import "searchSectionHeadView.h"
#import "NewSearchRstTableViewCell.h"
#import "searchSectionFootView.h"
#import "UniversityCourseViewController.h"


@interface NewSearchRstViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *resultTableView;
@property(nonatomic,strong)NSMutableArray *resultList;
@property(nonatomic,copy)NSString *orderBy;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSString *fieldKey;
@property(nonatomic,assign)int  nextPage;
@end

@implementation NewSearchRstViewController
- (instancetype)initWithSearchText:(NSString *)text orderBy:(NSString *)orderBy {
    return [self initWithSearchText:text key:@"text" orderBy:orderBy];
}

- (instancetype)initWithSearchText:(NSString *)text key:(NSString *)key orderBy:(NSString *)orderBy {
    self = [self init];
    if (self) {
        _text = text;
        _orderBy = orderBy;
        _fieldKey = key;
        self.title = text;
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
//        _result = [NSMutableArray array];
//        _resultIDSet = [NSMutableSet set];
    }
    return self;
}

-(NSMutableArray *)resultList
{
    if (!_resultList) {
        _resultList =[NSMutableArray array];
    }
    return _resultList;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self reloadDataWithPageIndex:0 refresh:false];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];

}
-(void)makeUI
{
    self.resultTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, APPSIZE.height) style:UITableViewStyleGrouped];
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    [self.view addSubview:self.resultTableView];
    [ self.resultTableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];

}


- (void)reloadDataWithPageIndex:(int)page refresh:(BOOL)refresh {
 
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{_fieldKey: _text ?: [NSNull null],
                                                                                       @"page": @(page),
                                                                                       @"size": @20,
                                                                                       @"desc": @1,
                                                                                       @"order":@"ranking_ti"}];
    
//    if (_subject) {
//        [parameters setValue:@[@{@"name": @"subject", @"value": _subject}] forKey:@"filters"];
//    } else if(_country) {
//        [parameters setValue:@[@{@"name": @"country", @"value": _country}] forKey:@"filters"];
//    } else if(_state) {
//        [parameters setValue:@[@{@"name": @"state", @"value": _state}] forKey:@"filters"];
//    }
    
    [self
     startAPIRequestWithSelector:kAPISelectorSearch
     parameters:parameters
     expectedStatusCodes:nil
     showHUD:YES
     showErrorAlert:YES
     errorAlertDismissAction:nil
     additionalSuccessAction:^(NSInteger statusCode, id response) {
         
         self.nextPage = page + 1;
         
//         if(refresh) {
//             [_resultIDSet removeAllObjects];
//             [_result removeAllObjects];
//             
//         }
         
         [response[@"universities"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             
             [self.resultList addObject:obj];
             
          }];
//         _allResultCount = [response[@"count"] integerValue];
         
         [self.resultTableView reloadData];

     } additionalFailureAction:^(NSInteger statusCode, NSError *error) {


     }];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    
    NSDictionary *universytyInfo  =   self.resultList[section];
    NSArray *items = universytyInfo[@"courses"];
    if (items.count) {
        searchSectionFootView  *sectionFooter =[[searchSectionFootView alloc] init];
        sectionFooter.universityInfo = universytyInfo;
        sectionFooter.actionBlock = ^(NSString *universityID){
            
             UniversityCourseViewController *vc = [[UniversityCourseViewController alloc] initWithUniversityID:universityID];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        };
        return sectionFooter;
    }else{
        return nil;
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    searchSectionHeadView *sectionHeader =[[searchSectionHeadView alloc] init];
    NSDictionary *universytyInfo =   self.resultList[section];
    sectionHeader.universityInfo = universytyInfo;
    sectionHeader.actionBlock = ^(NSString *universityID){
    
        [self.navigationController pushUniversityViewControllerWithID:universityID animated:YES];
    };
    
    
    __block BOOL isLike = [universytyInfo[@"favorited"] boolValue];
    sectionHeader.followBlock = ^(UIButton *sender){
        
         if (![self  checkWhenUserLogOut]) {
            
            return;
        }

        if (!isLike) {
 
            [self startAPIRequestWithSelector:@"GET api/account/favorite/:id" parameters:@{@":id": universytyInfo[@"_id"]} success:^(NSInteger statusCode, id response) {
               
                [sender setImage:[UIImage  imageNamed:@"button_like"]  forState:UIControlStateNormal];
                KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
                [hud applySuccessStyle];
                [hud setLabelText:GDLocalizedString(@"UniversityDetail-0012")];//@"关注成功"];
                [hud hideAnimated:YES afterDelay:1];
                isLike = YES;
            }];
            
        }else{
            
            [self startAPIRequestWithSelector:@"GET api/account/unFavorite/:id" parameters:@{@":id": universytyInfo[@"_id"]} success:^(NSInteger statusCode, id response) {
                KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
                [sender setImage:[UIImage  imageNamed:@"button_Nolike"]  forState:UIControlStateNormal];
                [hud applySuccessStyle];
                [hud setLabelText:GDLocalizedString(@"UniversityDetail-0013")];//@"取消成功"];
                [hud hideAnimated:YES afterDelay:1];
                isLike = NO;

            }];
         
        }
        
        
 
        
    };
    return sectionHeader;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSDictionary *sectionInfo = self.resultList[section];
    NSArray *items = sectionInfo[@"courses"];
    if (items.count) {
        return 70;
    }else{
      return 20;
    }
  
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.resultList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    NSDictionary *sectionInfo = self.resultList[section];
    NSArray *items = sectionInfo[@"courses"];
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewSearchRstTableViewCell *cell =[NewSearchRstTableViewCell  cellWithTableView:tableView];
 
  
    NSDictionary *sectionInfo = self.resultList[indexPath.section];
    NSArray *items = sectionInfo[@"courses"];
    NSDictionary *itemInfo =items[indexPath.row];
    cell.itemInfo = itemInfo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

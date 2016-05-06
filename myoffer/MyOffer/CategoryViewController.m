//
//  CategoryViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/7/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "CategoryViewController.h"
#import "SearchViewController.h"
#import "SearchResultCell.h"
#import "ActionTableViewController.h"

@interface CategoryViewController () {
    int _categoryIndex;
    
    NSArray *_items;
    NSArray *_specialitys;
}
@property (weak, nonatomic) IBOutlet UISearchBar *UniSearchBar;

@end

#define kCellIdentifier NSStringFromClass([SearchResultCell class])


@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;

    for (UIButton *button in _buttons) {
        [button setBackgroundImage:[UIImage KD_imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor KD_colorWithCode:0xff868686] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor KD_colorWithCode:0xff2dccf7] forState:UIControlStateSelected];

        [button setImage:[button.currentImage KD_imageWithMaskColor:[UIColor KD_colorWithCode:0xff2dccf7]] forState:UIControlStateSelected];
    }
    //设置中英按钮
    
    UIButton *Button001 = _buttons[0];
    [Button001 setTitle:GDLocalizedString(@"Category-button001") forState:UIControlStateNormal];
    UIButton *Button002 = _buttons[1];
    [Button002 setTitle:GDLocalizedString(@"Category-button002") forState:UIControlStateNormal];
    UIButton *Button003 = _buttons[2];
    [Button003 setTitle:GDLocalizedString(@"Category-button003") forState:UIControlStateNormal];
    UIButton *Button004 = _buttons[3];
    [Button004 setTitle:GDLocalizedString(@"Category-button004") forState:UIControlStateNormal];
    
    self.UniSearchBar.placeholder = GDLocalizedString(@"Discover_search");
    
    
    
    [_tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)categoryButtonPressed:(UIButton *)sender {
    for (UIButton *button in _buttons) {
        button.selected = button == sender;
    }
    _categoryIndex = (int)sender.tag;
    [self reloadData];
}

- (void)reloadData {
    if (_categoryIndex == 0) {
        _items = nil;
        [self startAPIRequestUsingCacheWithSelector:kAPISelectorHotUniversity parameters:nil success:^(NSInteger statusCode, NSDictionary *response) {
            if (_categoryIndex == 0) {
                _items = @[response];
                _tableView.rowHeight = 100;
                [_tableView reloadData];
            }
        }];
    } else if (_categoryIndex == 1) {
        
        
        NSArray *Englandes = @[GDLocalizedString(@"CategoryVC-ENG001"),GDLocalizedString(@"CategoryVC-ENG002"),GDLocalizedString(@"CategoryVC-ENG003"),GDLocalizedString(@"CategoryVC-ENG004")];
        
        NSArray *Austes =@[GDLocalizedString(@"CategoryVC-AUSTR001"),GDLocalizedString(@"CategoryVC-AUSTR002"),GDLocalizedString(@"CategoryVC-AUSTR003"),GDLocalizedString(@"CategoryVC-AUSTR004"),GDLocalizedString(@"CategoryVC-AUSTR005"),GDLocalizedString(@"CategoryVC-AUSTR006"),GDLocalizedString(@"CategoryVC-AUSTR007")];
      //  _items = @[@[@"英格兰", @"苏格兰", @"北爱尔兰", @"威尔士"],
      //             @[@"西澳洲", @"南澳州", @"塔斯马尼亚州", @"新南威尔士州", @"昆士兰州", @"维多利亚州",@"澳大利亚首都领地"]];
        
        _items = @[Englandes,Austes];
        
        _tableView.rowHeight = 44;
        [_tableView reloadData];
    }  else if (_categoryIndex == 2) {
        _items = nil;
        _tableView.rowHeight = 44;
        [_tableView reloadData];
        
        // GDLocalizedString(@"ch_Language")    @"zh-cn"
        [self startAPIRequestUsingCacheWithSelector:kAPISelectorSubjects parameters:@{@":lang":GDLocalizedString(@"ch_Language")} success:^(NSInteger statusCode, NSDictionary *response) {
            if (_categoryIndex == 2) {
                _specialitys = (id)response;
                
                _items = @[[(NSArray *)response KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx) {
                    return obj[@"name"];
                }]];
                
                [_tableView reloadData];
            }
        }];
    } else {
          NSString *rankT = GDLocalizedString(@"CategoryVC-times");
          NSString *rankQS = GDLocalizedString(@"CategoryVC-world");
        _items = @[@[rankT, rankQS]];
         _tableView.rowHeight = 44;
        
        [_tableView reloadData];

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_categoryIndex == 1) {
        if (section == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UK.jpg"]];
            return imageView;
        } else if (section == 1) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AU.jpg"]];
            return imageView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_categoryIndex == 1) {
        if (section == 0 || section == 1) {
            return tableView.frame.size.width * 278.0f / 750.0f;
        }
    }
    return 0;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    SearchViewController *vc = [[SearchViewController alloc] init];
    XWGJNavigationController *nvc = [[XWGJNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];

    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_categoryIndex == 0) {
        SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        
        NSDictionary *info = _items[indexPath.section][indexPath.row];
        [cell configureWithInfo:info];
        
        return cell;
    } else {
        NSString * const identifier = @"UITableViewCellStyleDefault";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor KD_colorWithCode:0xff868686];
        }
        cell.textLabel.text = _items[indexPath.section][indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_categoryIndex == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSDictionary *info = _items[indexPath.section][indexPath.row];
        
        [self.navigationController pushUniversityViewControllerWithID:info[@"_id"] animated:YES];
    } else if (_categoryIndex == 2) {
        NSDictionary *info = _specialitys[indexPath.row];

        
        ActionTableViewController *vc = [[ActionTableViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = info[@"name"];
        
        vc.cells = @[[(NSArray *)info[@"subjects"] KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *i, NSUInteger idx) {
            ActionTableViewCell *cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = i[@"name"];
            cell.textLabel.textColor = [UIColor KD_colorWithCode:0xff868686];
            
            [cell setAction:^{
                SearchResultViewController *vc = [[SearchResultViewController alloc] initWithFilter:@"subject"
                                                                                               value:i[@"name"]
                                                                                             orderBy:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            return cell;
        }]];
        
        [self.navigationController pushViewController:vc animated:YES];
    } else if (_categoryIndex == 3)  {
        NSString *key = @[@"ranking_ti", @"ranking_qs"][indexPath.row];
        
        SearchResultViewController *vc = [[SearchResultViewController alloc] initWithSearchText:nil orderBy:key];
        vc.title = _items[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        SearchResultViewController *vc = [[SearchResultViewController alloc] initWithFilter:@"state"
                                                                                      value:_items[indexPath.section][indexPath.row]
                                                                                    orderBy:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

@implementation CategoryTableView

- (BOOL)allowsHeaderViewsToFloat {
    return NO;
}

@end

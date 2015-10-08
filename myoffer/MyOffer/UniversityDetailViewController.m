//
//  UniversityDetailViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/9/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "UniversityDetailViewController.h"
#import "UniversityCourseViewController.h"
#import "EvaluateViewController.h"
#import "UniversityMapsViewController.h"

@interface UniversityDetailViewController () {
    BOOL _isLiked;
    NSDictionary *_resultResponse;

}

@end

@implementation UniversityDetailViewController

- (instancetype)initWithUniversityID:(NSString *)ID {
    self = [self init];
    if (self) {
        _universityID = ID;
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"学校详情";
    
    _evaluationButton.layer.cornerRadius = 2;
    _evaluationButton.adjustAllRectWhenHighlighted = YES;
    _evaluationButton.layer.borderColor = [_evaluationButton currentTitleColor].CGColor;
    _evaluationButton.layer.borderWidth = 2;
    
    _scrollView.hidden = YES;
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
 - (void)reloadData {
    [self
     startAPIRequestWithSelector:kAPISelectorUniversityInfo
     parameters:@{@":id": _universityID}
     showHUD:YES errorAlertDismissAction:^{
         [self.navigationController popViewControllerAnimated:YES];
     } success:^(NSInteger statusCode, NSDictionary *response) {
       
         _resultResponse = response;
         _scrollView.hidden = NO;
         _descLabel.text = response[@"introduction"];
         
         _chineseNameLabel.text = response[@"name"];
         _englishNameLabel.text = response[@"official_name"];
         _setupYearLabel.text = [NSString stringWithFormat:@"%@年", response[@"found"]];
        _locationLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@", response[@"country"], response[@"state"], response[@"city"]];
         _rankingLabel.text = [NSString stringWithFormat:@"TIMES本国排名：%@\nQS世界排名：%@", [response[@"ranking_ti"] intValue] == 99999 ? @"暂无排名" : response[@"ranking_ti"], [response[@"ranking_qs"] intValue] == 99999 ? @"暂无排名" : response[@"ranking_qs"]];
        
        [_logoView.logoImageView KD_setImageWithURL:response[@"logo"]];
        _bannerView.views = [response[@"m_images"] KD_arrayUsingMapEnumerateBlock:^id(id obj, NSUInteger idx) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [imageView KD_setImageWithURL:obj];
            return imageView;
        }];
        
        _isLiked = [response[@"favorited"] boolValue];
        
        if (response[@"evaluation"]) {
            float success = [response[@"success_rate"] floatValue];
            _successLabel.text = [NSString stringWithFormat:@"平均录取率：%.0f%%", success];
            _successProgressView.progress = success / 100.0f;
            
            float my = [response[@"evaluation"] floatValue];
            if(my == -1) {
                _mySuccessLabel.text = @"计算中...";
                _mySuccessProgressView.progress = 0.0f;
                
                [self startAPIRequestWithSelector:kAPISelectorEvaluate
                                       parameters:@{@":id": _universityID}
                                          success:^(NSInteger statusCode, NSDictionary *response) {
                                              float my = [response[_universityID] floatValue];
                                              _mySuccessLabel.text = [NSString stringWithFormat:@"我的成功率: %.1f%%", my];
                                              _mySuccessProgressView.progress = my / 100.0f;
                                          }];
            }
            else {
                _mySuccessLabel.text = [NSString stringWithFormat:@"我的成功率：%.1f%%", my];
                _mySuccessProgressView.progress = my / 100.0f;
            }
            
            _evaluationButton.hidden = YES;
            _progressContainer.hidden = NO;
        } else {
            _evaluationButton.hidden = NO;
            _progressContainer.hidden = YES;
        }
        
        [self configureLikeButton];
    }];

}

- (void)toggleLike {
    RequireLogin
    _isLiked = !_isLiked;
    [self configureLikeButton];
    if (_isLiked) {
        [self startAPIRequestWithSelector:@"GET api/account/favorite/:id" parameters:@{@":id": _universityID} success:^(NSInteger statusCode, id response) {
            KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
            [hud applySuccessStyle];
            [hud setLabelText:@"关注成功"];
            [hud hideAnimated:YES afterDelay:1];
        }];
        
    } else {
        [self startAPIRequestWithSelector:@"GET api/account/unFavorite/:id" parameters:@{@":id": _universityID} success:^(NSInteger statusCode, id response) {
            KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
            [hud applySuccessStyle];
            [hud setLabelText:@"取消成功"];
            [hud hideAnimated:YES afterDelay:1];
        }];
    }
}

- (void)configureLikeButton {
    if (_isLiked) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_like_selected"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLike)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_like"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLike)];
    }
}

- (void)viewDidLayoutSubviews {
    _descLabel.preferredMaxLayoutWidth = _descLabel.frame.size.width;
}

- (IBAction)viewAllCourses {
    UniversityCourseViewController *vc = [[UniversityCourseViewController alloc] initWithUniversityID:_universityID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)evaluationButtonPressed {
    RequireLogin
    
    EvaluateViewController *vc = [[EvaluateViewController alloc] init];
    
    [vc setDismissCompletion:^(BaseViewController *vc) {
        [self reloadData];
    }];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:^{}];
}

- (IBAction)goToMapView:(UIButton *)sender {
    
   
    UniversityMapsViewController *mapsView = [[UniversityMapsViewController alloc] initWithNibName:@"UniversityMapsViewController" bundle:[NSBundle mainBundle]];
  
    mapsView.UniversityInfoDic = _resultResponse;

    [self.navigationController pushViewController:mapsView animated:YES];
}



@end

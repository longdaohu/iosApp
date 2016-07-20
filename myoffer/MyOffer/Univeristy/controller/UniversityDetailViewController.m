//
//  UniversityDetailViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/9/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "UniversityDetailViewController.h"
#import "InteProfileViewController.h"
#import "UniversityMapsViewController.h"
#import "UniversityCourseViewController.h"


@interface UniversityDetailViewController () {
    BOOL _isLiked;
    NSDictionary *_resultResponse;
 
}
@property (weak, nonatomic) IBOutlet UILabel *BuildTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *UniRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *GalPhotoLabel;
@property (weak, nonatomic) IBOutlet UILabel *BrifIInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *ShowCourseSBtn;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *EvaluationBtn;



@end

@implementation UniversityDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    [MobClick beginLogPageView:@"page学校详情"];

    [self reloadData];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page学校详情"];
    
}




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
    [self makeUI];
}

-(void)makeUI
{
    _englishNameLabel.hidden = USER_EN ? YES : NO;
    [self.EvaluationBtn setTitle:GDLocalizedString(@"UniversityDetail-testRate") forState:UIControlStateNormal];
    self.EvaluationBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.BuildTimeLabel.text = GDLocalizedString(@"UniversityDetail-004"); //"建校时期";
    self.LocationLabel.text = GDLocalizedString(@"UniversityDetail-005"); //"所在地";
    self.UniRankLabel.text = GDLocalizedString(@"UniversityDetail-006"); //"大学排名";
    self.BrifIInfoLabel.text = GDLocalizedString(@"UniversityDetail-007"); //"学校简介";
    self.GalPhotoLabel.text = GDLocalizedString(@"UniversityDetail-008"); //"照片展示";
    [self.ShowCourseSBtn setTitle:GDLocalizedString(@"UniversityDetail-009")  forState:UIControlStateNormal] ; //"查看所有专业课程";
    [self.ShowCourseSBtn setBackgroundColor:XCOLOR_RED];
    self.title = GDLocalizedString(@"UniversityDetail-001"); //@"学校详情";
    _evaluationButton.layer.cornerRadius = 2;
    _evaluationButton.adjustAllRectWhenHighlighted = YES;
    _evaluationButton.layer.borderColor = [_evaluationButton currentTitleColor].CGColor;
    _evaluationButton.layer.borderWidth = 2;
    _scrollView.hidden = YES;
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
                                 
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    
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
         
         _setupYearLabel.text = [NSString stringWithFormat:@"%@%@", response[@"found"],GDLocalizedString(@"UniversityDetail-year")];
         
         NSString *rankStr = GDLocalizedString(@"UniversityDetail-002");
         NSString *QSrank = GDLocalizedString(@"UniversityDetail-003");
         NSString *NOrank = GDLocalizedString(@"UniversityDetail-0010");
         
         _locationLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@", response[@"country"], response[@"state"], response[@"city"]];
         _rankingLabel.text = [NSString stringWithFormat:@"%@：%@",rankStr,[response[@"ranking_ti"] intValue] == 99999 ? NOrank : response[@"ranking_ti"]];
          _QSrankLabel.text = [NSString stringWithFormat:@"%@：%@",QSrank,[response[@"ranking_qs"] intValue] == 99999 ? NOrank : response[@"ranking_qs"]];
         if([response[@"country"] isEqualToString:GDLocalizedString(@"CategoryVC-AU")])
         {
             
             _rankingLabel.text = [NSString stringWithFormat:@"%@：",rankStr];

             CGSize ranksize = [rankStr KD_sizeWithAttributeFont:[UIFont systemFontOfSize:14]];
             
             for (NSInteger i =0; i<[response[@"ranking_ti"] intValue]; i++) {
                 
                 UIImageView *mv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_rankingLabel.frame)+ranksize.width+10+i*20, CGRectGetMaxY(_QSrankLabel.frame)+5, 15, 15)];
                 mv.image = [UIImage imageNamed:@"star"];
                 UIView *backView = _rankingLabel.superview;
                 [backView addSubview:mv];
             }
         }
         [_logoView.logoImageView KD_setImageWithURL:response[@"logo"]];
        _bannerView.views = [response[@"m_images"] KD_arrayUsingMapEnumerateBlock:^id(id obj, NSUInteger idx) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [imageView KD_setImageWithURL:obj];
            return imageView;
        }];
     
         
         if ([AppDelegate sharedDelegate].isLogin) {
        
        _isLiked = [response[@"favorited"] boolValue];
             
        self.firstLike = [response[@"favorited"] boolValue];
             
        if (response[@"evaluation"] ) {
            
            
            float success = [response[@"success_rate"] floatValue];
            
            
            _successLabel.text = [NSString stringWithFormat:@"%@：%.0f%%",GDLocalizedString(@"UniversityDetail-0011"),success];
            
            
            _successProgressView.progress = success / 100.0f;
            
            float my = [response[@"evaluation"] floatValue];
            
            if(my == -1) {
                
                _mySuccessLabel.text =GDLocalizedString(@"UniversityDetail-operating");//@"计算中...";
                _mySuccessProgressView.progress = 0.0f;
                [self startAPIRequestWithSelector:kAPISelectorEvaluate
                                       parameters:@{@":id": _universityID}
                                          success:^(NSInteger statusCode, NSDictionary *response) {
                                              float my = [response[_universityID] floatValue];
                                              _mySuccessLabel.text = [NSString stringWithFormat:@"%@: %.1f%%",GDLocalizedString(@"UniversityDetail-0014"), my];
                                              _mySuccessProgressView.progress = my / 100.0f;
                                          }];
            }
            else {
                //我的成功率
                _mySuccessLabel.text = [NSString stringWithFormat:@"%@：%.1f%%",GDLocalizedString(@"UniversityDetail-0014"), my];
                _mySuccessProgressView.progress = my / 100.0f;
            }
            [self aboutHiden:YES];
            
        } else {
            
            [self aboutHiden:NO];
        }
             
    }else
    {
        [self aboutHiden:NO];
    }
        
        [self configureLikeButton];
    }];

}

-(void)aboutHiden:(BOOL)ishiden;
{
    _evaluationButton.hidden = ishiden;
    _progressContainer.hidden = !ishiden;
}
- (void)toggleLike {
    
    
 
      RequireLogin
    
     if (!_isLiked) {
        [self startAPIRequestWithSelector:@"GET api/account/favorite/:id" parameters:@{@":id": _universityID} success:^(NSInteger statusCode, id response) {
            KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
            [hud applySuccessStyle];
            [hud setLabelText:GDLocalizedString(@"UniversityDetail-0012")];//@"关注成功"];
             _isLiked = !_isLiked;
            [self configureLikeButton];
            [hud hideAnimated:YES afterDelay:1];
        }];
        
    } else {
        
        [self startAPIRequestWithSelector:@"GET api/account/unFavorite/:id" parameters:@{@":id": _universityID} success:^(NSInteger statusCode, id response) {
            KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
            [hud applySuccessStyle];
            [hud setLabelText:GDLocalizedString(@"UniversityDetail-0013")];//@"取消成功"];
          
            _isLiked = !_isLiked;
            [self configureLikeButton];
            
            [hud hideAnimated:YES afterDelay:1];

        }];
    }
}

- (void)configureLikeButton {
    if (_isLiked) {
        UIImage *selectedImage=[UIImage imageNamed: @"nav_likePress"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLike)];
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
    
    InteProfileViewController  *vc = [[InteProfileViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goToMapView:(UIButton *)sender {
    
   
    UniversityMapsViewController *mapsView = [[UniversityMapsViewController alloc] initWithNibName:@"UniversityMapsViewController" bundle:[NSBundle mainBundle]];
  
    mapsView.UniversityInfoDic = _resultResponse;

    [self.navigationController pushViewController:mapsView animated:YES];
}

-(void)popBack
{

    if(self.actionBlock)
    {
        BOOL fresh   =  self.firstLike == _isLiked ? NO : YES;
        NSString *freshStr = [NSString stringWithFormat:@"%d",fresh];
        
         self.actionBlock(freshStr);
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end

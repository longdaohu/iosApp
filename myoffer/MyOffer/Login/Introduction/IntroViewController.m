//
//  IntroViewController.m
//  
//
//  Created by Blankwonder on 6/15/15.
//
//

#import "IntroViewController.h"
#import "KDBannerView.h"

@interface IntroViewController ()<KDBannerViewDelegate>
{
}
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *EnterButton;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _bannerView.pageControlBottomInset = 15.0f;
//    _bannerView.delegate = self;
    _bannerView.views = @[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"into001"]],
                          [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"into002"]],
                          [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"into003"]]];
    
    for (UIImageView *view in _bannerView.views) {
        view.contentMode = UIViewContentModeScaleAspectFill;
    }
}

- (void)bannerView:(KDBannerView *)bannerView atIndex:(int)index
{
    if (index == _bannerView.views.count - 1) {
        
        self.EnterButton.hidden = NO;
    }
    else
    {
        self.EnterButton.hidden = YES;
    }
   
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page引导页"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page引导页"];
    
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

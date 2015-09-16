//
//  IntroViewController.m
//  
//
//  Created by Blankwonder on 6/15/15.
//
//

#import "IntroViewController.h"
#import "KDBannerView.h"

@interface IntroViewController () {
}

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _bannerView.pageControlBottomInset = 15.0f;
    _bannerView.views = @[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_1"]],
                          [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_2"]],
                          [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_3"]],
                          [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_4"]]];
    
    for (UIImageView *view in _bannerView.views) {
        view.contentMode = UIViewContentModeScaleAspectFill;
    }
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

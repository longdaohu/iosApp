//
//  UINavigationController+NavigationHelper.m
//  MyOffer
//
//  Created by Blankwonder on 6/9/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "UINavigationController+NavigationHelper.h"
#import "UniversityViewController.h"

@implementation UINavigationController (NavigationHelper)

- (void)pushUniversityViewControllerWithID:(NSString *)ID animated:(BOOL)animated {
    
    UniversityViewController *vc = [[UniversityViewController alloc] init];
    vc.uni_id =  ID;
    [self pushViewController:vc animated:animated];
}

@end

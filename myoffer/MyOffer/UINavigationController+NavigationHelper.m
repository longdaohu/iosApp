//
//  UINavigationController+NavigationHelper.m
//  MyOffer
//
//  Created by Blankwonder on 6/9/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "UINavigationController+NavigationHelper.h"
#import "UniversityDetailViewController.h"

@implementation UINavigationController (NavigationHelper)

- (void)pushUniversityViewControllerWithID:(NSString *)ID animated:(BOOL)animated {
    UniversityDetailViewController *vc = [[UniversityDetailViewController alloc] initWithUniversityID:ID];
    [self pushViewController:vc animated:animated];
}

@end

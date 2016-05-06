//
//  DiscoverViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/7/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverViewController : BaseViewController  <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UIView *_searchBar;
    
    IBOutlet NSLayoutConstraint *_searchBarWidth, *_searchBarTextFieldWidth;
    IBOutlet UITextField *_searchBarTextField;
}

@property (nonatomic) IBOutlet UITableView *tableView;

- (IBAction)searchButtonPressed;

@end

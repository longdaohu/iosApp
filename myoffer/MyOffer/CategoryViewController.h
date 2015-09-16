//
//  CategoryViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/7/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableView : UITableView
@end

@interface CategoryViewController : BaseViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *_tableView;
    
    IBOutletCollection(UIButton) NSArray *_buttons;
}

- (IBAction)categoryButtonPressed:(UIButton *)sender;

@end

//
//  FavoriteViewController.h
//  
//
//  Created by Blankwonder on 6/17/15.
//
//

#import "BaseViewController.h"

@interface FavoriteViewController : BaseViewController {
    UITableView *_tableView;
}

- (void)reloadData;

@end

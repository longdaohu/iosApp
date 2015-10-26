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
@property (weak, nonatomic) IBOutlet UITableView *FavoriteTableView;


- (void)reloadData;

@end

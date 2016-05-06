//
//  SearchViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/10/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchViewController : BaseViewController <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UISearchBar *_searchBar;
}
@property (nonatomic) NSString *searchTextPlaceholder;


@end

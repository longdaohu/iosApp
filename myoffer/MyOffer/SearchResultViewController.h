//
//  SearchResultViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/10/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "BaseViewController.h"
#import "FilterView.h"

@interface SearchResultViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *_tableView;
    
    
    IBOutlet UIView *_noResultView;

}
@property(nonatomic,assign)BOOL xby;

- (instancetype)initWithFilter:(NSString *)key value:(NSString *)value orderBy:(NSString *)orderBy;
- (instancetype)initWithSearchText:(NSString *)text key:(NSString *)key orderBy:(NSString *)orderBy;
- (instancetype)initWithSearchText:(NSString *)text orderBy:(NSString *)orderBy;

@end

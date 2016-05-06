//
//  UniversityCourseViewController.h
//  
//
//  Created by Blankwonder on 6/17/15.
//
//

#import "BaseViewController.h"
#import "FilterView.h"
@interface UniversityCourseViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *_tableView;
    IBOutlet FilterView *_filterView;
    
    IBOutlet UILabel *_selectedCountLabel;
}

- (instancetype)initWithUniversityID:(NSString *)ID;

@property (readonly) NSString *universityID;

- (IBAction)addSelectedCourse;

@end

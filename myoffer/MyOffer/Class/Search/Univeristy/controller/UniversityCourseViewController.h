//
//  UniversityCourseViewController.h
//  
//
//  Created by Blankwonder on 6/17/15.
//
//

#import "BaseViewController.h"
#import "FilterView.h"
@interface UniversityCourseViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithUniversityID:(NSString *)ID;

@property (readonly) NSString *universityID;

- (IBAction)addSelectedCourse;

@end

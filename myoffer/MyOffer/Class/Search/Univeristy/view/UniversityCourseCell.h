//
//  UniversityCourseCell.h
//  
//
//  Created by Blankwonder on 6/17/15.
//
//

#import <UIKit/UIKit.h>
@class UniversityCourseFrame;
#import "SearchUniCourseFrame.h"

@interface UniversityCourseCell : UITableViewCell

@property(nonatomic,strong)SearchUniCourseFrame *search_course_frame;
@property(nonatomic,strong)UniversityCourseFrame *course_frame;

- (void)cellSelectedButtonHiden:(BOOL)hiden;
- (void)bottomLineHiden:(BOOL)hiden;

- (void)cellDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

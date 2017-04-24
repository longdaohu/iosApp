//
//  UniversityCourseCell.h
//  
//
//  Created by Blankwonder on 6/17/15.
//
//

#import <UIKit/UIKit.h>
@class UniversityCourseFrame;
@interface UniversityCourseCell : UITableViewCell
@property(nonatomic,strong)UniversityCourseFrame *course_frame;
@property(nonatomic,copy)NSString *title;


- (void)cellDidSelectRowSelected:(BOOL)selected;

- (void)cellDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

//
//  UniversityCourseCell.h
//  
//
//  Created by Blankwonder on 6/17/15.
//
//

#import <UIKit/UIKit.h>
@class UniversityCourse;
@interface UniversityCourseCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *info;
@property(nonatomic,strong)UniversityCourse *course;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *degreesLab;
@property (nonatomic,strong) UILabel *subjectLab;
@property (nonatomic) IBOutlet UIButton *selectionView;
@property(nonatomic,copy)NSString *title;

-(void)cellDidSelectRowSelected:(BOOL)selected;
-(void)cellDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end

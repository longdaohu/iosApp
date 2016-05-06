//
//  UniversityCourseCell.h
//  
//
//  Created by Blankwonder on 6/17/15.
//
//

#import <UIKit/UIKit.h>

@interface UniversityCourseCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *info;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *degreesLab;
@property (nonatomic,strong) UILabel *subjectLab;

@property (nonatomic) IBOutlet UILabel *detailLabel1;
@property (nonatomic) IBOutlet UILabel *detailLabel2;

@property (nonatomic) IBOutlet UIButton *selectionView;

@property(nonatomic,copy)NSString *title;

@end

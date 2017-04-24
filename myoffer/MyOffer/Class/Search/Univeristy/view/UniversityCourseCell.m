//
//  UniversityCourseCell.m
//  
//
//  Created by Blankwonder on 6/17/15.
//
//

#import "UniversityCourseCell.h"
#import "UniversityCourse.h"
#import "UniversityCourseFrame.h"

@interface UniversityCourseCell ()
@property (nonatomic,strong) UILabel *official_Lab;
@property (nonatomic,strong) UIButton *optionBtn;
@property (nonatomic,strong) UIView *bg_View;


@end

@implementation UniversityCourseCell

static NSString *identify = @"course";
+ (instancetype)cellWithTableView:(UITableView *)tableView{
   
    UniversityCourseCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        
        cell = [[UniversityCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    return cell;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self makeUI];
    }
    
    
    return self;
}


- (void)makeUI{

    UILabel *official_lab = [[UILabel alloc] init];
    official_lab.font = XFONT(14);
    official_lab.numberOfLines = 2;
    official_lab.textColor = XCOLOR_TITLE;
    [self.contentView addSubview:official_lab];
    self.official_Lab = official_lab;
    
    
    UIButton *optionBtn = [UIButton new];
    [self.contentView addSubview:optionBtn];
    self.optionBtn = optionBtn;
    optionBtn.titleLabel.font = XFONT(14);
    optionBtn.userInteractionEnabled = NO;
    [optionBtn setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateNormal];
    
    UIView *bgView = [UIView new];
    [self.contentView addSubview:bgView];
    self.bg_View = bgView;
    
    
}

- (void)setCourse_frame:(UniversityCourseFrame *)course_frame{

    _course_frame = course_frame;
    
    UniversityCourse *course = course_frame.course;
    
    self.official_Lab.text = course.official_name;
    
    self.official_Lab.frame = course_frame.official_name_Frame;
    
    self.optionBtn.frame = course_frame.option_Frame;
    
    [self configureCellWithCourse:course];
    
    self.bg_View.frame = course_frame.items_bg_Frame;
    
    if (self.bg_View.subviews.count > 0) {
    
        [self.bg_View.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    
    for (NSInteger index = 0 ; index < course_frame.course.items.count; index++) {
    
        NSString *item = course_frame.course.items[index];
        CGRect item_Frame = [course_frame.items_Frame[index] CGRectValue];
        [self itemWithName: item frame: item_Frame];
        
     }
  
    
}

- (void)itemWithName:(NSString *)name frame:(CGRect)frame{

    UILabel *sender = [UILabel new];
    [self.bg_View addSubview:sender];
    sender.textColor = XCOLOR_SUBTITLE;
    sender.backgroundColor = XCOLOR_BG;
    sender.font = XFONT(11);
    sender.text = name;
    sender.frame = frame;
    sender.layer.cornerRadius = CORNER_RADIUS;
    sender.layer.masksToBounds = YES;
    sender.textAlignment = NSTextAlignmentCenter;
    
}


- (void)configureCellWithCourse:(UniversityCourse *)course {
  
    
    NSString *title = course.applied ? GDLocalizedString(@"UniCourseDe-007") : @"";
    
    [self.optionBtn setTitle: title  forState:UIControlStateNormal];

    if (course.applied) {
       
        [self.optionBtn setImage:nil forState:UIControlStateNormal];
   
    }else {
       
        NSString *imageName = self.course_frame.course.optionSeleced ? @"check-icons-yes" : @"check-icons";
        
        [self.optionBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
}

-(void)cellDidSelectRowSelected:(BOOL)selected{

     self.course_frame.course.optionSeleced = selected;
    
    [self configureCellWithCourse:self.course_frame.course];
}

-(void)cellDidSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    self.course_frame.course.optionSeleced = !self.course_frame.course.optionSeleced;
    
    [self configureCellWithCourse:self.course_frame.course];
    

}

/*
-(void)setInfo:(NSDictionary *)info
{
    _info = info;
    
 
    self.official_Lab.text = info[@"official_name"];
    
    CGSize size = [info[@"official_name"] boundingRectWithSize:CGSizeMake(XSCREEN_WIDTH - 60, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:15.0]}
                                      context:NULL].size;
    
    
    
    CGFloat titleX = 10;
    CGFloat titleY = 10;
    CGFloat titleW = XSCREEN_WIDTH - 60;
    CGFloat titleH = size.height;
    self.official_Lab.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    
    self.degreesLab.text  = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"UniCourseDe-006"),info[@"level"]];
    self.subjectLab.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"UniCourseDe-005"), [info[@"areas"] componentsJoinedByString:@","]];
    

    


    CGSize degreeSize =[self.degreesLab.text KD_sizeWithAttributeFont:[UIFont systemFontOfSize:12]]; //[self text:self.degreesLab.text maxWidth:degreeW andfontSize:12];
    CGSize subjectSize = [self.subjectLab.text KD_sizeWithAttributeFont:[UIFont systemFontOfSize:12]];//[self text:self.subjectLab.text maxWidth:subjectW andfontSize:12];
    
    
    CGFloat degreeX = titleX;
    CGFloat degreeW = 140 + KDUtilSize(0) * 8;
    CGFloat degreeY = self.contentView.bounds.size.height - 30;
    CGFloat degreeH = degreeSize.width > degreeW ? 29 : 13;
    self.degreesLab.frame = CGRectMake(degreeX, degreeY, degreeW, degreeH);
   
    
    
    CGFloat subjectX =degreeW + degreeX + 5;
    CGFloat subjectW = XSCREEN_WIDTH - subjectX;
    CGFloat subjectY = degreeY;
    CGFloat subjectH = subjectSize.width > subjectW ? 29 : 13;
    self.subjectLab.frame = CGRectMake(subjectX, subjectY, subjectW, subjectH);

    
}


*/


@end





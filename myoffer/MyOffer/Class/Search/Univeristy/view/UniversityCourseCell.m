//
//  UniversityCourseCell.m
//  
//
//  Created by Blankwonder on 6/17/15.
//
//

#import "UniversityCourseCell.h"

@implementation UniversityCourseCell

-(void)awakeFromNib
{
    self.titleLabel =[[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    self.titleLabel.textColor =XCOLOR_DARKGRAY;
    [self.contentView addSubview:self.titleLabel];
    
    
    self.degreesLab =[UILabel labelWithFontsize:12 TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentLeft];
    self.degreesLab.numberOfLines = 2;
    [self.contentView addSubview:self.degreesLab];
    
    self.subjectLab =[UILabel labelWithFontsize:12 TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentLeft];
    self.subjectLab.lineBreakMode = NSLineBreakByCharWrapping;
    [self.subjectLab sizeToFit];
    self.subjectLab.numberOfLines =2;
    [self.contentView addSubview:self.subjectLab];
    
}



-(void)setInfo:(NSDictionary *)info
{
    _info = info;
    
 
    self.titleLabel.text = info[@"official_name"];
    
    CGSize size = [info[@"official_name"] boundingRectWithSize:CGSizeMake(XScreenWidth - 60, 999)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:15.0]}
                                      context:NULL].size;
    
    
    
    CGFloat titleX = 10;
    CGFloat titleY = 10;
    CGFloat titleW = XScreenWidth - 60;
    CGFloat titleH = size.height;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    
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
    CGFloat subjectW = XScreenWidth - subjectX;
    CGFloat subjectY = degreeY;
    CGFloat subjectH = subjectSize.width > subjectW ? 29 : 13;
    self.subjectLab.frame = CGRectMake(subjectX, subjectY, subjectW, subjectH);

    
}





@end





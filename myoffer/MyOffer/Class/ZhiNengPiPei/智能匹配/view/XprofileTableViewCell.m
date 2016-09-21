//
//  XprofileTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/8.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XprofileTableViewCell.h"

@interface XprofileTableViewCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *yinxiangLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyLabel;
@property (weak, nonatomic) IBOutlet UILabel *beijinLabel;
@property (weak, nonatomic) IBOutlet UILabel *universityLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *AGPLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeNotiLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;


@end

@implementation XprofileTableViewCell

- (void)awakeFromNib {
    
    self.countryTF.placeholder = GDLocalizedString(@"ApplicationProfile-003");
    self.timeTF.placeholder = GDLocalizedString(@"ApplicationProfile-004");
    self.gradeTF.placeholder = GDLocalizedString(@"ApplicationProfile-grade");
    self.universityTF.placeholder = GDLocalizedString(@"Evaluate-009");
    self.GPATF.placeholder = GDLocalizedString(@"Evaluate-0011");
    self.avgTF.placeholder = GDLocalizedString(@"Evaluate-0012");
    self.lowTF.placeholder = GDLocalizedString(@"Evaluate-0013");
    self.subjectedTF.placeholder = GDLocalizedString(@"Evaluate-0010");
     self.applySubjectTF.placeholder =  GDLocalizedString(@"Evaluate-0014");
//    self.universityTF.enabled = NO;
    
    self.contentView.backgroundColor =  XCOLOR_BG;
    [self addRightViewWithTextField:self.countryTF];
    [self addLeftViewWithTextField:self.countryTF];
    [self addRightViewWithTextField:self.timeTF];
    [self addLeftViewWithTextField:self.timeTF];
    [self addRightViewWithTextField:self.applySubjectTF];
    [self addLeftViewWithTextField:self.applySubjectTF];
    [self addRightViewWithTextField:self.subjectedTF];
    [self addLeftViewWithTextField:self.subjectedTF];
    self.GPATF.delegate = self;
    self.GPATF.keyboardType =  UIKeyboardTypeNumberPad;
    [self addLeftViewWithTextField:self.GPATF];
    [self addRightViewWithTextField:self.gradeTF];
    [self addLeftViewWithTextField:self.gradeTF];
    [self addRightViewWithTextField:self.avgTF];
    [self addLeftViewWithTextField:self.avgTF];
    [self addRightViewWithTextField:self.lowTF];
    [self addLeftViewWithTextField:self.lowTF];
    [self addLeftViewWithTextField:self.universityTF];
    
    self.yinxiangLabel.text = GDLocalizedString(@"Evaluate-Yixiang");
    self.countryLabel.text = GDLocalizedString(@"ExpectedCountry-002");
    self.timeLabel.text = GDLocalizedString(@"ExpectedTime-002");
    self.applyLabel.text = GDLocalizedString(@"ExpectedSubject-002");
    self.beijinLabel.text = GDLocalizedString(@"Evaluate-Beijin");
    self.AGPLabel.text = GDLocalizedString(@"Evaluate-004" );
    self.subjectCurrentLabel.text = GDLocalizedString(@"Evaluate-003");
    self.gradeLabel.text = GDLocalizedString(@"UniversityBG-002");
    self.gradeNotiLabel.text = GDLocalizedString(@"Evaluate-gradeNoti");
    self.gradeNotiLabel.adjustsFontSizeToFitWidth = YES;
    self.lowLabel.text = GDLocalizedString(@"Evaluate-006");
    self.averageLabel.text =  GDLocalizedString(@"Evaluate-005");
    self.universityLabel.text = GDLocalizedString(@"Evaluate-002");
    
    self.searchBtn.layer.cornerRadius = 4;
    self.searchBtn.backgroundColor = XCOLOR_RED;
    self.searchBtn.titleLabel.font = FontWithSize(16);
    self.searchBtn.hidden = USER_EN;
    
}



-(void)addLeftViewWithTextField:(UITextField *)textField
{
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.layer.cornerRadius = 5;
    textField.layer.masksToBounds = YES;
    [textField setValue:[UIColor clearColor] forKeyPath:@"_placeholderLabel.textColor"];

}

-(void)addRightViewWithTextField:(UITextField *)textField
{
    textField.rightViewMode = UITextFieldViewModeAlways;
    UIImageView  *mv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    mv.image =[UIImage imageNamed:@"common_icon_arrow"];
    mv.contentMode = UIViewContentModeScaleAspectFill;
    textField.rightView  = mv;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.GPATF) {
        
        textField.text  = [textField.text intValue] <= 100 ? textField.text :@"100" ;
    }
}

- (IBAction)searchUniversity:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(XprofileTableViewCell:WithButtonItem:)]) {
        [self.delegate XprofileTableViewCell:self WithButtonItem:sender];
    }
    
}



@end


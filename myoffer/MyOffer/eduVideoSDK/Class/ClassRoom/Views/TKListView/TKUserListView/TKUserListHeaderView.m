//
//  TKUserListHeaderView.m
//  EduClass
//
//  Created by lyy on 2018/4/27.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKUserListHeaderView.h"
#define ThemeKP(args) [@"TKDocumentListView." stringByAppendingString:args]
@interface TKUserListHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *equipmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *underplatformLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioLabel;

@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@property (weak, nonatomic) IBOutlet UILabel *handLabel;
@property (weak, nonatomic) IBOutlet UILabel *bannedLabel;
@property (weak, nonatomic) IBOutlet UILabel *deleteLabel;

@property (nonatomic, strong) NSArray *labelArray;

@property (nonatomic, strong) NSArray *labelTitleArray;

@end

@implementation TKUserListHeaderView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.labelArray = @[self.equipmentLabel,self.nickNameLabel,self.underplatformLabel,self.videoLabel,self.audioLabel,self.editLabel,self.handLabel,self.bannedLabel,self.deleteLabel];
    self.labelTitleArray = @[MTLocalized(@"Label.Equipment"),MTLocalized(@"Label.UserNickname"),MTLocalized(@"Label.StepUpAndDown"),MTLocalized(@"Label.Camera"),MTLocalized(@"Label.Microphone"),MTLocalized(@"Label.Authorized"),MTLocalized(@"Label.RaisingHands"),MTLocalized(@"Label.Ban"),MTLocalized(@"Label.Remove")];
   
}

- (void)setTitleHeight:(CGFloat)height{
    
    CGFloat textH = height/12.0/3.0;
    
    for (int i = 0; i<self.labelArray.count; i++) {
        UILabel *label = (UILabel *)self.labelArray[i];
        
        label.font = [UIFont systemFontOfSize:textH];
        label.sakura.textColor(ThemeKP(@"userlistTextColor"));
        label.text  = self.labelTitleArray[i];
        
    }
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

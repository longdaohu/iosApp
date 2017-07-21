//
//  SMTagCell.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMTagCell.h"

@interface SMTagCell ()
@property(nonatomic,strong)UIView *topicView;
@property(nonatomic,strong)UIView *subjectView;
@property(nonatomic,strong)UIView *line;
@end

@implementation SMTagCell

static NSString *identify = @"sm_tag";

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    SMTagCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        
        cell =[[SMTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
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
    
    UIView *topicView = [UIView new];
    self.topicView = topicView;
    [self.contentView addSubview:topicView];
    
    UIView *subjectView = [UIView new];
    self.subjectView = subjectView;
    [self.contentView addSubview:subjectView];
    
    UIView *line = [UIView new];
    self.line = line;
    line.backgroundColor = XCOLOR_line;
    [self.contentView addSubview:line];
 
}

- (void)setTagFrame:(SMTagFrame *)tagFrame{

    _tagFrame = tagFrame;
    
    self.topicView.frame = tagFrame.topicFrame;
    self.line.frame = tagFrame.lineFrame;
    self.subjectView.frame = tagFrame.subjectFrame;
    
    
    if (self.topicView.subviews.count == 0) {
        
        [self makeSubViewsWithTitleFrames:tagFrame.topicFrames  titles:tagFrame.tag.topic containView:self.topicView action:@selector(topicOnClick:)];
    }
    
    
    if (self.subjectView.subviews.count == 0) {
        
        NSArray *subjects = [tagFrame.tag.subject valueForKeyPath:@"name"];
        [self makeSubViewsWithTitleFrames:tagFrame.subjectFrames titles:subjects  containView:self.subjectView action:@selector(subjectOnClick:)];
    }
    

    
}


- (void)makeSubViewsWithTitleFrames:(NSArray *)titleFrames  titles:(NSArray *)titles containView:(UIView *)containView action:(SEL)action{
    
    for (int i = 0; i < titleFrames.count; i ++) {
    
        CGRect senderFrame = [titleFrames[i] CGRectValue];
        //创建 label点击事件
        UIButton *sender = [[UIButton alloc]init];
        sender.tag = i;
        [sender addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        sender.frame = senderFrame;
        sender.layer.cornerRadius = sender.mj_h * 0.5;
        sender.layer.borderColor = XCOLOR_LIGHTBLUE.CGColor;
        sender.layer.borderWidth = 1;
        [sender setTitle:titles[i] forState:UIControlStateNormal];
        [sender setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
         sender.titleLabel.font = [UIFont systemFontOfSize:16];
      
        [containView addSubview:sender];
        
     }
    
}

- (void)topicOnClick:(UIButton *)sender{
    
    if (self.actionBlock) {
        
        self.actionBlock(sender.currentTitle, nil);
    }
}

- (void)subjectOnClick:(UIButton *)sender{
    
    
    if (self.actionBlock) {
        
       NSDictionary*subject =  self.tagFrame.tag.subject[sender.tag];
        
         self.actionBlock(nil, subject[@"area_id"]);
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

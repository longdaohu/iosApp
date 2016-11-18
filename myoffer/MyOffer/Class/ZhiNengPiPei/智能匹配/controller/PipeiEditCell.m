//
//  PipeiEditCell.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "PipeiEditCell.h"

@interface PipeiEditCell ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *contentTF;
@property(nonatomic,strong)UIButton *sender;
@end

@implementation PipeiEditCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *identify = @"editPipei";
    
    PipeiEditCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    
        if (!cell) {
            
            cell =[[PipeiEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        UITextField *contentTF = [[UITextField alloc] init];
        contentTF.backgroundColor = XCOLOR_WHITE;
        contentTF.leftViewMode =  UITextFieldViewModeAlways;
        contentTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PADDING_TABLEGROUP, 1)];
        self.contentTF = contentTF;
        self.contentTF.layer.cornerRadius = 2;
        self.contentTF.layer.borderWidth = 1;
        self.contentTF.layer.borderColor = XCOLOR_LIGHTGRAY.CGColor;
        [self.contentView addSubview:contentTF];
        self.contentView.backgroundColor = XCOLOR_BG;
        self.contentTF.delegate = self;
        
        UIButton *sender = [[UIButton alloc] init];
        sender.backgroundColor = [UIColor redColor];
        [sender addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        self.sender = sender;
        [self.contentView addSubview:sender];
        
    }
    
    return self;
}


-(void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat contentX = PADDING_TABLEGROUP;
    CGFloat contentY = 0;
    CGFloat contentW = self.bounds.size.width - contentX  * 2;
    CGFloat contentH = self.bounds.size.height ;
    self.contentTF.frame = CGRectMake(contentX, contentY, contentW, contentH);
    
    self.sender.frame = self.contentTF.frame;
    
}

-(void)setGroup:(PipeiGroup *)group{

    _group = group;
    
    self.contentTF.text = group.content;
    
    self.sender.hidden = !(group.groupType == PipeiGroupTypeUniversity);
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if ([self.delegate respondsToSelector:@selector(PipeiEditCell:textFieldDidEndEditing:)]) {
        
        [self.delegate PipeiEditCell:self textFieldDidEndEditing:textField];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if ([self.delegate respondsToSelector:@selector(PipeiEditCell:textFieldDidBeginEditing:)]) {
        
        [self.delegate PipeiEditCell:self textFieldDidBeginEditing:textField];
    }
}


-(void)onClick{
    
    if ([self.delegate respondsToSelector:@selector(PipeiEditCellPush)]) {
        
        [self.delegate PipeiEditCellPush];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


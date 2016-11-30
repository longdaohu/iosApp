//
//  PipeiEditCell.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "PipeiEditCell.h"
#import "XWGJKeyboardToolar.h"

@interface PipeiEditCell ()<UITextFieldDelegate,KeyboardToolarDelegate>
//用于监听个别cell点击跳转事件
@property(nonatomic,strong)UIButton *sender;
//箭头图片
@property(nonatomic,strong)UIImageView *arrowView;
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
        //输入框
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
        
        //跳转按钮
        UIButton *sender = [[UIButton alloc] init];
        [sender addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        self.sender = sender;
        [self.contentView addSubview:sender];
        
        //工具条
        XWGJKeyboardToolar *tooler =[[NSBundle mainBundle] loadNibNamed:@"XWGJKeyboardToolar" owner:self options:nil].lastObject;
        tooler.delegate = self;
        self.contentTF.inputAccessoryView = tooler;
        
        //箭头图片
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:XImage(@"upDown")];
        arrowView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:arrowView];
        arrowView.hidden = YES;
        self.arrowView = arrowView;
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
    
    CGFloat arrowH = contentH;
    CGFloat arrowW = arrowH - 35;
    CGFloat arrowY = 0;
    CGFloat arrowX = CGRectGetMaxX(self.contentTF.frame) - arrowW - 10;
    self.arrowView.frame = CGRectMake(arrowX, arrowY, arrowW, arrowH);
    
}

-(void)setGroup:(PipeiGroup *)group{
    
    _group = group;
    
    self.contentTF.text = group.content;
    
    self.sender.hidden = !(group.groupType == PipeiGroupTypeUniversity);
    
    self.arrowView.hidden = !(group.groupType == PipeiGroupTypeSubject);
   
    //监听分数输入框
    if (group.groupType == PipeiGroupTypeScorce) {
        
        [self.contentTF addTarget:self action:@selector(limitMaxScore:) forControlEvents:UIControlEventEditingChanged];
        
    }
    
    
}

#pragma mark ———  KeyboardToolarDelegate
-(void)KeyboardToolar:(XWGJKeyboardToolar *)toolView didClick:(UIBarButtonItem *)sender
{
    
    if ([self.delegate respondsToSelector:@selector(PipeiEditCell:didClick:)]) {
        
        [self.delegate PipeiEditCell:self didClick:sender];
        
    }
    
}


#pragma mark ——— UITextFieldDelegate
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

//监听点击
-(void)onClick{
    
    if ([self.delegate respondsToSelector:@selector(PipeiEditCellPush)]) {
        
        [self.delegate PipeiEditCellPush];
    }
    
}

//限制输入框字符输入
-(void)limitMaxScore:(UITextField *)textField
{
    
    //1、判断前3三个字符
    if (textField.text.length > 3) {
        
        NSString *shortStr =  [textField.text substringWithRange:NSMakeRange(0, 3)];
        
        if ([shortStr  isEqualToString:@"100"]){
        
            textField.text = @"100";
            
            return;
        }
        
    }
    
    
    
    if ([textField.text containsString:@"."]) {
        
        //分割字符串数组，当出现多个 . 字符时，字符串会被分割成多个数组，超过 2 个时，要删除多出来的 .
        NSArray *items = [textField.text componentsSeparatedByString:@"."];
        
        NSRange pointRange = [textField.text rangeOfString:@"."];
        
        if (items.count > 2) {
            
            textField.text = [textField.text substringWithRange:NSMakeRange(0, pointRange.length  + pointRange.location)];
        }
        
        if (textField.text.length > (pointRange.location + pointRange.length + 2)) {
            
           NSString *shortStr = [textField.text substringWithRange:NSMakeRange(0, pointRange.location + pointRange.length + 2)];
            
           textField.text = shortStr;
         }
        
    }else{
        
        textField.text =  textField.text.floatValue > 100 ?  @"100" : textField.text;
        
    }
    
  
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


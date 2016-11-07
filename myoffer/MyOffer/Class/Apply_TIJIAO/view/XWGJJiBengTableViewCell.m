//
//  XWGJJiBengTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/2/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJJiBengTableViewCell.h"
#import "XWGJPeronInfoItem.h"
#import "XWGJKeyboardToolar.h"

@interface XWGJJiBengTableViewCell()<UITextFieldDelegate,KeyboardToolarDelegate>
@property(nonatomic,strong)UIImageView *RightView;
@end

@implementation XWGJJiBengTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{

    XWGJJiBengTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"JIBEN"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"XWGJJiBengTableViewCell" owner:self options:nil].lastObject;
    }
    
    return cell;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];

    [self addLeftViewWithTextField:self.ContentTF];
    [self addRightViewWithTextField:self.ContentTF];
    self.ContentTF.delegate = self;
    
    
    XWGJKeyboardToolar *tooler =[[NSBundle mainBundle] loadNibNamed:@"XWGJKeyboardToolar" owner:self options:nil].lastObject;
    tooler.delegate = self;
    self.ContentTF.inputAccessoryView = tooler;
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
    self.RightView = mv;
    mv.contentMode = UIViewContentModeScaleAspectFill;
    textField.rightView  = mv;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)setItem:(XWGJPeronInfoItem *)item
{
    _item = item;
    
    self.ItemLab.text = item.placeholder;
    self.ContentTF.text = item.itemName;
    
    
    NSString *ArrowName = !item.Accessory ? @"":@"common_icon_arrow";
    self.RightView.image =   [UIImage imageNamed:ArrowName];
    
}

-(void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    if ( 0 == indexPath.section &&  2 == indexPath.row) {
        
        self.ContentTF.keyboardType = UIKeyboardTypeNumberPad;
        
        [ self.ContentTF addTarget:self action:@selector(limitTextlength:) forControlEvents:UIControlEventEditingChanged];
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(JiBengTableViewCell:withIndexPath:EditedTextField:)]) {
        
        [self.delegate JiBengTableViewCell:self withIndexPath:self.indexPath EditedTextField:textField];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if ([self.delegate respondsToSelector:@selector(JiBengTableViewCell:withIndexPath:textFieldDidBeginEditing:)]) {
        
        [self.delegate JiBengTableViewCell:self withIndexPath:self.indexPath textFieldDidBeginEditing:textField];
    }
}


#pragma mark ----KeyboardToolarDelegate
-(void)KeyboardToolar:(XWGJKeyboardToolar *)toolView didClick:(UIBarButtonItem *)sender
{
    
    if ([self.delegate respondsToSelector:@selector(JiBengTableViewCell:withIndexPath:didClick:)]) {
        
        [self.delegate JiBengTableViewCell:self withIndexPath:self.indexPath didClick:sender];
    }
    
}


-(void)limitTextlength:(UITextField *)textField{
    
    if ([textField.text length] > 11)
    {
        textField.text=[textField.text substringToIndex:11];
    }
}

@end

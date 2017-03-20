//
//  XliuxueTableViewCell.m
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import "WYLXCell.h"
#import "XWGJKeyboardToolar.h"

@interface WYLXCell ()<UITextFieldDelegate,KeyboardToolarDelegate>
@property(nonatomic,strong)XWGJKeyboardToolar *tooler;
@property(nonatomic,strong)NSIndexPath *cellIndexPath;

@end



@implementation WYLXCell

static NSString  *identity = @"liuxue";
+(instancetype)cellWithTableView:(UITableView *)tableView cellForIndexPath:(NSIndexPath *)indexPath
{
    WYLXCell *cell =[tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        
         cell =[[WYLXCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    cell.cellIndexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        XTextField *titleTF =[[XTextField alloc] init];
        [titleTF addTarget:self action:@selector(checkphone:) forControlEvents:UIControlEventEditingChanged];
        titleTF.delegate = self;
        titleTF.inputAccessoryView = self.tooler;
        self.titleTF =  titleTF;
        [self.contentView addSubview:titleTF];

    }
    return self;
}

-(XWGJKeyboardToolar *)tooler
{
    if (!_tooler) {
        
        _tooler =
        
        [[NSBundle mainBundle] loadNibNamed:@"XWGJKeyboardToolar" owner:self options:nil].lastObject;
        
        _tooler.delegate = self;

    }
    return _tooler;
}

#pragma mark —————— UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
     if ([self.delegate respondsToSelector:@selector(XliuxueTableViewCell:withIndexPath:textFieldDidBeginEditing:)]) {
         
         [self.delegate XliuxueTableViewCell:self withIndexPath:self.cellIndexPath textFieldDidBeginEditing:textField];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(XliuxueTableViewCell:withIndexPath:textFieldDidEndEditing:)]) {
        
        [self.delegate XliuxueTableViewCell:self withIndexPath:self.cellIndexPath textFieldDidEndEditing:textField];
    }
 
}


#pragma mark ----KeyboardToolarDelegate
-(void)KeyboardToolar:(XWGJKeyboardToolar *)toolView didClick:(UIBarButtonItem *)sender
{
    
    if ([self.delegate respondsToSelector:@selector(XliuxueTableViewCell:withIndexPath:didClick:)]) {
        
         [self.delegate XliuxueTableViewCell:self withIndexPath:self.cellIndexPath didClick:sender];
    }
    
}

- (void)checkphone:(UITextField *)textField{

    if (self.cellIndexPath.section == 1 && textField.text.length > 11) {
        
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 11)];
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize =  self.bounds.size;
    CGFloat titlex = ITEM_MARGIN;
    CGFloat titley = 0;
    CGFloat titlew = contentSize.width - 30;
    CGFloat titleh = contentSize.height;
    self.titleTF.frame = CGRectMake(titlex, titley, titlew, titleh);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

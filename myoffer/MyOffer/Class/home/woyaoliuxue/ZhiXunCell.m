//
//  ZhiXunCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/5/22.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ZhiXunCell.h"
#import "XWGJKeyboardToolar.h"

@interface ZhiXunCell ()<UITextFieldDelegate>

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIView *spod;
@property(nonatomic,strong)NSIndexPath *indexPath;

@end

@implementation ZhiXunCell
static NSString  *identity = @"liuxue";
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    ZhiXunCell *cell =[tableView dequeueReusableCellWithIdentifier:identity];
    
    if (!cell) {
        
        cell =[[ZhiXunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self makeUI];
    }
    
    return self;
}

- (void)makeUI{

    UILabel *titleLab = [[UILabel alloc] init];
    [self.contentView addSubview:titleLab];
    titleLab.font = XFONT(14);
    titleLab.textColor = XCOLOR_TITLE;
    self.titleLab = titleLab;
    
    UITextField *inputTF = [[UITextField alloc] init];
    [self.contentView addSubview:inputTF];
    [inputTF setFont:XFONT(18)];
    self.inputTF = inputTF;
    inputTF.delegate = self;

    
    UIView *line = [[UIView alloc] init];
    [self.contentView addSubview:line];
    line.backgroundColor = XCOLOR_line;
    self.line = line;
    self.line.layer.shadowColor = XCOLOR_LIGHTBLUE.CGColor;
    self.line.layer.shadowOffset = CGSizeMake(0, -1);
    
    UIView *spod = [[UIView alloc] init];
    [self.contentView addSubview:spod];
    spod.backgroundColor = XCOLOR_line;
    self.spod = spod;
    spod.layer.cornerRadius = 5;
    spod.layer.masksToBounds = YES;
    
    XWGJKeyboardToolar *tooler = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XWGJKeyboardToolar class]) owner:self options:nil].lastObject;
    inputTF.inputAccessoryView = tooler;

    XWeakSelf
    tooler.actionBlock = ^(NSString *flag){
        
        if ([flag isEqualToString:@"收起"]) {
            
            [weakSelf.inputTF resignFirstResponder];
            
        }else{
            
            [weakSelf toolerOnClick];
        
        }
        
    };
    
}


- (void)setGroup:(WYLXGroup *)group{

    _group = group;
    
    self.titleLab.text = group.title;
    self.inputTF.placeholder = group.placeHolder;
    self.spod.hidden = !group.spod;
    
    
    self.titleLab.frame = group.titleFrame;
    self.inputTF.frame = group.inputFrame;
    self.line.frame = group.lineFrame;
    self.spod.frame = group.spodFrame;
}




#pragma mark : UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self inputTextFieldOnEditing:YES];
    
    if ([self.delegate respondsToSelector:@selector(zixunCell:indexPath:textFieldDidBeginEditing:)]) {
        
        [self.delegate zixunCell:self indexPath:self.indexPath textFieldDidBeginEditing:self.inputTF];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self inputTextFieldOnEditing:NO];

    if ([self.delegate respondsToSelector:@selector(zixunCell:indexPath:textFieldDidEndEditing:)]) {
        
        [self.delegate zixunCell:self indexPath:self.indexPath textFieldDidEndEditing:self.inputTF];
    }
    
}


- (void)toolerOnClick{

    if ([self.delegate respondsToSelector:@selector(zixunCell:indexPath:didClickWithTextField:)]) {
        
        [self.delegate zixunCell:self indexPath:self.indexPath didClickWithTextField:self.inputTF];
    }
  
}

- (void)inputTextFieldOnEditing:(BOOL)edit{

    self.line.backgroundColor = edit ? XCOLOR_LIGHTBLUE : XCOLOR_line;
    
    self.line.layer.shadowOpacity = edit ? 1 : 0;
    
}


//-(void)dealloc{
//    
//    KDClassLog(@"我要留学  ZhiXunCell dealloc");
//}



@end

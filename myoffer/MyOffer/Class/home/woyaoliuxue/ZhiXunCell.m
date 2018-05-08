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

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    ZhiXunCell *cell = [[ZhiXunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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
    [inputTF setTintColor:XCOLOR_LIGHTBLUE];
    
    UIView *line = [[UIView alloc] init];
    [self.contentView addSubview:line];
    line.backgroundColor = XCOLOR_line;
    self.line = line;
    self.line.layer.shadowColor = XCOLOR_LIGHTBLUE.CGColor;
    self.line.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIView *spod = [[UIView alloc] init];
    [self.contentView addSubview:spod];
    spod.backgroundColor = XCOLOR_line;
    self.spod = spod;
    spod.layer.cornerRadius = 5;
    spod.layer.masksToBounds = YES;
    
    XWGJKeyboardToolar *tooler = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XWGJKeyboardToolar class]) owner:self options:nil].lastObject;
    inputTF.inputAccessoryView = tooler;

    WeakSelf
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
    self.inputTF.text = group.content;

    
    self.titleLab.frame = group.titleFrame;
    self.inputTF.frame = group.inputFrame;
    self.line.frame = group.line_bottom_Frame;
    self.spod.frame = group.spodFrame;
    
    
    //监听分数输入框
    if (group.groupType == EditTypeSCore) {
        
        [self.inputTF addTarget:self action:@selector(limitMaxScore:) forControlEvents:UIControlEventEditingChanged];
        
    }
 
}




#pragma mark : UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
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





//-(void)dealloc{
//
//    KDClassLog(@"我要留学  ZhiXunCell dealloc");
//}



@end

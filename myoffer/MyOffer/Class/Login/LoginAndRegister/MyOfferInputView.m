//
//  MyOfferInputView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/5/25.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MyOfferInputView.h"
#import "XWGJKeyboardToolar.h"

@interface MyOfferInputView ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIView *spod;
@property(nonatomic,strong)UITextField *areaCodeTF;
@property(nonatomic,strong)UIView *line_areaCode;
@property(nonatomic,strong)UILabel *areaCodeLab;
@property(nonatomic,strong)NSArray *areaArr;
@property(nonatomic,strong)UIPickerView *areaPicker;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSUInteger timerCount;

@end

@implementation MyOfferInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XCOLOR_WHITE;
        
        [self makeUI];
        
    }
    return self;
}

-(NSArray *)areaArr
{
    if (!_areaArr) {
        
        _areaArr = @[@"中国(+86)",@"英国(+44)",@"马来西亚(+60)"];
    }
    return _areaArr;
}

- (UIPickerView *)areaPicker{

    if (!_areaPicker) {
        
        _areaPicker =[[UIPickerView alloc] init];
        _areaPicker.delegate =self;
        _areaPicker.dataSource =self;
        [_areaPicker selectRow:0 inComponent:0 animated:YES];
       
    }
    
    return _areaPicker;
}


- (void)makeUI{
    
    UILabel *titleLab = [[UILabel alloc] init];
    [self addSubview:titleLab];
    titleLab.font = XFONT(14);
    titleLab.textColor = XCOLOR_TITLE;
    self.titleLab = titleLab;
    
    UITextField *inputTF = [[UITextField alloc] init];
    [self addSubview:inputTF];
    [inputTF setFont:XFONT(18)];
    self.inputTF = inputTF;
    inputTF.delegate = self;
    
    UITextField *areaCodeTF = [[UITextField alloc] init];
    [self addSubview:areaCodeTF];
    [areaCodeTF setFont:XFONT(18)];
    self.areaCodeTF = areaCodeTF;
    self.areaCodeTF.inputView =self.areaPicker;
    
    
    UIView *line_code = [[UIView alloc] init];
    [self addSubview:line_code];
    line_code.backgroundColor = XCOLOR_line;
    self.line_areaCode = line_code;
    
    UILabel *areaCodeLab = [[UILabel alloc] init];
    self.areaCodeLab = areaCodeLab;
    [self addSubview:areaCodeLab];
    areaCodeLab.text = @"+86";
    areaCodeLab.textAlignment =NSTextAlignmentCenter;
    areaCodeLab.textColor = XCOLOR_SUBTITLE;
    areaCodeLab.layer.cornerRadius = CORNER_RADIUS;
    areaCodeLab.layer.masksToBounds = YES;
    areaCodeLab.backgroundColor = XCOLOR_BG;
    
    UIButton *rightBtn = [UIButton new];
    [rightBtn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    [self addSubview:rightBtn];
    self.rightBtn.titleLabel.font = XFONT(14);
    
    
    UIView *line = [[UIView alloc] init];
    [self addSubview:line];
    line.backgroundColor = XCOLOR_line;
    self.line = line;
    self.line.layer.shadowColor = XCOLOR_LIGHTBLUE.CGColor;
    self.line.layer.shadowOffset = CGSizeMake(0, -1);
    
    UIView *spod = [[UIView alloc] init];
    [self addSubview:spod];
    spod.backgroundColor = XCOLOR_line;
    self.spod = spod;
    spod.layer.cornerRadius = 5;
    spod.layer.masksToBounds = YES;
    
 
    
}

- (void)setGroup:(WYLXGroup *)group{
    
    _group = group;
    
    self.titleLab.text = group.title;
    self.inputTF.placeholder = group.placeHolder;
    self.spod.hidden = !group.spod;
    self.inputTF.text = group.content;
    
    
    self.titleLab.frame = group.titleFrame;
    self.inputTF.frame = group.inputFrame;
    self.line.frame = group.lineFrame;
    self.spod.frame = group.spodFrame;
    
    self.rightBtn.frame = group.rightBttonFrame;
    
    
   if (group.groupType == EditTypeVerificationCode) {
        
        [self.rightBtn setTitleColor:XCOLOR_Disable forState:UIControlStateDisabled];
        [self.rightBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.rightBtn.layer.cornerRadius = 4;
        self.rightBtn.layer.borderWidth = 1;
        self.inputTF.keyboardType = UIKeyboardTypeNumberPad;
        self.rightBtn.enabled = NO;
        [self updateRightButton:self.rightBtn];
       
        
    }else if (group.groupType == EditTypePasswd) {
        
        [self.rightBtn setImage:XImage(@"hidepassword") forState:UIControlStateNormal];
        [self.rightBtn setImage:XImage(@"showpassword") forState:UIControlStateSelected];
        self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        self.inputTF.secureTextEntry = YES;
        
    }else if (group.groupType == EditTypeRegistPhone){
    
        
        self.areaCodeTF.frame = group.areacodeTFFrame;
        self.line_areaCode.frame = group.areacodeLineFrame;
        self.areaCodeLab.frame = group.areacodeLableFrame;
        self.inputTF.keyboardType = UIKeyboardTypeNumberPad;
//        self.inputTF.clearButtonMode = UITextFieldViewModeAlways;
        
    }
    
    
    
    
 
}

- (void)toolerOnClick{
    
//    if ([self.delegate respondsToSelector:@selector(zixunCell:indexPath:didClickWithTextField:)]) {
//        
//        [self.delegate zixunCell:self indexPath:self.indexPath didClickWithTextField:self.inputTF];
//    }
    
}


#pragma mark : UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self inputTextFieldOnEditing:YES];
    
    if ([self.delegate respondsToSelector:@selector(cell:textFieldDidBeginEditing:)]) {
        
        [self.delegate cell:self textFieldDidBeginEditing:self.inputTF];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self inputTextFieldOnEditing:NO];
    
    if ([self.delegate respondsToSelector:@selector(cell:textFieldDidEndEditing:)]) {
        
        [self.delegate cell:self textFieldDidEndEditing:self.inputTF];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    NSLog(@">>>>>shouldChangeCharactersInRange>>>>>>>> [-%@-] [-%@-]  %d  %d",textField.text,string,range.length,range.location);
    
    if ([self.delegate respondsToSelector:@selector(cell:shouldChangeCharacters:)]) {
        
        NSString *content = [NSString stringWithFormat:@"%@%@",textField.text,string];

        if (string.length == 0 && range.location == 0) {
            
            content = @"";
        }
        
        [self.delegate cell:self shouldChangeCharacters:content];
    }
    
    
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(cell:textFieldShouldReturn:)]) {
        
        [self.delegate cell:self textFieldShouldReturn:self.inputTF];

    }
    
    
    return YES;
}



- (void)inputTextFieldOnEditing:(BOOL)edit{
    
    self.line.backgroundColor = edit ? XCOLOR_LIGHTBLUE : XCOLOR_line;
    
    self.line.layer.shadowOpacity = edit ? 1 : 0;
        
    
}



- (void)rightButtonClick:(UIButton *)sender{

    if (self.group.groupType == EditTypePasswd) {
        
        sender.selected = !sender.selected;
        
        self.inputTF.secureTextEntry = !self.inputTF.secureTextEntry;
    }
    
    
    if (self.group.groupType == EditTypeVerificationCode) {
        
        if ([self.delegate respondsToSelector:@selector(sendVertificationCodeWithCell:)]) {
            
            [self.delegate sendVertificationCodeWithCell:self];
        }
  
     }
    
}



#pragma mark : UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.areaArr.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.areaArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *code = self.areaArr[row];
    NSString *codeStr = [code componentsSeparatedByString:@"+"].lastObject;
    NSString *areaCode = [codeStr substringWithRange:NSMakeRange(0, codeStr.length - 1)];
    self.areaCodeLab.text = [NSString stringWithFormat:@"+%@",areaCode];
    self.group.areaCode = areaCode;
    
}

//当点击提交按钮时添加数据到 模型中

- (void)checKTextFieldWithGroupValue{

    self.group.content = self.inputTF.text;
    
    
}

- (void)verifyCodeCountDown{
    

    NSInteger count = self.timerCount--;
    
    NSString *title = count >=10 ? [NSString stringWithFormat:@"%ld 秒",count] : [NSString stringWithFormat:@"0%ld 秒",count] ;
    
    if(count <= 0){
    
        
        [self.timer invalidate];
        self.timer = nil;
        
        self.rightBtn.enabled = YES;
        [self updateRightButton:self.rightBtn];
        
        title = @"获取验证码";
    }
    
    [self.rightBtn setTitle:title forState:UIControlStateNormal];
  
}

- (void)updateRightButton:(UIButton *)sender{
    
    UIColor *color = sender.enabled ? XCOLOR_LIGHTBLUE : XCOLOR_Disable;
    sender.layer.borderColor = color.CGColor;

    
}

- (void)changeVertificationCodeButtonEnable:(BOOL)enable{

    self.rightBtn.enabled = enable;
    
    [self updateRightButton:self.rightBtn];
}

- (void)vertificationTimerShow:(BOOL)show{
    
    self.rightBtn.enabled = !show;
    
    [self updateRightButton:self.rightBtn];

    if (show) {
        
        
        self.timerCount = 60;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(verifyCodeCountDown) userInfo:nil repeats:YES];
        
        return;
    
    }else{
        
      
        [self.timer invalidate];
         self.timer = nil;
        
    }
    
  
}



- (void)dealloc{
    
    [self.timer invalidate];
    self.timer = nil;
    
    NSLog(@"MyOfferInputView  dealloc ");
    
}


@end

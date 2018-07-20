//
//  MyOfferInputView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/5/25.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MyOfferInputView.h"
#import "XWGJKeyboardToolar.h"
#import "MyofferWeakTimer.h"

@interface MyOfferInputView ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UILabel *titleLab;//标题
@property(nonatomic,strong)UIButton *getcodeBtn;//获取验证码按钮
@property(nonatomic,strong)UIView *line_bottom;//下划线
@property(nonatomic,strong)UITextField *areaCodeTF;//地区输入框
@property(nonatomic,strong)UIView *line_areaCode;//地区显示分隔线
@property(nonatomic,strong)UILabel *areaCodeLab;//地区显示标签
@property(nonatomic,strong)UIView *spod;
@property(nonatomic,strong)NSArray *areaCodes;
@property(nonatomic,strong)UIPickerView *areaPicker;
@property(nonatomic,strong)MyofferWeakTimer *weakTimer;
@property(nonatomic,assign)NSUInteger timerCount;
@property(nonatomic,strong)XWGJKeyboardToolar *tooler;

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

-(NSArray *)areaCodes
{
    if (!_areaCodes) {
        
        _areaCodes = @[@"中国(+86)",@"英国(+44)",@"马来西亚(+60)"];
    }
    return _areaCodes;
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
    
    //标题
    UILabel *titleLab = [[UILabel alloc] init];
    [self addSubview:titleLab];
    titleLab.font = XFONT(14);
    titleLab.textColor = XCOLOR_TITLE;
    self.titleLab = titleLab;
    
    //输入框
    UITextField *inputTF = [[UITextField alloc] init];
    [inputTF setTintColor:XCOLOR_LIGHTBLUE];
    [self addSubview:inputTF];
    [inputTF setFont:XFONT(18)];
    self.inputTF = inputTF;
    inputTF.delegate = self;
    
    //选择地区输入框
    UITextField *areaCodeTF = [[UITextField alloc] init];
    [self addSubview:areaCodeTF];
    self.areaCodeTF = areaCodeTF;
    self.areaCodeTF.inputView =self.areaPicker;
    
    
    //分隔线
    UIView *line = [[UIView alloc] init];
    [self addSubview:line];
    line.backgroundColor = XCOLOR_line;
    self.line_bottom = line;
    line.layer.shadowColor = XCOLOR_WHITE.CGColor;
    line.layer.shadowOffset = CGSizeMake(0, 0);
    line.layer.shadowOpacity =  1;
    
    //有时候要显示提示图标
    UIView *spod = [[UIView alloc] init];
    [self addSubview:spod];
    spod.backgroundColor = XCOLOR_line;
    self.spod = spod;
    spod.layer.cornerRadius = 5;
    spod.layer.masksToBounds = YES;
    
}

- (UIView *)line_areaCode{
    
    if (!_line_areaCode) {
        //选择地区输入框分隔线
        UIView *line_code = [[UIView alloc] init];
        line_code.backgroundColor = XCOLOR_line;
        _line_areaCode = line_code;
    }
    
    return _line_areaCode;
}


- (UIButton *)getcodeBtn{
    
    if (!_getcodeBtn) {
        
        //根据情况提示按钮点击功能
        UIButton *getcodeBtn = [UIButton new];
        [getcodeBtn addTarget:self action:@selector(getCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _getcodeBtn = getcodeBtn;
        getcodeBtn.titleLabel.font = XFONT(14);
        getcodeBtn.backgroundColor = XCOLOR_WHITE;

    }
    
    return _getcodeBtn;
}

- (UILabel *)areaCodeLab{
    
    if(!_areaCodeLab){
    
        //显示地区
        UILabel *areaCodeLab = [[UILabel alloc] init];
        _areaCodeLab = areaCodeLab;
        areaCodeLab.text = @"+86";
        areaCodeLab.textAlignment =NSTextAlignmentCenter;
        areaCodeLab.textColor = XCOLOR_SUBTITLE;
        areaCodeLab.layer.cornerRadius = CORNER_RADIUS;
        areaCodeLab.layer.masksToBounds = YES;
        areaCodeLab.backgroundColor = XCOLOR_BG;
        
    }
    
    return _areaCodeLab;
}




- (XWGJKeyboardToolar *)tooler{

    if (!_tooler) {
        
       _tooler = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XWGJKeyboardToolar class]) owner:self options:nil].lastObject;
        
        WeakSelf
        _tooler.actionBlock = ^(NSString *flag){
            
            if ([flag isEqualToString:@"收起"]) {
                
                [weakSelf.areaCodeTF resignFirstResponder];
                [weakSelf.inputTF resignFirstResponder];
                
            }else{
                
                [weakSelf toolerOnClick];
                
            }
            
        };
    }
    
    return _tooler;
}


- (void)setGroup:(WYLXGroup *)group{
    
    _group = group;
    
    self.titleLab.text = group.title;
    self.inputTF.placeholder = group.placeHolder;
    self.spod.hidden = !group.spod;
    self.inputTF.text = group.content;
    
    
    self.titleLab.frame = group.titleFrame;
    self.inputTF.frame = group.inputFrame;
    self.line_bottom.frame = group.line_bottom_Frame;
    self.spod.frame = group.spodFrame;
    self.getcodeBtn.frame = group.rightBttonFrame;
    
    //验证码
   if (group.groupType == EditTypeVerificationCode) {
       
       [self.getcodeBtn setTitleColor:XCOLOR_Disable forState:UIControlStateDisabled];
       [self.getcodeBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
       [self.getcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
       self.getcodeBtn.layer.cornerRadius = 4;
       self.getcodeBtn.layer.borderWidth = 1;
       
       [self addSubview:self.getcodeBtn];
       
        self.inputTF.keyboardType = UIKeyboardTypeNumberPad;
        [self updateRightButtonStatusEnable:NO];
        self.inputTF.inputAccessoryView = self.tooler;

    //手机输入框
   }else if (group.groupType == EditTypePhone) {
      
       self.inputTF.keyboardType = UIKeyboardTypeEmailAddress;
       self.inputTF.clearButtonMode = UITextFieldViewModeAlways;

    //密码
   }else if (group.groupType == EditTypePasswd) {
       
        [self addSubview:self.getcodeBtn];
        [self.getcodeBtn setBackgroundImage:XImage(@"hide_password")forState:UIControlStateNormal];
        [self.getcodeBtn setBackgroundImage:XImage(@"show_password")forState:UIControlStateSelected];
        self.getcodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.inputTF.secureTextEntry = YES;
    
    //注册手机号
    }else if (group.groupType == EditTypeRegistPhone || group.groupType == EditTypeShortMessageLoginPhone){
        
        self.inputTF.inputAccessoryView = self.tooler;
        self.areaCodeTF.frame = group.areacodeTFFrame;
        [self addSubview:self.areaCodeTF];
        self.line_areaCode.frame = group.areacodeLineFrame;
        [self addSubview:self.line_areaCode];
        self.areaCodeLab.frame = group.areacodeLableFrame;
        [self addSubview:self.areaCodeLab];
        self.inputTF.keyboardType = UIKeyboardTypeNumberPad;
        self.inputTF.clearButtonMode = UITextFieldViewModeAlways;

        self.areaCodeTF.delegate = self;
        self.areaCodeTF.inputAccessoryView = self.tooler;
        
    }

    
}



#pragma mark : UITextFieldDelegate
//开始输入
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self inputTextFieldOnEditing:YES];
    
    if ([self.delegate respondsToSelector:@selector(cell:textFieldDidBeginEditing:)]) {
        
        [self.delegate cell:self textFieldDidBeginEditing:self.inputTF];
    }
    
}

//结束输入
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self inputTextFieldOnEditing:NO];
    
    if ([self.delegate respondsToSelector:@selector(cell:textFieldDidEndEditing:)]) {
        
        [self.delegate cell:self textFieldDidEndEditing:self.inputTF];
    }
    
}
//监听输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *content = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    //监听注册手机号输入
    if (self.group.groupType == EditTypeRegistPhone || self.group.groupType == EditTypeShortMessageLoginPhone) {
     
        if ([self.delegate respondsToSelector:@selector(cell:shouldChangeCharacters:)]) {
          
            //输入框被清空时
            if (string.length == 0 && range.location == 0) content = @"";
            
            [self.delegate cell:self shouldChangeCharacters:content];
            
        }
        
    }
 
    //验证码
    if (self.group.groupType == EditTypeVerificationCode) {
    
        //验证码输入个数
          content.length > 10 ?self.inputTF.text = [content substringWithRange:NSMakeRange(0, 10)] : @"";

    }

    
    //密码输入框
    if (self.group.groupType == EditTypePasswd) {
        
        //监听登录密码输入位数
        content.length > 16 ?self.inputTF.text = [content substringWithRange:NSMakeRange(0, 16)] : @"";
        
    }
    
    
    
    
    return YES;
}

//回车键
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if ([self.delegate respondsToSelector:@selector(cell:textFieldShouldReturn:)]) {
        
        [self.delegate cell:self textFieldShouldReturn:self.inputTF];
        
    }
    
    return YES;
}


//监听清空按钮
- (BOOL)textFieldShouldClear:(UITextField *)textField{
  
    if (self.group.groupType == EditTypeRegistPhone &&[self.delegate respondsToSelector:@selector(cell:shouldChangeCharacters:)]) {
        
        [self.delegate cell:self shouldChangeCharacters:@""];
    }

    
    return YES;
}

// 点击  下一个按钮方法
- (void)toolerOnClick{
    
    
    if (self.areaCodeTF.editing) {
        
        [self.inputTF becomeFirstResponder];
        
        return;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(inputAccessoryViewClickWithCell:)]) {
        
        [self.delegate inputAccessoryViewClickWithCell:self];
    }
    
}



//设置输入框在激活状态下显示效果
- (void)inputTextFieldOnEditing:(BOOL)edit{
    
    self.line_bottom.backgroundColor = edit ? XCOLOR_LIGHTBLUE : XCOLOR_line;
   
    self.line_bottom.layer.shadowColor = edit ?  XCOLOR_LIGHTBLUE.CGColor : XCOLOR_WHITE.CGColor;
    
}


- (void) getCodeButtonClick:(UIButton *)sender{

    //是否显示密码按钮点击
    if (self.group.groupType == EditTypePasswd) {
        
        sender.selected = !sender.selected;
        
        self.inputTF.secureTextEntry = !self.inputTF.secureTextEntry;
    }
    
    //验证码点击
    if ((self.group.groupType == EditTypeVerificationCode) && [self.delegate respondsToSelector:@selector(sendVertificationCodeWithCell:)]) {
        
        [self.delegate sendVertificationCodeWithCell:self];
    }

      
    
}

#pragma mark : UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.areaCodes.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.areaCodes[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *code = self.areaCodes[row];
    NSString *codeStr = [code componentsSeparatedByString:@"+"].lastObject;
    NSString *areaCode = [codeStr substringWithRange:NSMakeRange(0, codeStr.length - 1)];
    self.areaCodeLab.text = [NSString stringWithFormat:@"+%@",areaCode];
    
    self.group.areaCode = areaCode;
    
}

//当点击提交按钮时添加数据到 模型中
- (void)checKTextFieldWithGroupValue{

    self.group.content = self.inputTF.text;
    
}

//更新获取验证码的状态
- (void)updateRightButtonStatusEnable:(BOOL)enable{
    
    if (self.getcodeBtn.enabled == enable) return;
    
    self.getcodeBtn.enabled = enable;
    
    UIColor *color = self.getcodeBtn.enabled ? XCOLOR_LIGHTBLUE : XCOLOR_Disable;
    
    self.getcodeBtn.layer.borderColor = color.CGColor;
    
    if (enable)  [self.getcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
}

//外部监听点击事件改显按钮状态
- (void)changeVertificationCodeButtonEnable:(BOOL)enable{
    
    [self updateRightButtonStatusEnable:enable];
    
}

//是否显示倒计时
- (void)vertificationTimerShow:(BOOL)show{
    
    [self updateRightButtonStatusEnable:!show];
 
    if (self.weakTimer) [self timerClear];

    if (show) {
         self.timerCount = 60;
         MyofferWeakTimer *weakTimer = [MyofferWeakTimer objWithTimeInterval:1 target:self selector:@selector(verifyCodeCountDown)];
         self.weakTimer = weakTimer;
        return;
    }
    
   
}

//倒计时
- (void)verifyCodeCountDown{

    NSInteger count = self.timerCount--;
    NSString *title = count >=10 ? [NSString stringWithFormat:@"%ld 秒",(long)count] : [NSString stringWithFormat:@"0%ld 秒",count] ;
    [self.getcodeBtn setTitle:title forState:UIControlStateNormal];
    if(count <= 0){
        [self updateRightButtonStatusEnable:YES];
        [self timerClear];
    }

}

//清空timer
- (void)timerClear{
    
    if (self.weakTimer) {
        [self.weakTimer.timer invalidate];
        self.weakTimer.timer = nil;
    }
   
}

- (void)dealloc{
    
    [self timerClear];
 
}


@end

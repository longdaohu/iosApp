//
//  EmptyDataView.m
//
//  Created by xuewuguojie on 2016/12/23.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import "EmptyDataView.h"


@interface EmptyDataView ()
@property(nonatomic,strong)UIImageView *logoView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *messageLab;
@property(nonatomic,strong)UIButton *reloadBtn;
@end


@implementation EmptyDataView

+ (instancetype)emptyViewWithBlock:(EmptyDataViewBlock)actionBlock{
    
    EmptyDataView *empty = [[EmptyDataView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 250)];
    empty.actionBlock = actionBlock;
    
    return empty;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
        UIImageView *logoView = [[UIImageView alloc] init];
        logoView.clipsToBounds = YES;
        logoView.contentMode = UIViewContentModeScaleAspectFit;
        logoView.image = [UIImage imageNamed:@"no_message"];
        [self addSubview:logoView];
        self.logoView = logoView;
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = NetRequest_NoDATA;
        titleLab.textColor = XCOLOR_BLACK;
        titleLab.font = [UIFont boldSystemFontOfSize:14];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLab];
        self.titleLab = titleLab;

        UILabel *messageLab = [[UILabel alloc] init];
        messageLab.text = NetRequest_NoDATA;
        messageLab.numberOfLines = 0;
        messageLab.textColor = XCOLOR_SUBTITLE;
        messageLab.font = [UIFont systemFontOfSize:12];
        messageLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:messageLab];
        self.messageLab = messageLab;

        UIButton *reloadBtn = [UIButton new];
        [reloadBtn setTitle:@"点击加载" forState:UIControlStateNormal];
        [reloadBtn setBackgroundImage:XImage(@"button_blue_nomal") forState:UIControlStateNormal];
        [reloadBtn setBackgroundImage:XImage(@"button_blue_highlight") forState:UIControlStateHighlighted];
        reloadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:reloadBtn];
        [reloadBtn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
        self.reloadBtn = reloadBtn;
        reloadBtn.layer.shadowColor = XCOLOR_LIGHTBLUE.CGColor;
        reloadBtn.layer.shadowOffset = CGSizeMake(0, 3);
        reloadBtn.layer.shadowOpacity = 0.5;
     
    }
    return self;
}

- (void)reload{
    
    if (self.actionBlock) {
         self.actionBlock();
    };
    
}

- (void)setAlertMessage:(NSString *)alertMessage{
    
    _alertMessage = alertMessage;
    
    self.messageLab.text = alertMessage;
}


- (void)setAlertTitle:(NSString *)alertTitle{

    _alertTitle = alertTitle;
    
    self.titleLab.text = alertTitle;
}

- (void)setButtonTitle:(NSString *)buttonTitle{
    
    _buttonTitle = buttonTitle;
    [self.reloadBtn setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [self.logoView setImage:[UIImage imageNamed:imageName]];
}

- (void)setAlertType:(TableViewAlertType)alertType{
    _alertType = alertType;
    
    if (alertType == TableViewAlertTypeReload) {
        self.messageLab.hidden = NO;
        self.reloadBtn.hidden = NO;
    }else{
        self.messageLab.hidden = YES;
        self.reloadBtn.hidden = YES;
    }
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize content_size = self.bounds.size;
    
    CGFloat logo_X = 20;
    CGFloat logo_Y = 0;
    CGFloat logo_W = content_size.width - logo_X * 2;
    CGFloat logo_H = 145;
    self.logoView.frame = CGRectMake(logo_X, logo_Y, logo_W, logo_H);
    
    CGFloat title_X = logo_X;
    CGFloat title_Y = CGRectGetMaxY(self.logoView.frame);
    CGFloat title_W = logo_W;
    CGFloat title_H = 16;
    self.titleLab.frame = CGRectMake(title_X, title_Y, title_W, title_H);
    
    CGFloat message_X = title_X;
    CGFloat message_Y = CGRectGetMaxY(self.titleLab.frame) + 5;
    CGFloat message_W = title_W;
    CGSize  message_size = [self.messageLab.text sizeWithfontSize:12 maxWidth:message_W];
    CGFloat message_H = message_size.height;
    self.messageLab.frame = CGRectMake(message_X, message_Y, message_W, message_H);

    CGFloat btn_W = 120;
    CGFloat btn_X = (content_size.width - btn_W) * 0.5;
    CGFloat btn_Y =  CGRectGetMaxY(self.messageLab.frame) + 18;
    CGFloat btn_H = 35;
    self.reloadBtn.frame = CGRectMake(btn_X, btn_Y, btn_W, btn_H);
   
    if (self.alertType == TableViewAlertTypeReload) {
        
        self.messageLab.hidden = NO;
        self.reloadBtn.hidden = NO;
        
    }else{
        
        self.messageLab.hidden = YES;
        self.reloadBtn.hidden = YES;
    }
    
}


@end


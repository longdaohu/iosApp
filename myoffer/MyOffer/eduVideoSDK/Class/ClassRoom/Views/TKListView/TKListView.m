//
//  TKListView.m
//  EduClass
//
//  Created by lyy on 2018/4/23.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKListView.h"
#import <QuartzCore/QuartzCore.h>
#import "TKListButton.h"
#import "TKDocumentListView.h"

#define ThemeKP(args) [@"TKListView." stringByAppendingString:args]

@interface TKListView ()<TKDocumentListDelegate>

@property (nonatomic, strong) UIView       * backView;
@property (nonatomic, strong) UILabel      * titleLabel;

@property (nonatomic, strong) TKListButton * coursewareListButton;//课件库按钮
@property (nonatomic, strong) TKListButton * mediaListButton;//媒体库按钮
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) TKDocumentListView *documentListView;//课件库
@property (nonatomic, strong) TKDocumentListView *mediaListView;//媒体库

@end

@implementation TKListView

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title from:(NSString *)from
{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat screenWidth = [TKUtil isiPhoneX]?ScreenW-60:ScreenW;
        CGFloat weight1 = (screenWidth-10*(7+1))/7;
        CGFloat height1 =  weight1/4.0*3.0+weight1/4*3/7;
        
        CGFloat navH = height1 *0.4;
        CGFloat tabarH = [TKUtil isiPhoneX]?(height1) * 0.4+17:height1 * 0.4;
        
        
        if (!self.backView) {
            if ([from isEqualToString:@"TKOneToMoreRoomController"] || [from isEqualToString:@"TKOneToOneRoomController"]) {
                self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - tabarH)];
            }else if ([from isEqualToString:@"RoomController"]) {
                self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, navH, ScreenW, ScreenH)];
            }
            
//            self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
            self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
            self.backView.alpha = 0;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(touchOutSide)];
//            [self.backView addGestureRecognizer: tap];
            
        }
        self.backgroundColor = [UIColor clearColor];
      
        CGFloat courseH = self.height/6;
        CGFloat courseY = (self.height - (courseH * 2)-30)/2.0;
        //课件库按钮
        _coursewareListButton = ({
            TKListButton *button = [TKListButton buttonWithType:(UIButtonTypeCustom)];
            [self initButton:button withTitle:MTLocalized(@"Title.DocumentList") defaultImageName:ThemeKP(@"selector_library_default") selectImageName:ThemeKP(@"selector_library_select") addTag:FileListTypeDocument];
            button.frame = CGRectMake(0, courseY, self.height/6, courseH);
            [self addSubview:button];
            button.selected = YES;
            
            [button addTarget:self action:@selector(listButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            button;
        });
        
        //媒体库按钮
        _mediaListButton = ({
            TKListButton *button = [TKListButton buttonWithType:(UIButtonTypeCustom)];
            [self initButton:button withTitle:MTLocalized(@"Title.MediaList") defaultImageName:ThemeKP(@"selector_media_default") selectImageName:ThemeKP(@"selector_media_select") addTag:FileListTypeAudioAndVideo];
            button.frame = CGRectMake(0, CGRectGetMaxY(_coursewareListButton.frame)+30, CGRectGetWidth(_coursewareListButton.frame), CGRectGetHeight(_coursewareListButton.frame));
            [self addSubview:button];
            button.selected = NO;
            [button addTarget:self action:@selector(listButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            button;
        });
        

        //设置字体大小
        [self resetFont];
        
        //背景图片
        if (!self.backImageView) {
            self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.height/6-10, 0, self.frame.size.width-(self.height/6-10), self.height)];
            self.backImageView.sakura.image(ThemeKP(@"Library_frame"));
            self.backImageView.userInteractionEnabled = YES;
        }
        
        [self addSubview:self.backImageView];
        
        
       
        _contentView = [[UIView alloc]init];
        [self.backImageView addSubview:_contentView];
        
        _contentView.frame = CGRectMake(CGRectGetWidth(_backImageView.frame)*0.06, self.height*0.14, CGRectGetWidth(_backImageView.frame)*0.88, CGRectGetHeight(_backImageView.frame)*0.8);
        
        //标题空间
        if (!self.titleLabel) {
            
            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _backImageView.width, _backImageView.height*0.12)];
            [self.backImageView addSubview:self.titleLabel];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.sakura.textColor(ThemeKP(@"titleColor"));
            
        }
        
        //关闭按钮
        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        xButton.sakura.image(ThemeKP(@"btn_close"),UIControlStateNormal);
        
        //        xButton.frame = CGRectMake(CGRectGetWidth(self.backImageView.frame)-40, 10, 30, 30);
        CGFloat height = CGRectGetMinY(_contentView.frame)/2.0;
        
        xButton.frame = CGRectMake(self.backImageView.width-height-height/4.0, height/4.0, height, height);
        
        [self.backImageView addSubview:xButton];
        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        
        _mediaListView = [[TKDocumentListView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame))];
        _mediaListView.documentDelegate = self;
        [_contentView addSubview:_mediaListView];
        
        __block typeof(self) weakSelf = self;
        _mediaListView.titleBlock = ^(NSString *title) {
            weakSelf.titleLabel.text = title;
        };
        
        
        
        _documentListView = [[TKDocumentListView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame))];
        [_contentView addSubview:_documentListView];
        _documentListView.documentDelegate = self;
        _documentListView.titleBlock = ^(NSString *title) {
             weakSelf.titleLabel.text = title;
        };
        
        
        //默认状态文档列表显示
        [_documentListView show:FileListTypeDocument isClassBegin:[TKEduSessionHandle shareInstance].isClassBegin];
        
        
    }
    return self;
}
- (void)touchOutSide{
    [self dismissAlert];
}
#pragma mark - 课件库切换
- (void)listButtonClick:(UIButton *)sender{
    
    NSInteger type = sender.tag-99;
    switch (type) {
        case FileListTypeDocument:
            
            _coursewareListButton.selected = YES;
            _mediaListButton.selected = NO;
            [_mediaListView hide];
            [_documentListView show:FileListTypeDocument isClassBegin:[TKEduSessionHandle shareInstance].isClassBegin];
            
            break;
        case FileListTypeAudioAndVideo:
            
            _coursewareListButton.selected = NO;
            _mediaListButton.selected = YES;
            
            [_documentListView hide];
            [_mediaListView show:FileListTypeAudioAndVideo isClassBegin:[TKEduSessionHandle shareInstance].isClassBegin];
            
            break;
     
        default:
            break;
    }
}
- (void)initButton:(UIButton *)sender withTitle:(NSString *)title defaultImageName:(NSString *)defaultImageName selectImageName:(NSString *)selectImageName addTag:(FileListType)type{
    sender.sakura.backgroundImage(defaultImageName,UIControlStateNormal);
    sender.sakura.backgroundImage(selectImageName,UIControlStateSelected);
    [sender setTitle:title forState:(UIControlStateNormal)];
    sender.titleLabel.textAlignment = NSTextAlignmentCenter;
    sender.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    sender.sakura.titleColor(ThemeKP(@"coursewareButtonDefaultColor"),UIControlStateNormal);
    sender.sakura.titleColor(ThemeKP(@"coursewareButtonSelectedColor"),UIControlStateSelected);
    sender.tag = type+99;
}
- (void)resetFont{
    
    if (_coursewareListButton.titleLabel.text ) {
        int currentFontSize = _coursewareListButton.frame.size.width/5;
        if (currentFontSize>12) {
            currentFontSize = 12;
        }
        _coursewareListButton.titleLabel.font = TKFont(currentFontSize);
        _mediaListButton.titleLabel.font = TKFont(currentFontSize);
    }
}

- (void)watchFile{
    [self dismissAlert];
}

- (void)deleteFile {
    [self dismissAlert];
}

- (void)show:(UIView *)view
{
    [view addSubview:self.backView];
    
    [view addSubview:self];
    
    [UIView animateWithDuration: 0.25 animations:^{
        
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        self.backView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hidden{
    
    [self dismissAlert];
}

- (void)dismissAlert
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         self.backView.alpha = 0;
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self.backView removeFromSuperview];
                         [self removeFromSuperview];
                         if (self.dismissBlock) {
                             self.dismissBlock();
                         }
                     }];
    
    
}
- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
- (void)removeFromSuperview
{
    [super removeFromSuperview];
}
@end



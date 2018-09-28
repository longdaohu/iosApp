//
//  TKChatListTableViewCell.m
//  EduClass
//
//  Created by admin on 2018/6/6.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKOldChatListTableViewCell.h"
#import "TKMacro.h"
#import "TKUtil.h"
#import "NSAttributedString+TKEmoji.h"
#import "TKLinkLabel.h"


#define ThemeKP(args) [@"ClassRoom.TKChatViews." stringByAppendingString:args]

@interface TKOldChatListTableViewCell()

@property (nonatomic, strong) UILabel *iNickNameLabel;//用户名
@property (nonatomic, strong) UILabel *iTimeLabel;//时间
@property (nonatomic, strong) UIView *iMessageView;//聊天消息视图
@property (nonatomic, strong) TKLinkLabel *iMessageLabel;//聊天内容

@property (nonatomic, strong) UILabel *iMessageTranslationLabel;//翻译内容
@property (nonatomic, assign) MessageType iMessageType;//消息类型
@property (nonatomic, strong) NSString *iText;
@property (nonatomic, strong) NSString *iTranslationtext;
@property (nonatomic, strong) NSString *iNickName;
@property (nonatomic, strong) NSString *iTime;

@property (nonatomic, strong) UIView *translationBorderView;

@property (nonatomic, strong) NSString *cString;

@end
    
@implementation TKOldChatListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupView];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization
    [super awakeFromNib];
}
//14 12
- (void)setupView {
    
    //头
    {
        _iNickNameLabel = ({
            UILabel *tLabel = [[UILabel alloc] init];
            tLabel.sakura.textColor(ThemeKP(@"oldChatNameColor"));
            //_iNickNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            tLabel.backgroundColor = [UIColor clearColor];
            tLabel.font = TKFont(12);

//            tLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            
            tLabel;
            
        });
        [self.contentView addSubview:_iNickNameLabel];
        
    }
    //时间
    {
        _iTimeLabel = ({

            UILabel *tLabel = [[UILabel alloc] init];
            tLabel.sakura.textColor(ThemeKP(@"oldChatTimeColor"));
            tLabel.backgroundColor = [UIColor clearColor];
            tLabel.font = TKFont(10);

            tLabel;
            
        });
        
        [self.contentView addSubview:_iTimeLabel];
    }
    //内容
    {
        // 内容背景
        _iMessageView = ({
            UIView *tView = [[UIView alloc] init];
            tView.sakura.backgroundColor(ThemeKP(@"chatMessageBackgroundColor"));
            tView;
            
        });
        [self.contentView addSubview:_iMessageView];
        
        // 消息内容
        _iMessageLabel = ({
            
            TKLinkLabel *tLabel = [[TKLinkLabel alloc] init];
            tLabel.sakura.textColor(ThemeKP(@"chatMessageColor"));
            tLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            tLabel.font = TKFont(15);
            tLabel.numberOfLines = 0;
            
            tk_weakify(self);
            
            tLabel.linkTapHandler = ^(TKLinkType linkType, NSString *string, NSRange range) {
                if (linkType == TKLinkTypeURL) {//打开连接
                    if(![TKHelperUtil isURL:string]){
                        string = [NSString stringWithFormat:@"http://%@",string];
                    }
                    NSURL *url = [NSURL URLWithString:string];
                    
                    [[UIApplication sharedApplication] openURL:url];
                }
            };
            
            tLabel.linkLongPressHandler = ^(TKLinkType linkType, NSString *string, NSRange range) {
                
                if (linkType == TKLinkTypeURL) {//复制链接
                    weakSelf.cString = string;
                    [weakSelf becomeFirstResponder];
                    UIMenuItem * item = [[UIMenuItem alloc]initWithTitle:MTLocalized(@"Menu.Copy") action:@selector(newFunc)];
                    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
                    [UIMenuController sharedMenuController].menuItems = @[item];
                    [UIMenuController sharedMenuController].menuVisible = YES;
                    
                    
                }
            };
            
            tLabel;
            
            
        });
        [_iMessageView addSubview:_iMessageLabel];
        
    }
    
    //翻译按钮
    {
        _iTranslationButton = ({
            UIButton *tLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];

            tLeftButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            tLeftButton.sakura.image(ThemeKP(@"oldTranslation_normal"),UIControlStateNormal);
            tLeftButton.sakura.image(ThemeKP(@"oldTranslation_selected"),UIControlStateSelected);
            tLeftButton.sakura.image(ThemeKP(@"oldTranslation_normal"),UIControlStateDisabled);
//            [tLeftButton addTarget:self action:@selector(translationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            tLeftButton.enabled = NO;
            tLeftButton;
            
        });
        [_iMessageView addSubview:_iTranslationButton];
    }
    

//    //翻译
    {
        _translationBorderView = ({
            UIView *view = [[UIView alloc] init];
            view.sakura.backgroundColor(ThemeKP(@"chatTranslationBackgroundColor"));
            view;
        });

        _iMessageTranslationLabel = ({

            UILabel *tLabel = [[UILabel alloc] init];
            tLabel.sakura.textColor(ThemeKP(@"chatTranslationColor"));
            tLabel.font            = TKFont(15);
            tLabel.numberOfLines   = 0;
            tLabel;

        });

        [self.contentView addSubview:_translationBorderView];
        [_translationBorderView   addSubview:_iMessageTranslationLabel];

    }

    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor             = [UIColor clearColor];

}
- (void)resetView
{
    NSAttributedString *iMessageText = [NSAttributedString emojiAttributedString:_iText withFont:TEXT_FONT withColor:[UIColor whiteColor]];
    
    _iMessageLabel.attributedText = iMessageText;
    _iMessageLabel.sakura.textColor(ThemeKP(@"chatMessageColor"));
    
    //判断是否只是表情，如果只是表情则不进行翻译
    if ([_iTranslationtext isEqualToString:@""]) {
        _iTranslationtext = nil;
    }
    _iMessageTranslationLabel.text = _iTranslationtext;
    
    
    _iNickNameLabel.text = _iNickName;
    _iTimeLabel.text =  _iTime;
    
    [self layoutSubviews];
//    [self setNeedsLayout];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat tViewCap = 15 * Proportion;
    CGFloat tContentWidth = CGRectGetWidth(self.contentView.frame);
    CGFloat tTimeLabelWidth = 100*Proportion;    // 原来为50*Proportion
    CGFloat tTimeLabelHeigh = 20 * Proportion;
    CGFloat tTranslateLabelHeigh = 25 * Proportion;

    // 其他消息 名字←  时间→
    if (_iMessageType == MessageType_OtherUer) {

        _iNickNameLabel.frame = CGRectMake(0,
                                           tViewCap,
                                           tContentWidth - tTimeLabelWidth - 12,
                                           tTimeLabelHeigh);
        _iNickNameLabel.textAlignment = NSTextAlignmentLeft;

        _iTimeLabel.frame = CGRectMake(CGRectGetMaxX(_iNickNameLabel.frame),
                                       tViewCap,
                                       tTimeLabelWidth,
                                       tTimeLabelHeigh);
        _iTimeLabel.textAlignment = NSTextAlignmentRight;

    }
    // 名字→  时间←
    else {

        _iTimeLabel.frame = CGRectMake(0,
                                       tViewCap,
                                       tTimeLabelWidth,
                                       tTimeLabelHeigh);
        _iTimeLabel.textAlignment = NSTextAlignmentLeft;

        _iNickNameLabel.frame = CGRectMake(CGRectGetMaxX(_iTimeLabel.frame),
                                           tViewCap,
                                           tContentWidth - tTimeLabelWidth - 12,
                                           tTimeLabelHeigh);
        _iNickNameLabel.textAlignment = NSTextAlignmentRight;

    }

    // 计算文本尺寸                             ↓messageLabel 左右            ↓翻译按钮左边距
    CGFloat messageMAXWidth   = tContentWidth - 10. - tTranslateLabelHeigh - 10.;
    CGSize  tMessageLabelSize = [TKOldChatListTableViewCell sizeFromAttributedString:_iText
                                                                     withLimitWidth:messageMAXWidth + 22
                                                                               Font:TKFont(15)];


    _iMessageLabel.frame = CGRectMake(5,
                                      0,
                                      tMessageLabelSize.width ,
                                      tMessageLabelSize.height + 5);

    _iMessageView.frame = CGRectMake(0,
                                     CGRectGetMaxY(_iNickNameLabel.frame) + 5,
                                     _iMessageLabel.width + tTranslateLabelHeigh + 10 + 10,
                                     tMessageLabelSize.height + 5);


    // 翻译按钮
    _iTranslationButton.frame = CGRectMake(CGRectGetMaxX(_iMessageLabel.frame) + 5,
                                           _iMessageLabel.y ,
                                           tTranslateLabelHeigh,
                                           tTranslateLabelHeigh);


    // 翻译文本 背景图
    BOOL hiddenTrans = (_iTranslationtext.length == 0 || !_iTranslationtext);
    _translationBorderView.hidden = hiddenTrans;
    _iMessageTranslationLabel.hidden = hiddenTrans;

    // 有转换文本
    if (!hiddenTrans) {

        // 计算翻译文本 尺寸
        CGFloat transTextMAXWidth = tContentWidth - 10. ;;
        CGSize tTranslationMessageLabelsize = [TKOldChatListTableViewCell sizeFromText:_iTranslationtext
                                                                        withLimitWidth:transTextMAXWidth
                                                                                  Font:TKFont(15)];
        _iMessageTranslationLabel.frame = CGRectMake(_iMessageLabel.x,
                                                     0,
                                                     tTranslationMessageLabelsize.width,
                                                     tTranslationMessageLabelsize.height + 5);



        _translationBorderView.frame = CGRectMake(0,
                                                  CGRectGetMaxY(_iMessageView.frame),
                                                  _iMessageTranslationLabel.width + 10,
                                                  _iMessageTranslationLabel.height + 5);


    }

    // 设置高度
//    CGFloat contentheight = _iNickNameLabel.height + _iMessageView.height + _iMessageTranslationLabel.height;
//    [TKUtil setHeight:self.contentView To:contentheight];
//    [TKUtil setHeight:self To:contentheight];
//    [TKUtil setHeight:self.contentView To:CGRectGetHeight(_iTimeLabel.frame)+CGRectGetHeight(_iMessageView.frame)+CGRectGetHeight(_iMessageTranslationLabel.frame)+ 10];

//    [TKUtil setHeight:self To:CGRectGetHeight(_iTimeLabel.frame)+CGRectGetHeight(_iMessageView.frame)+CGRectGetHeight(_iMessageTranslationLabel.frame)+ 10];


    // 调试用 背景色
//    _iMessageLabel.backgroundColor = UIColor.yellowColor;
//    _iMessageView.backgroundColor = UIColor.greenColor;
}


//-(void)translationButtonClicked:(UIButton *)aButton{
//
//    if (!aButton.selected) {
//        aButton.selected = YES;
//    }
//    if (_iTranslationButtonClicked) {
//
//        _iTranslationButtonClicked(_iTranslationtext);
//    }
//
//
////    _iTranslationButton.selected = !_iTranslationButton.selected;
//}


+ (CGSize)sizeFromText:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont
{
    //    CGSize size = [text sizeWithFont:TEXT_FONT constrainedToSize:CGSizeMake(180, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attribute = @{NSFontAttributeName: aFont};
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
}
+ (CGSize)sizeFromText:(NSString *)text withLimitHeight:(CGFloat)height Font:(UIFont*)aFont
{
    //    CGSize size = [text sizeWithFont:TEXT_FONT constrainedToSize:CGSizeMake(180, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attribute = @{NSFontAttributeName: aFont};
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
}
+ (CGFloat)heightFromText:(NSString *)text withLimitWidth:(CGFloat)width
{
    
    CGFloat height = [self sizeFromText:text withLimitWidth:width Font:TEXT_FONT].height;
    return height;
}


+ (CGSize)sizeFromAttributedString:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont{
    //计算富文本的宽高
    CGSize textBlockMinSize = {width - 22, CGFLOAT_MAX};
    NSAttributedString *attributedString = [NSAttributedString emojiAttributedString:text withFont:aFont withColor:RGBCOLOR(134, 134, 134)];
    CGRect boundingRect = [attributedString boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize tMessageLabelsize = boundingRect.size;
    return tMessageLabelsize;
}
- (void)setChatModel:(TKChatMessageModel *)chatModel{
    _iText               = chatModel.iMessage;
    _iMessageLabel.textColor = (chatModel.iMessageType ==MessageType_Me)?  RGBCOLOR(221, 221, 221): RGBCOLOR(162, 162, 162);
    _iTranslationtext    = chatModel.iTranslationMessage;
    
//    _iTime = [TKUtil getCurrentHoursAndMinutes:chatModel.iTime];
    _iTime = chatModel.iTime;
    _iNickName = chatModel.iUserName;
    _iMessageType        = chatModel.iMessageType;
    [self resetView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma 长按复制

-(BOOL)canBecomeFirstResponder {
    return YES;
}

// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(newFunc)) {
        return YES;
    }
    return NO;
}

//针对于响应方法的实现
-(void)copy:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.cString;
}

-(void)newFunc{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.cString;
}

@end

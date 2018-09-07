//
//  TKPageControlView.m
//  EduClass
//
//  Created by lyy on 2018/4/20.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKDocumentControlView.h"
#import "TKPageButton.h"
#import "TKPageView.h"
#import "TKEduSessionHandle.h"
#import "TKDocmentDocModel.h"

#define ThemeKP(args) [@"ClassRoom.TKTabbarView." stringByAppendingString:args]

@interface TKDocumentControlView()

@property (nonatomic, strong) UIButton *prePageButton;//上一页
@property (nonatomic, strong) TKPageButton *currentPageButton;//页码按钮
@property (nonatomic, strong) UIButton *nextPageButton;//下一页

@property (nonatomic, strong) TKPageView *pageView;
@property (nonatomic, assign) NSInteger totalNum;

@property (nonatomic, assign) NSInteger currentNum;
@property (nonatomic, assign) BOOL isClass;  // 保存上一个 是否上课的状态
@end

@implementation TKDocumentControlView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(classBegin:) name:tkClassBeginNotification object:nil];
        
        _curPage = 1; // 默认第一页
        _isClass = NO;
        
        _prePageButton = ({
            
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.sakura.image(ThemeKP(@"common_icon_left"),UIControlStateNormal);
            button.sakura.image(ThemeKP(@"common_icon_left_unclickable"),UIControlStateDisabled);
            
            [self addSubview:button];
            button.contentMode = UIViewContentModeCenter;
            [button addTarget:self action:@selector(prePageButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            button;
        });
        
        _currentPageButton = ({
            
            TKPageButton *button = [[TKPageButton alloc]init];
            button.sakura.image(ThemeKP(@"common_icon_xiala"),UIControlStateNormal);
            button.sakura.image(ThemeKP(@"common_icon_up"),UIControlStateSelected);
            [self addSubview:button];
            button.selected = NO;
            [button addTarget:self action:@selector(currentPageButton:) forControlEvents:(UIControlEventTouchUpInside)];
            button;
        });
        
        _nextPageButton = ({
            
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [self addSubview:button];
              button.contentMode = UIViewContentModeCenter;
            button.sakura.image(ThemeKP(@"common_icon_right"),UIControlStateNormal);
            button.sakura.image(ThemeKP(@"common_icon_right_unclickable"),UIControlStateDisabled);
            [button addTarget:self action:@selector(nextPageButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            button;
        });
        
        _wbControlView = ({
            TKWBControlView *view= [[TKWBControlView alloc]init];
            [self addSubview:view];
            view.remarkButton.hidden = YES;
            view;
        });
        
    }
    return self;
}
- (void)layoutSubviews{
    
    _prePageButton.frame = CGRectMake(0, 0, self.frame.size.width/10.0, self.frame.size.height);
    
    //当前页码按钮
    _currentPageButton.frame = CGRectMake(CGRectGetMaxX(_prePageButton.frame), 0, self.frame.size.width/10.0*2.6, self.frame.size.height);
    
    _nextPageButton.frame = CGRectMake(CGRectGetMaxX(_currentPageButton.frame), 0, self.frame.size.width/10.0, self.frame.size.height);
    
    _wbControlView.frame = CGRectMake(CGRectGetMaxX(_nextPageButton.frame), 0, self.frame.size.width - CGRectGetMaxX(_nextPageButton.frame), self.frame.size.height);
    
}
#pragma mark - 上一页
- (void)prePageButtonClick:(UIButton *)sender{
    
    [[TKEduSessionHandle shareInstance].whiteBoardManager prePage];
    _curPage--;
}

#pragma mark - 当前页
- (void)currentPageButton:(UIButton *)sender{
    
    if (_totalNum<=1) {
        return;
    }
    sender.selected = !sender.selected;
    if (self.showCurrenPageNum) {
        self.showCurrenPageNum(sender.selected);
    }
    if (sender.selected) {
        
        if (!self.pageView) {
            
            self.pageView = [[TKPageView alloc]init];
            
            [self.pageView showOnView:sender totalPages:(int)_totalNum pageShowType:(DocumentPageShow)];
            
            __block typeof(self) weakself = self;
            
            self.pageView.currentSelectPageNum = ^(NSInteger num) {
                [weakself.currentPageButton setTitle:[NSString stringWithFormat:@"%ld/%ld",num,weakself.totalNum] forState:(UIControlStateNormal)];
                
                [[TKEduSessionHandle shareInstance].whiteBoardManager skipToPageNum:@(num)];
                weakself.curPage = num;
                
            };
            
            self.pageView.dismissBlock = ^{
                sender.selected = NO;
                weakself.pageView = nil;
            };
        }
        
    }else{
        
        [self.pageView dissMissView];
        self.pageView = nil;
        
    }
    
    
    
}
- (void)nextPageButtonClick:(UIButton *)sender{
    //判断是什么文档，如果是动态ppt、h5执行step
    TKDocmentDocModel *docModel = [TKEduSessionHandle shareInstance].iCurrentDocmentModel;
    BOOL addPage = NO;
    if (docModel) {
        if ([docModel.fileid intValue]== 0) {
            if (_currentNum==_totalNum) {
                addPage = YES;
            }
        }
    }
    [[TKEduSessionHandle shareInstance].whiteBoardManager nextPage:addPage];

    _curPage++;
}


- (void)updateView:(NSDictionary *)message{
    
    //备注是否显示
    if ([message objectForKey:@"remarkText"]) {
        
        BOOL remarkText = [TKUtil getBOOValueFromDic:message Key:@"remarkText"];
        
        self.wbControlView.remarkButton.hidden = !remarkText;
    }
    
    //备注是否选中
    if ([message objectForKey:@"remark"]) {
        
        BOOL remark = [TKUtil getBOOValueFromDic:message Key:@"remark"];
        
        self.wbControlView.remarkButton.selected = remark;
    }
    
    //判断是什么文档，如果是动态ppt、h5执行step
    TKDocmentDocModel *docModel = [TKEduSessionHandle shareInstance].iCurrentDocmentModel;
    // 换页展示
    if ([message objectForKey:@"page"] ) {
        
        NSDictionary *page = [TKUtil getDictionaryFromDic:message Key:@"page"];
        //当前页
        //跳转状态
        NSNumber *currentPage = [TKUtil getNSNumberFromDic:page Key:@"currentPage"];
        _currentNum = [currentPage intValue];
        //总页数
        NSNumber *totalPage = [TKUtil getNSNumberFromDic:page Key:@"totalPage"];
        _totalNum = [totalPage intValue];
        [self.currentPageButton setTitle:[NSString stringWithFormat:@"%@/%@",currentPage,totalPage] forState:(UIControlStateNormal)];
        
        
        if ([page objectForKey:@"skipPage"]) {
            
            BOOL skipPage = [TKUtil getBOOValueFromDic:page Key:@"skipPage"];
            self.currentPageButton.enabled = skipPage;
            
        }
   
        BOOL nextFlag = YES;
        BOOL preFlag = YES;
        if (docModel) {
            if ([docModel.fileid intValue]== 0) {
                if (currentPage<totalPage) {
                    nextFlag = [page[@"nextPage"] boolValue];//下一页
                }else{
                    nextFlag = [page[@"addPage"] boolValue];//白板加页
                }
                preFlag = [page[@"prevPage"] boolValue];
            }else{
                switch ([docModel.fileprop intValue]) {
                    case 0:
                    case 3:
                        nextFlag = [page[@"nextPage"] boolValue];
                        preFlag = [page[@"prevPage"] boolValue];
                        break;
                    case 1:
                    case 2:
                        nextFlag = [page[@"nextStep"] boolValue];
                        preFlag = [page[@"prevStep"] boolValue];
                        break;
                    default:
                        break;
                }
            }
        }
        
        _nextPageButton.enabled = nextFlag;
        _prePageButton.enabled = preFlag;
        

    }
    
   
    
    if ([message objectForKey:@"zoom"]) {
        if ([docModel.fileprop intValue]== 1 || [docModel.fileprop intValue] == 2 || [docModel.fileprop intValue] == 3) {
            
            self.wbControlView.largeButton.hidden = YES;
            self.wbControlView.smallButton.hidden = YES;
        }else{
            
            self.wbControlView.largeButton.hidden = NO;
            self.wbControlView.smallButton.hidden = NO;
            
            NSDictionary *zoom = [TKUtil getDictionaryFromDic:message Key:@"zoom"];
            //缩小的状态
            
            if ([zoom objectForKey:@"zoom_big"]) {
                
                BOOL zoombig = [TKUtil getBOOValueFromDic:zoom Key:@"zoom_big"];
                self.wbControlView.largeButton.enabled = zoombig;
            }
            
            if ([zoom objectForKey:@"zoom_small"]) {
                
                //放大的状态
                BOOL zoomsmall = [TKUtil getBOOValueFromDic:zoom Key:@"zoom_small"];
                self.wbControlView.smallButton.enabled = zoomsmall;
            }
        }
        
        
    }
    
    if ([TKEduSessionHandle shareInstance].isClassBegin && [TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher && _isClass) {// 判断是由下课-》上课状态
        
        if (_curPage != 1 ) {
            [[TKEduSessionHandle shareInstance].whiteBoardManager skipToPageNum:@(_curPage)];
            _isClass = NO;
        }
    }

}

- (void)destoy{
    [_pageView dissMissView];
}

- (void)classBegin:(NSNotification *)notification{
    
    NSDictionary *dict =(NSDictionary *) notification.object;
    if ([[dict allKeys] containsObject:@"classBegin"]) {
        _isClass = [[dict objectForKey:@"classBegin"] boolValue];
//         [[TKEduSessionHandle shareInstance].whiteBoardManager skipToPageNum:@(_curPage)];
    }
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

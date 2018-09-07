//
//  TKUserListView.m
//  EduClass
//
//  Created by lyy on 2018/5/31.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKUserListView.h"
#import <QuartzCore/QuartzCore.h>
#import "TKListButton.h"
#import "TKDocumentListView.h"
#import "TKUserListHeaderView.h"
#import "TKUserListFooterView.h"
#import "TKUserListTableViewCell.h"


#define userListPageNumber 20
#define ThemeKP(args) [@"TKListView." stringByAppendingString:args]


@interface TKUserListView ()<UITableViewDataSource, UITableViewDelegate,TKUserListFooterViewDelegate> {
    
    CGFloat _toolHeight; //工具条高度
    CGFloat _bottomHeight;//底部按钮高度
    
    int _startIndex;
    int _currentNum;
    int _totalNum;
}

@property (nonatomic, strong) UIView       * backView;
@property (nonatomic, strong) UILabel      * titleLabel;
@property (nonatomic, strong) TKDocumentListView *userListView;//用户列表
@property (nonatomic,strong)  NSMutableArray *iFileMutableArray;
@property (nonatomic, strong) TKUserListHeaderView *userHeaderView;//用户列表工具栏视图
@property (nonatomic, strong) TKUserListFooterView *userFooterView;//用户列表操作栏
@property (nonatomic,retain)  UITableView    *iFileTableView;//展示tableview
@property (nonatomic,assign)  BOOL  isClassBegin;//课堂是否开始
@property (nonatomic, strong) dispatch_source_t timer;//定时器

@end

@implementation TKUserListView

- (id)initWithFrame:(CGRect)frame userList:(NSString *)userListController{
    
    if (self = [super initWithFrame:frame from:userListController]) {
        
        // 通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userListUpadate) name:tkUserListNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:sDocListViewNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:sEveryoneBanChat object:nil];
        // 初始化
        _totalNum = 0;
        _startIndex = 0;
        _currentNum = 0;
        _toolHeight = IS_PAD ? CGRectGetHeight(frame)/8.0 : 30;
        _bottomHeight = IS_PAD ? 44 : 34;
        
        //标题控件
        if (!self.titleLabel) {
            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.backImageView.width, self.backImageView.height*0.12)];
            [self.backImageView addSubview:self.titleLabel];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.sakura.textColor(ThemeKP(@"titleColor"));
            
        }
        
#warning
        //        _userListView = [[TKDocumentListView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
        //        [self.contentView addSubview:_userListView];
        //
        //
        //        __block typeof(self) weakSelf = self;
        //        _userListView.titleBlock = ^(NSString *title) {
        //            weakSelf.titleLabel.text = title;
        //        };
        //        [_userListView show:FileListTypeUserList isClassBegin:[TKEduSessionHandle shareInstance].isClassBegin];
        
        [self loadTableView:CGRectMake(0,
                                       0,
                                       CGRectGetWidth(self.contentView.frame),
                                       CGRectGetHeight(self.contentView.frame))
         ];
        [self show:FileListTypeUserList isClassBegin:[TKEduSessionHandle shareInstance].isClassBegin];
        
    }
    return self;
}


-(void)loadTableView:(CGRect)frame{
    
    //用户列表头部
    _userHeaderView =[[[NSBundle mainBundle] loadNibNamed:@"TKUserListHeaderView" owner:nil options:nil] lastObject];
    _userHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), _toolHeight);
    [_userHeaderView setTitleHeight:CGRectGetWidth(frame)];
    _userHeaderView.hidden = YES;
    [self.contentView addSubview:_userHeaderView];
    
    // tableView
    _iFileTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                   _toolHeight,
                                                                   CGRectGetWidth(frame),
                                                                   CGRectGetHeight(frame)- _toolHeight - 40)
                                                  style:UITableViewStylePlain];
    _iFileTableView.backgroundColor = [UIColor clearColor];
    _iFileTableView.separatorColor  = [UIColor clearColor];
    _iFileTableView.showsHorizontalScrollIndicator = NO;
    _iFileTableView.delegate   = self;
    _iFileTableView.dataSource = self;
    _isClassBegin = NO;
    _iFileTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [_iFileTableView registerNib:[UINib nibWithNibName:@"TKUserListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TKUserListTableViewCellID"];
    
    [self.contentView addSubview:_iFileTableView];
    
    
    // 底部视图
    _userFooterView = [[[NSBundle mainBundle] loadNibNamed:@"TKUserListFooterView" owner:nil options:nil] lastObject];
    _userFooterView.frame = CGRectMake(0, CGRectGetHeight(frame)-40, CGRectGetWidth(frame), 40);
    _userFooterView.hidden = YES;
    _userFooterView.delegate = self;
    [self.contentView addSubview:_userFooterView];
    
    tk_weakify(self);
    _userFooterView.nextPage = ^{
        
        if ([TKEduSessionHandle shareInstance].bigRoom) {
            if (weakSelf.timer) {
                dispatch_source_cancel(weakSelf.timer);
                weakSelf.timer = nil;
            }
            
            [weakSelf getBigRoomUsers:YES];
            
            [weakSelf startTimer];
            
        }else{
            [weakSelf getRoomUsers:YES];
        }
    };
    _userFooterView.prePage = ^{
        if ([TKEduSessionHandle shareInstance].bigRoom) {
            
            [weakSelf getBigRoomUsers:NO];
        }else{
            
            [weakSelf getRoomUsers:NO];
        }
    };
    
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _iFileMutableArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TKUserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TKUserListTableViewCellID" forIndexPath:indexPath];
    
    TKRoomUser *tRoomUser = [_iFileMutableArray objectAtIndex:indexPath.row];
    cell.roomUser = tRoomUser;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Patrol) {
        return;
    }
    
}

#pragma mark - 显示隐藏 方法
-(void)show:(FileListType)aFileListType isClassBegin:(BOOL)isClassBegin{
    
    self.hidden = NO;
    
    _isClassBegin = isClassBegin;
    
    self.userHeaderView.hidden = NO;
    self.userFooterView.hidden = NO;
    
//    //是否是大并发课堂
    if ([TKEduSessionHandle shareInstance].bigRoom) {
        [self getBigRoomUserNumber];
        [self getBigRoomUsers:YES];
        
        [self startTimer];
        
    }
    else {
        [self getRoomUserNumber];
        [self getRoomUsers:YES];

    }

}


-(void)hide{
    
    self.hidden = YES;
    self.userHeaderView.hidden = YES;
    [self.userFooterView destory];
    [self.userFooterView removeFromSuperview];
    self.userFooterView = nil;
    
    if (self.timer) {
        
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    
    _startIndex = 0;
    _totalNum = 0;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 通知 更新方法  
-(void)updateData{
//    NSString *tString;
//    tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.UserList"), @([_iFileMutableArray count])];
    
    _iFileMutableArray = [[[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr] mutableCopy];
    
    
}

- (void)reloadTableView {
    
    [self updateData];
    [self.iFileTableView reloadData];
}
- (void)userListUpadate{
    
    if ([TKEduSessionHandle shareInstance].bigRoom) {
        
        [self getBigRoomUserNumber];
        _startIndex = (_currentNum-1)*userListPageNumber;
        [self getBigRoomUsers:YES];
        
    }else{
        
        int num = [self getRoomUserNumber];
        int totalPage = [TKHelperUtil returnTotalPageNum:num showPage:userListPageNumber];
        if (_currentNum>totalPage) {
            _currentNum = totalPage;
        }
        _startIndex = (_currentNum-1)*userListPageNumber;
        [self getRoomUsers:YES];
        
    }
}

- (void)userListJumpPageNum:(int)pageNum{
    
    _startIndex = (pageNum-1)*userListPageNumber;
    if ([TKEduSessionHandle shareInstance].bigRoom) {
        
        [self getBigRoomUserNumber];
        [self getBigRoomUsers:YES];
        
    }else{
        
        [self getRoomUserNumber];
        [self getRoomUsers:YES];
    }
}

#pragma mark - 获取房间成员列表
- (void)getRoomUsers:(BOOL)nextPage{
    
    NSArray *array = [[[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]mutableCopy];
    //如果成员列表人数为0，则不进行刷新页面
    if (array.count == 0) {
        _iFileMutableArray = [array mutableCopy];
        [_iFileTableView reloadData];
        return;
    }
    if (_startIndex<0) {
        _startIndex = 0;
    }
    int pageNum = userListPageNumber;
    if ((nextPage?(_startIndex + userListPageNumber):(_startIndex - userListPageNumber)) >_totalNum) {
        pageNum = _totalNum- (_startIndex);
    }
    if (pageNum == 0) {
        return;
    }
    int currentpage;
    if (nextPage) {//下一页
        currentpage = [TKHelperUtil returnTotalPageNum:_startIndex showPage:userListPageNumber]+1;
    }else{//上一页
        currentpage = _currentNum-1;
        if(currentpage < 0) {
            return;
        }else{
            _startIndex = (currentpage-1) * userListPageNumber;
        }
    }
    //如果成员列表人数小于等于一页显示的人数就从0开始获取
    if (array.count <= userListPageNumber) {
        _startIndex = 0;
    }
    
    [_userFooterView setCurrentPageNum: currentpage];//设置当前页码
    _currentNum = currentpage;
    
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                           NSMakeRange(_startIndex,pageNum)];
    
    _iFileMutableArray = [[array objectsAtIndexes:indexes] mutableCopy];
    
    _startIndex = _startIndex + pageNum;
    
    [_iFileTableView reloadData];
}
#pragma mark - 开启定时器，定时刷新用户列表
- (void)startTimer{
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(2.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        
        NSLog(@"------------%@", [NSThread currentThread]);
        if (_currentNum) {
            if ([TKEduSessionHandle shareInstance].bigRoom) {
                
                [self getBigRoomUserNumber];
                _startIndex = (_currentNum-1)*userListPageNumber;
                [self getBigRoomUsers:YES];
                
            }else{
                
                [self getRoomUserNumber];
                _startIndex = (_currentNum-1)*userListPageNumber;
                [self getRoomUsers:YES];
                
            }
        }
        
    });
    
    
    
    dispatch_resume(self.timer);
}


#pragma mark - listProtocol
//举手标志
-(void)listButton1:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath{
    
}

//上台
-(void)listButton2:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath{
    
    if( [TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol){
        return;
    }
    NSString *tString;
    
    tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.UserList"), @([_iFileMutableArray count])];
    
    TKRoomUser *tRoomUser =[_iFileMutableArray objectAtIndex:aIndexPath.row];
    PublishState tState = (PublishState)tRoomUser.publishState;
    BOOL isShowVideo = tRoomUser.publishState >1;
    
    if (isShowVideo) {
        
        tState = PublishState_NONE;
        [[TKEduSessionHandle shareInstance]configureDraw:false isSend:true to:sTellAll peerID:tRoomUser.peerID];
        //[[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:tRoomUser.peerID TellWhom:sTellAll Key:sCandraw Value:@(false) completion:nil];
        
    }else{
        
        int isSucess = [[TKEduSessionHandle shareInstance] addPendingUser:tRoomUser];
        //                if (!isSucess) {break;}
        tState = PublishState_BOTH;
    }
    
    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:tRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:tRoomUser.peerID Publish:tState completion:nil];
    
    
    
    //    if (self.titleBlock) {
    //        self.titleBlock(MTLocalized(tString));
    //    }
}

- (void)dismissAlert
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self hide];
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

#pragma mark - 获取大并发房间成员数量
- (void)getBigRoomUserNumber{
    
    [[TKEduSessionHandle shareInstance] sessionHandleGetRoomUserNumberWithRole:@[@(UserType_Student),@(UserType_Assistant)] callback:^(NSInteger num, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                
                NSLog(@"大并发=========人数%ld",(long)num);
                
                _totalNum = (int)num;
                if (num>0) {
                    _userFooterView.hidden = NO;
                    [_userFooterView setTotalNum:[TKHelperUtil returnTotalPageNum:num showPage:userListPageNumber]];
                    
                }else{
                    _userFooterView.hidden = YES;
                    
                }
            }
        });
    }];
    
}
#pragma mark - 获取大并发房间成员列表
- (void)getBigRoomUsers:(BOOL)nextPage{
    
    //    [_userFooterView setCurrentPageNum:[TKHelperUtil returnTotalPageNum:_startIndex showPage:userListPageNumber]+1];
    
    [[TKEduSessionHandle shareInstance] sessionHandleGetRoomUsersWithRole:@[@(UserType_Student),@(UserType_Assistant)] startIndex:_startIndex maxNumber:userListPageNumber callback:^(NSArray<TKRoomUser *> * _Nonnull users, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSArray *array =  [users mutableCopy];
                //如果成员列表人数为0，则不进行刷新页面
                if (array.count == 0) {
                    _iFileMutableArray = [array mutableCopy];
                    [_iFileTableView reloadData];
                    return;
                }
                if (_startIndex<0) {
                    _startIndex = 0;
                }
                
                int pageNum = userListPageNumber;
                if ((nextPage?(_startIndex + userListPageNumber):(_startIndex - userListPageNumber)) >_totalNum) {
                    pageNum = _totalNum- (_startIndex);
                }
                if (pageNum == 0) {
                    return;
                }
                int currentpage;
                if (nextPage) {//下一页
                    currentpage = [TKHelperUtil returnTotalPageNum:_startIndex showPage:userListPageNumber]+1;
                }else{//上一页
                    currentpage = _currentNum-1;
                    if(currentpage < 0) {
                        return;
                    }else{
                        _startIndex = (currentpage-1) * userListPageNumber;
                    }
                }
                //如果成员列表人数小于等于一页显示的人数就从0开始获取
                //                if (array.count <= userListPageNumber) {
                //                    _startIndex = 0;
                //                }
                
                [_userFooterView setCurrentPageNum: currentpage];//设置当前页码
                _currentNum = currentpage;
                
                //                NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                //                                       NSMakeRange(_startIndex,pageNum)];
                
                _iFileMutableArray = [array mutableCopy];
                
                _startIndex = _startIndex + pageNum;
                
                [_iFileTableView reloadData];
            }
        });
        
        
        
    }];
}
#pragma mark - 获取房间成员数量
- (int)getRoomUserNumber{
    
    int num = (int)[[[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr] count];
    _totalNum = num;
    if (num>0) {
        _userFooterView.hidden = NO;
        [_userFooterView setTotalNum:[TKHelperUtil returnTotalPageNum:num showPage:userListPageNumber]];
        
    }else{
        _userFooterView.hidden = YES;
        
    }
    
    
    NSString *str = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.UserList"), @(num)];
    self.titleLabel.text = str;
    return num;
}


-(void)dealloc{
    
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

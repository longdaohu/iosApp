//
//  TKDocumentListView.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/13.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKDocumentListView.h"

#import "TKUtil.h"
#import "TKFileListTableViewCell.h"
#import "TKMediaDocModel.h"
#import "TKDocmentDocModel.h"
#import "TKOneToMoreRoomController.h"
#import "TKEduNetManager.h"
#import "UIView+Extension.h"
#import "TKFileListHeaderView.h"

#define ThemeKP(args) [@"TKDocumentListView." stringByAppendingString:args]
#define kMargin 10

@interface TKDocumentListView ()<listProtocol,TKFileListHeaderViewDelegate>
{
    CGFloat _toolHeight;//工具条高度
    CGFloat _bottomHeight;//底部按钮高度
    
}

@property (nonatomic,assign)FileListType  iFileListType;
@property (nonatomic,strong)NSMutableArray *iFileMutableArray;
//@property (nonatomic,strong)TKDocmentDocModel *whiteBoardModel;//白板文件
@property (nonatomic,strong)NSMutableArray *iClassFileMutableArray;//课堂文件
@property (nonatomic,strong)NSMutableArray *iSystemFileMutableArray;//公共文件
@property (nonatomic,retain)UITableView    *iFileTableView;//展示tableview
@property (nonatomic,assign)BOOL  isClassBegin;//课堂是否开始
@property (nonatomic,strong)UIButton*  iCurrrentButton;
@property (nonatomic,strong)UIButton*  iPreButton;
@property (nonatomic, strong) TKFileListHeaderView *fileListHeaderView;//文档工具栏视图
@property (nonatomic, strong) UIButton *takePhotoBtn;//拍照上传
@property (nonatomic, strong) UIButton *choosePicBtn;//选择照片
@property (nonatomic, assign) BOOL filecategory;//文档类型 true 分类   false 未分类
@property (nonatomic, assign) FileType switchfileType;

@end

@implementation TKDocumentListView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.hidden = YES;
        _toolHeight = IS_PAD?CGRectGetHeight(frame)/8.0:30;
        _bottomHeight = IS_PAD?44:34;
        
        if ([TKEduSessionHandle shareInstance].iRoomProperties.chairmanControl.length >= 57) {
            _filecategory = [[[TKEduSessionHandle shareInstance].iRoomProperties.chairmanControl substringWithRange:NSMakeRange(56, 1)] isEqualToString:@"1"] ? YES : NO;
        }else{
            _filecategory = NO;
        }
        _switchfileType = ClassFileType;
        
        [self loadTableView:frame];
        
        _isShow = NO;
        
        [self createUploadPhotosButton];
        
    }
    return self;
}

-(void)loadTableView:(CGRect)frame{
    
    //文档、媒体头部视图
    _fileListHeaderView = [[TKFileListHeaderView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), _toolHeight) fileType:_filecategory];
    [self addSubview:_fileListHeaderView];
    _fileListHeaderView.hidden = YES;
    _fileListHeaderView.delegate = self;
    
    _iFileTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _toolHeight, CGRectGetWidth(frame), CGRectGetHeight(frame)-_toolHeight-40) style:UITableViewStylePlain];
    _iFileTableView.backgroundColor = [UIColor clearColor];
    _iFileTableView.separatorColor  = [UIColor clearColor];
    _iFileTableView.showsHorizontalScrollIndicator = NO;
    _iFileTableView.delegate   = self;
    _iFileTableView.dataSource = self;
    _isClassBegin = NO;
    _iFileTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [_iFileTableView registerNib:[UINib nibWithNibName:@"TKFileListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TKFileListTableViewCellID"];
    
    [self addSubview:_iFileTableView];
    
}

- (void)createUploadPhotosButton
{
    // 巡课无需显示拍照和上传图片
    if ([TKEduSessionHandle shareInstance].localUser.role == TKUserType_Patrol ) {
        return;
    }
    if (_takePhotoBtn && _choosePicBtn) {
        return;
    }
    CGFloat btnHeight = _bottomHeight-10;
    CGFloat btnWidth = btnHeight*3.0;
    CGFloat btnX = (self.width-btnWidth*2)/3.0;
    CGFloat btnY = (_bottomHeight-btnHeight)/2.0;
    
    _takePhotoBtn = [self createCommonButtonWithFrame:CGRectMake(btnX, self.height - _bottomHeight+btnY, btnWidth, btnHeight) title:MTLocalized(@"UploadPhoto.TakePhoto") selector:@selector(takePhotosAction:)];
    [self addSubview:_takePhotoBtn];
    _choosePicBtn = [self createCommonButtonWithFrame:CGRectMake(_takePhotoBtn.rightX + btnX, self.height - _bottomHeight+btnY, btnWidth, btnHeight) title:MTLocalized(@"UploadPhoto.FromGallery") selector:@selector(choosePicturesAction:)];
    
    [self addSubview:_choosePicBtn];
}

//只在显示文档列表时才会显示上传图片按钮
- (void)showUploadButton:(BOOL)show
{
    if (_takePhotoBtn && _choosePicBtn) {
        if (show)
            _iFileTableView.height = self.height- _toolHeight - _bottomHeight;
        else
            _iFileTableView.height = self.height- _toolHeight;
        
        _takePhotoBtn.hidden = !show;
        _choosePicBtn.hidden = !show;
    }
}

//拍摄照片
- (void)takePhotosAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:sTakePhotosUploadNotification object:sTakePhotosUploadNotification];
}
//选择照片
- (void)choosePicturesAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:sChoosePhotosUploadNotification object:sChoosePhotosUploadNotification];
}

- (UIButton *)createCommonButtonWithFrame:(CGRect)frame title:(NSString *)title selector:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:CGRectGetHeight(btn.frame)/2.0];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.sakura.backgroundImage(ThemeKP(@"choose_photo_button_click"),UIControlStateNormal);
    [TKUtil setCornerForView:btn];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.hidden = YES;
    return btn;
}
//382

- (void)reloadData {
    
    [self refreshData:_iFileListType isClassBegin:_isClassBegin];
    
}

#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _iFileMutableArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tCell;
    NSString *tString;
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            TKFileListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TKFileListTableViewCellID" forIndexPath:indexPath];
            cell.delegate = self;
            cell.iIndexPath = indexPath;
            tCell = cell;
            
            //@"影音列表"
            tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.MediaList"),@([[TKEduSessionHandle shareInstance].mediaArray count])];
            
            TKMediaDocModel *tMediaDocModel = [_iFileMutableArray objectAtIndex:indexPath.row];
            
            if (_switchfileType == SystemFileType) {
                cell.hiddenDeleteBtn = YES;
            }
            [cell configaration:tMediaDocModel withFileListType:FileListTypeAudioAndVideo isClassBegin:_isClassBegin];
        }
            break;
        case FileListTypeDocument:
        {
            
            TKFileListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TKFileListTableViewCellID" forIndexPath:indexPath];
            cell.delegate = self;
            cell.iIndexPath = indexPath;
            tCell = cell;
            //文档列表
            // NSString *tString = [NSString stringWithFormat:@"文档列表"];
            tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.DocumentList"),@([[TKEduSessionHandle shareInstance].docmentArray count])];
            
            TKDocmentDocModel *tMediaDocModel = [_iFileMutableArray objectAtIndex:indexPath.row];
            
            [cell configaration:tMediaDocModel withFileListType:FileListTypeDocument isClassBegin:_isClassBegin];
        }
            break;
        default:
            break;
    }
    
    if (self.titleBlock) {
        self.titleBlock(MTLocalized(tString));
    }
    tCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Patrol) {
        return;
    }
    
    TKFileListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *aButton = cell.watchBtn;
    [self watchFile:aButton aIndexPath:indexPath];
    
}

-(void)show:(FileListType)aFileListType isClassBegin:(BOOL)isClassBegin{
    
    self.hidden = NO;
    
    [self refreshData:aFileListType isClassBegin:isClassBegin];
    
    _isShow = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateData) name:sDocListViewNotification object:nil];
}

-(void)hide{
    
    self.hidden = YES;
    self.fileListHeaderView.hidden = YES;
    
    _isShow = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)updateData{
    NSString *tString;
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            //@"影音列表"
            tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.MediaList"), @([[TKEduSessionHandle shareInstance].mediaArray count])];
            
            if (_filecategory) {
                
                switch (_switchfileType) {
                    case ClassFileType:
                        
                        _iFileMutableArray = [[[TKEduSessionHandle shareInstance] classMediaArray]mutableCopy];
                        
                        break;
                    case SystemFileType:
                        
                        _iFileMutableArray = [[[TKEduSessionHandle shareInstance] systemMediaArray]mutableCopy];
                        
                        break;
                    default:
                        break;
                }
            }else{
                _iFileMutableArray = [[[TKEduSessionHandle shareInstance] mediaArray]mutableCopy];
                
            }
            
        }
            break;
        case FileListTypeDocument:
        {
            //@"文档列表"
            tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.DocumentList"), @([[TKEduSessionHandle shareInstance].docmentArray count])];
            if (_filecategory) {
                
                switch (_switchfileType) {
                    case ClassFileType:
                        _iFileMutableArray = [[[TKEduSessionHandle shareInstance] classDocmentArray]mutableCopy];
                        
                        break;
                    case SystemFileType:
                        _iFileMutableArray = [[[TKEduSessionHandle shareInstance] systemDocmentArray]mutableCopy];
                        
                        break;
                    default:
                        break;
                }
                
            }else{
                _iFileMutableArray = [[[TKEduSessionHandle shareInstance] docmentArray]mutableCopy];
            }
        }
            break;
            
        default:
            break;
    }
    if(_iFileListType != FileListTypeUserList){
        
        if (self.titleBlock) {
            self.titleBlock(MTLocalized(tString));
        }
    
        if (self.titleBlock) {
            self.titleBlock(MTLocalized(tString));
        }
        
        [_iFileTableView reloadData];
    

    }
}
-(void)refreshData:(FileListType)aFileListType isClassBegin:(BOOL)isClassBegin{
    
    _iFileListType    = aFileListType;
    _isClassBegin = isClassBegin;
    NSString *tString;
    
    switch (aFileListType) {
            
        case FileListTypeAudioAndVideo:
        {
            if (_filecategory) {
                
                switch (_switchfileType) {
                    case ClassFileType:
                        
                        _iFileMutableArray = [[[TKEduSessionHandle shareInstance] classMediaArray]mutableCopy];
                        
                        break;
                    case SystemFileType:
                        
                        _iFileMutableArray = [[[TKEduSessionHandle shareInstance] systemMediaArray]mutableCopy];
                        
                        break;
                    default:
                        break;
                }
                
                
            }else{
                _iFileMutableArray = [[[TKEduSessionHandle shareInstance] mediaArray]mutableCopy];
                
            }
            self.fileListHeaderView.hidden = NO;
            //@"影音列表"
            tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.MediaList"), @([[TKEduSessionHandle shareInstance].mediaArray count])];
            
        }
            break;
        case FileListTypeDocument:
        {
            if (_filecategory) {
                
                switch (_switchfileType) {
                    case ClassFileType:
                        _iFileMutableArray = [[[TKEduSessionHandle shareInstance] classDocmentArray]mutableCopy];
                        
                        break;
                    case SystemFileType:
                        _iFileMutableArray = [[[TKEduSessionHandle shareInstance] systemDocmentArray]mutableCopy];
                        
                        break;
                    default:
                        break;
                }
                
                
            }else{
                _iFileMutableArray = [[[TKEduSessionHandle shareInstance] docmentArray]mutableCopy];
                
            }
            self.fileListHeaderView.hidden = NO;
            //@"文档列表"
            [self showUploadButton:YES];
            tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.DocumentList"), @([[TKEduSessionHandle shareInstance].docmentArray count])];
            
        }
            break;
            
        default:
            break;
    }
    
    if (self.titleBlock) {
        self.titleBlock(MTLocalized(tString));
    }
    [_iFileTableView reloadData];
    
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
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            //@"影音列表"
            tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.MediaList"), @([[TKEduSessionHandle shareInstance].mediaArray count])];
            TKMediaDocModel *tMediaDocModel =  [_iFileMutableArray objectAtIndex:aIndexPath.row];
            tMediaDocModel.isPlay =@( aButton.selected);
            
        }
            break;
        case FileListTypeDocument:
        {
            //文档列表
            
            //TKDocmentDocModel *tDocmentDocModel = [_iFileMutableArray objectAtIndex:aIndexPath.row];
            tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.DocumentList"), @([[TKEduSessionHandle shareInstance].docmentArray count])];
            
        }
            break;
            
        default:
            break;
    }
    if (self.titleBlock) {
        self.titleBlock(MTLocalized(tString));
    }
}

#pragma mark - 课件切换
- (void)watchFile:(UIButton *)aButton aIndexPath:(NSIndexPath *)aIndexPath{
    
    if ([TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Patrol) {
        return;
    }
    
    if (self.documentDelegate && [self.documentDelegate respondsToSelector:@selector(watchFile)]) {
        [self.documentDelegate watchFile];
        
    }
    if( [TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol){
        return;
    }
    
    NSString *tString;
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            
            TKMediaDocModel *tMediaDocModel =  [_iFileMutableArray objectAtIndex:aIndexPath.row];
            if ([[NSString stringWithFormat:@"%@",tMediaDocModel.fileid] isEqualToString:[NSString stringWithFormat:@"%@",[TKEduSessionHandle shareInstance].iCurrentMediaDocModel.fileid]]) {
                return;
            }
            aButton.selected = YES;
            
            NSString *tNewURLString2 = [TKUtil absolutefileUrl:tMediaDocModel.swfpath webIp:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp webPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort];
            
            if ([TKEduSessionHandle shareInstance].iCurrentMediaDocModel) {
                [TKEduSessionHandle shareInstance].iPreMediaDocModel = [TKEduSessionHandle shareInstance].iCurrentMediaDocModel;
            }
            
            [TKEduSessionHandle shareInstance].iCurrentMediaDocModel = tMediaDocModel;
            if ([TKEduSessionHandle shareInstance].isPlayMedia) {
                [TKEduSessionHandle shareInstance].isChangeMedia = YES;
                [[TKEduSessionHandle shareInstance]sessionHandleUnpublishMedia:nil];
            }else{
                BOOL tIsVideo = [TKUtil isVideo:tMediaDocModel.filetype];
                NSString * toID = [TKEduSessionHandle shareInstance].isClassBegin?sTellAll:[TKEduSessionHandle shareInstance].localUser.peerID;
                [[TKEduSessionHandle shareInstance]sessionHandlePublishMedia:tNewURLString2 hasVideo:tIsVideo fileid:[NSString stringWithFormat:@"%@",tMediaDocModel.fileid] filename:tMediaDocModel.filename toID:toID block:nil];
                
            }
            
        }
            break;
        case FileListTypeDocument:
        {
            //文档列表
            tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.DocumentList"),@([[TKEduSessionHandle shareInstance].docmentArray count])];
            
            
            
            [aButton setSelected:YES];
            
            // 上课后再下课之后点击上课时最后点击的文档
            //            if (aButton == _iPreButton && ![TKEduSessionHandle shareInstance].iIsClassEnd) {
            //                return;
            //            }
            
            TKDocmentDocModel *tDocmentDocModel = [_iFileMutableArray objectAtIndex:aIndexPath.row];
            
            if (_isClassBegin) {
                [[TKEduSessionHandle shareInstance] publishtDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender aTellLocal:YES];
                
            }else{
                
                [[TKEduSessionHandle shareInstance].whiteBoardManager changeDocumentWithFileID:tDocmentDocModel.fileid isBeginClass:[TKEduSessionHandle shareInstance].isClassBegin isPubMsg:YES];
                
                [TKEduSessionHandle shareInstance].iCurrentDocmentModel = tDocmentDocModel;
            }
            
            
            _iCurrrentButton = aButton;
            if (_iPreButton) {
                [_iPreButton setSelected:NO];
            }
            
            _iPreButton = _iCurrrentButton;
        }
            break;
            
        default:
            break;
    }
    if (self.titleBlock) {
        self.titleBlock(MTLocalized(tString));
    }
}
//涂鸦，删除文件，影音
- (void)deleteFile:(UIButton *)aButton aIndexPath:(NSIndexPath *)aIndexPath{
    if ([TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Patrol) {
        return;
    }
    
    if (self.documentDelegate && [self.documentDelegate respondsToSelector:@selector(deleteFile)]) {
        [self.documentDelegate deleteFile];
        
    }
    
    
    if( [TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol){
        return;
    }
    TKEduRoomProperty *tRoomProperty = [TKEduSessionHandle shareInstance].iRoomProperties;
    NSString *tString;
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            // 按钮点击后需要等待网络回调后才可用
            aButton.enabled = NO;
            
            //@"影音列表"
            tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.MediaList"),@([_iFileMutableArray count])];
            
            TKMediaDocModel *tMediaDocModel =  [_iFileMutableArray objectAtIndex:aIndexPath.row];
            
            [TKEduNetManager delRoomFile:tRoomProperty.iRoomId docid:[NSString stringWithFormat:@"%@",tMediaDocModel.fileid] isMedia:false aHost:tRoomProperty.sWebIp aPort:tRoomProperty.sWebPort  aDelComplete:^int(id  _Nullable response) {
                
                
                BOOL isCurrntDM = [[TKEduSessionHandle shareInstance] isEqualFileId:tMediaDocModel aSecondModel:[TKEduSessionHandle shareInstance].iCurrentMediaDocModel];
                if (isCurrntDM) {
                    [[TKEduSessionHandle shareInstance]sessionHandleUnpublishMedia:nil];
                }
                
                [[TKEduSessionHandle shareInstance] deleteaMediaDocModel:tMediaDocModel To:sTellAllExpectSender];
                [[TKEduSessionHandle shareInstance] delMediaArray:tMediaDocModel];
                _iFileMutableArray = [[[TKEduSessionHandle shareInstance] mediaArray]mutableCopy];
                
                // 网络回调完成，按钮可用
                aButton.enabled = YES;
                [_iFileTableView reloadData];
                return 1;
                
            }aNetError:^int(id  _Nullable response) {
                
                // 网络回调完成，按钮可用
                aButton.enabled = YES;
                return -1;
                
            }];
            
        }
            break;
        case FileListTypeDocument:
        {
            // 按钮点击后需要等待网络回调后才可用
            aButton.enabled = NO;
            
            //@"文档列表"
            tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.DocumentList"),@([_iFileMutableArray count])];
            
            
            TKDocmentDocModel *tDocmentDocModel = [_iFileMutableArray objectAtIndex:aIndexPath.row];
            
            [TKEduNetManager delRoomFile:tRoomProperty.iRoomId docid:[NSString stringWithFormat:@"%@",tDocmentDocModel.fileid] isMedia:false aHost:tRoomProperty.sWebIp aPort:tRoomProperty.sWebPort  aDelComplete:^int(id  _Nullable response) {
                
                [[TKEduSessionHandle shareInstance] deleteDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender];
                BOOL isCurrntDM = [[TKEduSessionHandle shareInstance] isEqualFileId:tDocmentDocModel aSecondModel:[TKEduSessionHandle shareInstance].iCurrentDocmentModel];
                if (isCurrntDM) {
                    
                    TKDocmentDocModel *tDocmentDocNextModel = [[TKEduSessionHandle shareInstance] getNextDocment:[TKEduSessionHandle shareInstance].iCurrentDocmentModel];
                    if (_isClassBegin) {
                        [[TKEduSessionHandle shareInstance] publishtDocMentDocModel:tDocmentDocNextModel To:sTellAllExpectSender aTellLocal:YES];
                        
                    }else{
                        [[TKEduSessionHandle shareInstance].whiteBoardManager changeDocumentWithFileID:tDocmentDocNextModel.fileid isBeginClass:[TKEduSessionHandle shareInstance].isClassBegin isPubMsg:YES];
                        
                    }
                    
                }
                
                [[TKEduSessionHandle shareInstance] delDocmentArray:tDocmentDocModel];
                _iFileMutableArray = [[[TKEduSessionHandle shareInstance] docmentArray]mutableCopy];
                
                // 网络回调完成，按钮可用
                aButton.enabled = YES;
                [_iFileTableView reloadData];
                return 1;
            }aNetError:^int(id  _Nullable response) {
                // 网络回调完成，按钮可用
                aButton.enabled = YES;
                return -1;
            }];
            
        }
            break;
            
        default:
            break;
    }
    if (self.titleBlock) {
        self.titleBlock(tString);
    }
    
}


#pragma mark - TKFileListHeaderView delegate

-(void)fileType:(FileType)type{
    
    _switchfileType = type;
    
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo://媒体
            
        {
            switch (type) {
                case ClassFileType://课堂文件
                    
                    _iFileMutableArray = [[[TKEduSessionHandle shareInstance] classMediaArray]mutableCopy];
                    
                    break;
                case SystemFileType://系统文件
                    
                    _iFileMutableArray = [[[TKEduSessionHandle shareInstance] systemMediaArray]mutableCopy];
                    
                    break;
                default:
                    break;
            }
        }
            break;
        case FileListTypeDocument://文档
            
        {
            switch (type) {
                case ClassFileType://课堂文件
                    
                    _iFileMutableArray = [[[TKEduSessionHandle shareInstance] classDocmentArray]mutableCopy];
                    break;
                case SystemFileType://系统文件
                    
                    _iFileMutableArray = [[[TKEduSessionHandle shareInstance] systemDocmentArray]mutableCopy];
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    [self.iFileTableView reloadData];
    
}
//名称排序
- (void)nameSort:(SortFileType)type{
    
    TKDocmentDocModel *whiteBoard;
    NSMutableArray *array = [NSMutableArray array];
    
    __block NSMutableArray *sortArray = [NSMutableArray array];
    
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
            
            array = [TKEduSessionHandle shareInstance].iMediaMutableArray;
            
            break;
        case FileListTypeDocument:
            whiteBoard = [TKEduSessionHandle shareInstance].whiteBoard;
            array = [TKEduSessionHandle shareInstance].iDocmentMutableArray;
            [array removeObjectAtIndex:0];
            break;
        default:
            break;
    }
    
    [TKSortTool sortByNameWithArray:array fileListType:_iFileListType sortWay:type sectionBlock:^(id sectionContent) {
        
    } sortTheValueOfBlock:^(id returnValue) {
        sortArray  = returnValue;
        
        
        switch (_iFileListType) {
            case FileListTypeAudioAndVideo:
                [TKEduSessionHandle shareInstance].iMediaMutableArray = sortArray;
                break;
            case FileListTypeDocument:
                
                [sortArray insertObject:whiteBoard atIndex:0];
                
                [TKEduSessionHandle shareInstance].iDocmentMutableArray = sortArray;
                break;
                
            default:
                break;
        }
        
    }];
    
    [self refreshData:_iFileListType isClassBegin:_isClassBegin];
}
//类型排序
- (void)typeSort:(SortFileType)type{
    
    TKDocmentDocModel *whiteBoard;
    NSMutableArray *array = [NSMutableArray array];
    
    __block NSMutableArray *sortArray = [NSMutableArray array];
    
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
            
            array = [TKEduSessionHandle shareInstance].iMediaMutableArray;
            
            break;
        case FileListTypeDocument:
            whiteBoard = [TKEduSessionHandle shareInstance].whiteBoard;
            array = [TKEduSessionHandle shareInstance].iDocmentMutableArray;
            [array removeObjectAtIndex:0];
            break;
        default:
            break;
    }
    
    [TKSortTool sortByTypeWithArray:array fileListType:_iFileListType sortWay:type sectionBlock:^(id sectionContent) {
        
    } sortTheValueOfBlock:^(id returnValue) {
        sortArray  = returnValue;
        
        
        switch (_iFileListType) {
            case FileListTypeAudioAndVideo:
                [TKEduSessionHandle shareInstance].iMediaMutableArray = sortArray;
                break;
            case FileListTypeDocument:
                
                [sortArray insertObject:whiteBoard atIndex:0];
                
                [TKEduSessionHandle shareInstance].iDocmentMutableArray = sortArray;
                break;
                
            default:
                break;
        }
    }];
    
    
    [self refreshData:_iFileListType isClassBegin:_isClassBegin];
}
//时间排序
- (void)timeSort:(SortFileType)type{
    
    
    TKDocmentDocModel *whiteBoard;
    NSMutableArray *array = [NSMutableArray array];
    
    __block NSMutableArray *sortArray = [NSMutableArray array];
    
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
            
            array = [TKEduSessionHandle shareInstance].iMediaMutableArray;
            
            break;
        case FileListTypeDocument:
            whiteBoard = [TKEduSessionHandle shareInstance].whiteBoard;
            
            array = [TKEduSessionHandle shareInstance].iDocmentMutableArray;
            [array removeObjectAtIndex:0];
            break;
        default:
            break;
    }
    
    
    [TKSortTool sortByTimeWithArray:array fileListType:_iFileListType sortWay:type sectionBlock:^(id sectionContent) {
        
    } sortTheValueOfBlock:^(id returnValue) {
        sortArray  = returnValue;
        
        switch (_iFileListType) {
            case FileListTypeAudioAndVideo:
                [TKEduSessionHandle shareInstance].iMediaMutableArray = sortArray;
                break;
            case FileListTypeDocument:
                
                [sortArray insertObject:whiteBoard atIndex:0];
                
                [TKEduSessionHandle shareInstance].iDocmentMutableArray = sortArray;
                break;
                
            default:
                break;
        }
        for (TKDocmentDocModel *doc in sortArray) {
            NSLog(@"%@",doc.fileid);
        }
    }];
    
    [self refreshData:_iFileListType isClassBegin:_isClassBegin];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
    
@end

//
//  TKFileListTableViewCell.m
//  EduClass
//
//  Created by lyy on 2018/4/27.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKFileListTableViewCell.h"

#import "TKDocmentDocModel.h"
#import "TKMediaDocModel.h"
#import "TKUtil.h"
#import "TKEduSessionHandle.h"
#import "TKEduRoomProperty.h"


#define ThemeKP(args) [@"TKDocumentListView." stringByAppendingString:args]

@interface TKFileListTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;




@end

@implementation TKFileListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 5;
    
    self.backView.sakura.backgroundColor(ThemeKP(@"listBackColor"));
    self.deleteBtn.sakura.image(ThemeKP(@"file_list_delete_new"),UIControlStateNormal);
    
    self.nameLabel.sakura.textColor(ThemeKP(@"coursewareButtonDefaultColor"));
    
    self.hiddenDeleteBtn = NO;
}

- (IBAction)watchClick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(watchFile:aIndexPath:)]) {
        [self.delegate watchFile:sender aIndexPath:_iIndexPath];
    }
    
    
}

- (IBAction)deleteClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteFile:aIndexPath:)]) {
        [self.delegate deleteFile:sender aIndexPath:_iIndexPath];
    }
}

-(void)configaration:(id)aModel withFileListType:(FileListType)aFileListType isClassBegin:(BOOL)isClassBegin{
    
    _iFileListType = aFileListType;
    switch (_iFileListType) {
            //视频列表
        case FileListTypeAudioAndVideo:
        {
            
            //媒体列表
            _watchBtn.sakura.image(ThemeKP(@"icon_play"),UIControlStateNormal);
            _watchBtn.sakura.image(ThemeKP(@"icon_pause"),UIControlStateSelected);
            
            
            TKMediaDocModel *tMediaModel =(TKMediaDocModel*) aModel;
            NSString *tTypeString = [TKHelperUtil docmentOrMediaImage:tMediaModel.filetype?tMediaModel.filetype:[tMediaModel.filename pathExtension]];
            
            
            _iconImageView.sakura.image(tTypeString);
            
            _nameLabel.text = tMediaModel.filename;
            TKMediaDocModel *tCurrentMediaModel = [TKEduSessionHandle shareInstance].iCurrentMediaDocModel;
            BOOL tIsCurrentDocment =[[TKEduSessionHandle shareInstance]isEqualFileId:tMediaModel aSecondModel:tCurrentMediaModel];
            
            _watchBtn.selected = tIsCurrentDocment;
            
            
        }
            break;
        case FileListTypeDocument:
        {
            //文档列表
            _watchBtn.sakura.image(ThemeKP(@"close_eyes"),UIControlStateNormal);
            _watchBtn.sakura.image(ThemeKP(@"open_eyes"),UIControlStateSelected);
            TKDocmentDocModel *tDocModel =(TKDocmentDocModel*) aModel;
            
            
            NSString *tTypeString = [TKHelperUtil docmentOrMediaImage:tDocModel.filetype?tDocModel.filetype:[tDocModel.filename pathExtension]];
            
            BOOL tIsCurrentDocment = false;
//            [TKEduSessionHandle shareInstance].iCurrentDocmentModel.fileid
//             [TKEduSessionHandle shareInstance].whiteBoardManager.currentFileId
            if (tDocModel.fileid == [TKEduSessionHandle shareInstance].iCurrentDocmentModel.fileid) {
                tIsCurrentDocment = true;
            }
//            TKDocmentDocModel *tCurrentDocModel = [TKEduSessionHandle shareInstance].iCurrentDocmentModel;
//            BOOL tIsCurrentDocment = [[TKEduSessionHandle shareInstance]isEqualFileId:tDocModel aSecondModel:tCurrentDocModel];
            
            _watchBtn.selected = tIsCurrentDocment;
            
            _iconImageView.sakura.image(ThemeKP(tTypeString));
            
            _nameLabel.text = tDocModel.filename;
           
            //如果是白板需要隐藏掉删除按钮
            if ([tDocModel.filetype isEqualToString:(@"whiteboard")]) {
                _deleteBtn.hidden = YES;
            }else{
                _deleteBtn.hidden =  NO;
            }
        }
            break;
        default:
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

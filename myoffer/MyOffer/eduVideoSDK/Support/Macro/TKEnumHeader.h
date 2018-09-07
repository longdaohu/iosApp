//
//  TKEnumHeader.h
//  EduClass
//
//  Created by lyy on 2018/5/8.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#ifndef TKEnumHeader_h
#define TKEnumHeader_h

typedef NS_ENUM(NSInteger, PromptType) {
    PromptTypeStartReady1Minute,  //距离上课还有1分钟,White 249,249,249
    PromptTypeStartPass1Minute,   //超过上课时间,White 249,249,249,blue:78,100,196
    PromptTypeEndWill1Minute,         //距离下课还1分钟,Yellow 155,136 58
    PromptTypeEndPass,             //超时,Red 215 0 0
    PromptTypeEndPass5Minute,     //超时5分钟,Red
    PromptTypeEndPass3Minute     //超时3分钟,Red,
    
};

typedef NS_ENUM(NSInteger, SpeakStatus) {
    m_RequestSpeak_Disable= 0,//没发言
    m_RequestSpeak_Allow,//发言中
    m_RequestSpeak_Pending//申请发言状态，未决状态
};

typedef NS_ENUM(NSInteger, HostStatus) {
    m_RequestHost_Disable= 0,//非主讲
    m_RequestHost_Allow,//主讲中
    m_RequestHost_Pending//申请主讲中，等待主席同意
};

enum MeetingMode
{
    m_MeetingMode_Free,  //自由会议模式
    m_MeetingMode_ChairmanControl   //主席控制模式
};
enum SpeakMode
{
    m_SpeakMode_Free,  //自由发言模式
    m_SpeakMode_Chairman //主席控制模式
};
enum ControlMode
{
    m_ControlMode_Free,  //自由发言模式
    m_ControlMode_Chairman //主席控制模式
};
enum RecordMode
{
    m_RecordMode_Free,  //自由录制模式
    m_RecordMode_Chairman//主席控制模式，只有主席和主讲可录制
};
enum KickReason
{
    m_S2C_Kickout_ChairmanKickout,            //主席剔出
    m_S2C_Kickout_Repeat                    //重复登录
};


typedef NS_ENUM(NSInteger, MessageType) {
    MessageType_Teacher,            //老师
    MessageType_Me,                 //我
    MessageType_OtherUer,          //其他
    MessageType_Message               //消息
};
typedef NS_ENUM(NSInteger, PublishState) {
    PublishState_NONE           = 0,            //没有
    PublishState_AUDIOONLY      = 1,            //只有音频
    PublishState_VIDEOONLY      = 2,            //只有视频
    PublishState_BOTH           = 3,            //都有
    PublishState_NONE_ONSTAGE   = 4,            //音视频都没有但还在台上
    PublishState_Local_NONE     = 5             //本地显示流
};

typedef NS_ENUM(NSInteger, UserType) {
    UserType_Playback  =-1,//回放
    UserType_Teacher   =0, //老师
    UserType_Assistant =1, //助教
    UserType_Student   =2, //学生
    UserType_Live      =3, //直播
    UserType_Patrol    =4, //巡课
};

typedef NS_ENUM(NSInteger, RoomType) {
    RoomType_OneToOne   = 0,            //小班
    RoomType_OneToMore  = 3,           //大班
};
typedef NS_ENUM(NSInteger, EVideoRole)
{
    EVideoRoleTeacher,//老师视频
    EVideoRoleOur,//我的视频
    EVideoRoleOther//其他人
};

typedef NS_ENUM(NSInteger, MediaProgressAction) {
    MediaProgressAction_OtherNeedProgress     =-1,            //别人向我要进度
    MediaProgressAction_PlayOrPause           =0,            //播放或暂停
    MediaProgressAction_ChangeProgress        =1            //进度改变
    
};
typedef NS_ENUM(NSInteger, Playertype) {
    PlayertypeAudio,    // 播放音频
    PlayertypeVideo     // 播放视频
};
typedef NS_ENUM(NSInteger, FileListType) {
    FileListTypeAudioAndVideo,    //视频列表
    FileListTypeDocument,        // 文档列表
    FileListTypeUserList         //用户列表
};

typedef NS_ENUM(NSInteger, FileType) {//文件类型
    ClassFileType,    //课堂文件
    SystemFileType    //公共文件
};

typedef NS_ENUM(NSInteger, DeviceType) {//设备类型
    AndroidPad,
    iPad,
    AndroidPhone,
    iPhone,
    WindowClient,
    WindowPC,
    MacClient,
    MacPC,
    AndroidTV
};

typedef NS_ENUM(NSInteger, SortFileType) {
    Sort_None,//未排序
    Sort_Descending,//降序
    Sort_Ascending,//升序
};
typedef NS_ENUM(NSInteger, PageShowType) {
    DocumentPageShow,//未排序
    UserListPageShow,//降序
};

#endif /* TKEnumHeader_h */

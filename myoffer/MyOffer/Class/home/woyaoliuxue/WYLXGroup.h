//
//  WYLXGroup.h
//  myOffer
//
//  Created by xuewuguojie on 2016/12/15.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,EditType){

    EditTypeCountry,
    EditTypeSuject,
    EditTypeUniversity,
    EditTypePhone,
    EditTypeGrade,
    EditTypeSCore,
    EditTypeRegistPhone,
    EditTypeVerificationCode,
    EditTypePasswd,

};

typedef NS_ENUM(NSInteger,CellGroupType){
    
    CellGroupTypeCell,
    CellGroupTypeView,
    
};


@interface WYLXGroup : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *placeHolder;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *areaCode;
@property(nonatomic,copy)NSString *key;
@property(nonatomic,assign)BOOL spod;
@property(nonatomic,assign)EditType groupType;
@property(nonatomic,assign)CellGroupType CellType;

@property(nonatomic,assign)CGRect titleFrame;
@property(nonatomic,assign)CGRect areacodeTFFrame;
@property(nonatomic,assign)CGRect areacodeLableFrame;
@property(nonatomic,assign)CGRect areacodeLineFrame;
@property(nonatomic,assign)CGRect inputFrame;
@property(nonatomic,assign)CGRect rightBttonFrame;
@property(nonatomic,assign)CGRect spodFrame;
@property(nonatomic,assign)CGRect lineFrame;
@property(nonatomic,assign)CGFloat cell_Height;


+ (instancetype)groupWithType:(EditType)type title:(NSString *)title placeHolder:(NSString *)placeHolder content:(NSString *)content groupKey:(NSString *)key spod:(BOOL)spod;

+ (instancetype)groupWithType:(EditType)type title:(NSString *)title placeHolder:(NSString *)placeHolder content:(NSString *)content groupKey:(NSString *)key spod:(BOOL)spod cellType:(CellGroupType)cellType;


@end

//
//  TKAudioHelper.h
//  EduClassPad
//
//  Created by ifeng on 2017/7/31.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKAudioHelper : NSObject {
    BOOL recording;
}

- (void)initSession;
- (BOOL)hasHeadset;
- (BOOL)hasMicphone;
- (void)cleanUpForEndRecording;
- (BOOL)checkAndPrepareCategoryForRecording;

@end

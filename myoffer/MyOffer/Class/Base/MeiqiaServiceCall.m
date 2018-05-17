//
//  PhoneServiceCall.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/17.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "MeiqiaServiceCall.h"
#import "MQChatViewManager.h"

@implementation MeiqiaServiceCall

+ (void)callWithController:(UIViewController *)vc{
    
#pragma mark 总之, 要自定义UI层  请参考 MQChatViewStyle.h类中的相关的方法 ,要修改逻辑相关的 请参考MQChatViewManager.h中相关的方法
#pragma mark  最简单的集成方法: 全部使用meiqia的,  不做任何自定义UI.  https://github.com/Meiqia/MeiqiaSDK-iOS
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager setoutgoingDefaultAvatarImage:[UIImage imageNamed:@"meiqia-icon"]];
    MQChatViewStyle *aStyle = [chatViewManager chatViewStyle];
    [aStyle setEnableRoundAvatar:YES];
    [aStyle setEnableOutgoingAvatar:NO];
    
    if (LOGIN) {
        MyofferUser *user = [MyofferUser defaultUser];
        [chatViewManager setClientInfo:@{@"name":user.displayname,@"tel":user.phonenumber} override:YES];
        NSString *clientId = [USDefault valueForKey:user.user_id];
        if ([clientId length] > 0) {
            [chatViewManager setLoginMQClientId:clientId];
        }else{
            [MQManager createClient:^(NSString *clientId, NSError *error) {
                if (!error) {
                    [USDefault setValue:clientId forKey:user.user_id];
                }
            }];
        }
    }else{
        NSString *off_line_value = [MQManager getCurrentClientId];
        NSString *clientId_offLine = [USDefault valueForKey:@"offLineClientKey"];
        if (!clientId_offLine) {
            [USDefault setValue:off_line_value forKey:@"offLineClientKey"];
            clientId_offLine = off_line_value;
        }
        [chatViewManager setLoginMQClientId:clientId_offLine];
    }
    [MQManager setScheduledAgentWithAgentId:@"538999aef992e2fc4f4cfc8ae250e6cc" agentGroupId:nil  scheduleRule:MQScheduleRulesRedirectNone];
    [chatViewManager pushMQChatViewControllerInViewController:vc];
}
/*
-(void)caseQQ
{
    
#pragma mark 总之, 要自定义UI层  请参考 MQChatViewStyle.h类中的相关的方法 ,要修改逻辑相关的 请参考MQChatViewManager.h中相关的方法
#pragma mark  最简单的集成方法: 全部使用meiqia的,  不做任何自定义UI.  https://github.com/Meiqia/MeiqiaSDK-iOS
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager setoutgoingDefaultAvatarImage:[UIImage imageNamed:@"meiqia-icon"]];
    MQChatViewStyle *aStyle = [chatViewManager chatViewStyle];
    [aStyle setEnableRoundAvatar:YES];
    [aStyle setEnableOutgoingAvatar:NO];
    
    if (LOGIN) {
        MyofferUser *user = [MyofferUser defaultUser];
        [chatViewManager setClientInfo:@{@"name":user.displayname,@"tel":user.phonenumber} override:YES];
        NSString *clientId = [USDefault valueForKey:user.user_id];
        if ([clientId length] > 0) {
            [MQManager setClientOnlineWithClientId:clientId success:^(MQClientOnlineResult result, MQAgent *agent, NSArray<MQMessage *> *messages) {
            } failure:^(NSError *error) {
            } receiveMessageDelegate:self];
        }else{
            [MQManager createClient:^(NSString *clientId, NSError *error) {
                if (!error) {
                    [USDefault setValue:clientId forKey:user.user_id];
                }
            }];
        }
    }else{
        NSString *off_line_value = [MQManager getCurrentClientId];
        NSString *clientId_offLine = [USDefault valueForKey:@"offLineClientKey"];
        if (!clientId_offLine) {
            [USDefault setValue:off_line_value forKey:@"offLineClientKey"];
            clientId_offLine = off_line_value;
        }
        [MQManager setClientOnlineWithClientId:clientId_offLine success:^(MQClientOnlineResult result, MQAgent *agent, NSArray<MQMessage *> *messages) {
        } failure:^(NSError *error) {
        } receiveMessageDelegate:self];
    }
    [MQManager setScheduledAgentWithAgentId:@"538999aef992e2fc4f4cfc8ae250e6cc" agentGroupId:nil  scheduleRule:MQScheduleRulesRedirectNone];
    [chatViewManager pushMQChatViewControllerInViewController:self];
}
*/

@end




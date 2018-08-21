//
//  UserDefaults.h
//  MyOffer
//
//  Created by Blankwonder on 6/22/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "KDUserDefault.h"

@interface UserDefaults : KDUserDefault

@property (copy) NSNumber *agreementAccepted;
@property (copy) NSString *introductionDismissBuildVersion;
@property (copy) NSString *introductionBuildVersion;

@end

//
//  Keychain.m
//  Netpas
//
//  Created by Blankwonder on 3/26/15.
//  Copyright (c) 2015 Blankwonder. All rights reserved.
//

#import "KDKeychain.h"

@implementation Keychain

+ (NSString *)keychainIdentifier {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
}

+ (BOOL)writeKeychainWithIdentifier:(NSString *)identifier data:(NSData *)data {
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrAccount: encodedIdentifier,
                            (__bridge id)kSecAttrService: [self keychainIdentifier]};
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL) == noErr) {
        OSStatus result = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)@{(__bridge id)kSecValueData: data});
        if (result != noErr) {
            KDClassLog(@"Error occurred when update keychian item: %d", result);
        }
        
        return result == noErr;
    } else {
        NSDictionary *item = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                               (__bridge id)kSecAttrAccount: encodedIdentifier,
                               (__bridge id)kSecAttrService: [self keychainIdentifier],
                               (__bridge id)kSecValueData: data};
        
        OSStatus result = SecItemAdd((__bridge CFDictionaryRef)item, NULL);
        if (result != noErr) {
            KDClassLog(@"Error occurred when add keychian item: %d", result);
        }
        
        return result == noErr;
    }
}

+ (NSData *)keychainItemPersistentRefWithIdentifier:(NSString *)identifier {
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrAccount: encodedIdentifier,
                            (__bridge id)kSecAttrService: [self keychainIdentifier],
                            (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne,
                            (__bridge id)kSecReturnPersistentRef: (__bridge id)kCFBooleanTrue};
    
    CFTypeRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    
    return (__bridge_transfer NSData *)result;
}

+ (NSData *)keychainItemDataWithIdentifier:(NSString *)identifier {
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrAccount: encodedIdentifier,
                            (__bridge id)kSecAttrService: [self keychainIdentifier],
                            (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne,
                            (__bridge id)kSecReturnData: (__bridge id)kCFBooleanTrue};
    
    CFTypeRef result = NULL;
    OSStatus resultStatus = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (resultStatus != noErr && resultStatus != errSecItemNotFound) {
        KDClassLog(@"Error occurred when read keychian item: %d", resultStatus);
    }
    
    return (__bridge_transfer NSData *)result;
}

+ (BOOL)deleteKeychainItemWithIdentifier:(NSString *)identifier {
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrAccount: encodedIdentifier,
                            (__bridge id)kSecAttrService: [self keychainIdentifier]};
    
    OSStatus resultStatus = SecItemDelete((__bridge CFDictionaryRef)query);
    if (resultStatus != noErr && resultStatus != errSecItemNotFound) {
        KDClassLog(@"Error occurred when delete keychian item: %d", resultStatus);
    }
    
    return resultStatus == noErr;
}



@end

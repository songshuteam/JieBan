//
//  NSString+Encryption.m
//  AnyGo
//
//  Created by tony on 8/3/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "NSString+Encryption.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Encryption)

- (NSString *)md5Encrypt {
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

@end

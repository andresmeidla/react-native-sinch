//
//  RNSinch.m
//  RNSinch
//
//  Created by fangqiang on 2017/8/3.
//  Copyright © 2017年 fangqiang. All rights reserved.
//

#import "RNSinch.h"
#import "RCTConvert.h"
#import <SinchVerification/SinchVerification.h>

@implementation RNSinch

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(sms:(NSString *)applicationKey phoneNumber:(NSString *)phoneNumber custom:(NSString *)custom callback:(RCTResponseSenderBlock)callback) {
    // Get user's current region by carrier info
    NSString* defaultRegion = [SINDeviceRegion currentCountryCode];
    NSError *parseError = nil;
    id<SINPhoneNumber> _phoneNumber = [SINPhoneNumberUtil() parse:phoneNumber
                                                    defaultRegion:defaultRegion
                                                            error:&parseError];
    if (!_phoneNumber){
        callback(@[@"Invalid phone number"]);
    }

    NSString *phoneNumberInE164 = [SINPhoneNumberUtil() formatNumber:_phoneNumber
                                                              format:SINPhoneNumberFormatE164];
    id<SINVerification> verification = [SINVerification SMSVerificationWithApplicationKey:applicationKey
                                                                              phoneNumber:phoneNumberInE164
                                                                                   custom:custom];
    self.verification = verification; // retain the verification instance
    [verification initiateWithCompletionHandler:^(id<SINInitiationResult> result, NSError *error) {
        if (result.success) {
            callback(@[[NSNull null]]);
        } else {
            callback(@[error.description]);
        }
    }];
}

RCT_EXPORT_METHOD(smsWithCountryCode:(NSString *)applicationKey phoneNumber:(NSString *)phoneNumber custom:(NSString *)custom callback:(RCTResponseSenderBlock)callback) {
    id<SINVerification> verification = [SINVerification SMSVerificationWithApplicationKey:applicationKey
                                                                              phoneNumber:phoneNumber
                                                                                   custom:custom];
    self.verification = verification; // retain the verification instance
    [verification initiateWithCompletionHandler:^(id<SINInitiationResult> result, NSError *error) {
        if (result.success) {
            callback(@[[NSNull null]]);
        } else {
            callback(@[error.description]);
        }
    }];
}

RCT_EXPORT_METHOD(verify:(NSString *)code callback:(RCTResponseSenderBlock)callback) {
    [self.verification verifyCode:code
                completionHandler:^(BOOL success, NSError* error) {
                    if (success) {
                        callback(@[[NSNull null]]);
                    } else {
                        callback(@[error.description]);
                    }
                }];
}



@end

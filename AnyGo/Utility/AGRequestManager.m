//
//  AGRequestManager.m
//  AnyGo
//
//  Created by tony on 7/29/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGRequestManager.h"

#import "AGUrlManager.h"

@implementation AGRequestManager

#pragma mark - login and register request
+ (ASIHTTPRequest *)requestlogintWithAccount:(NSString *)account password:(NSString *)pwd{
    NSURL *url = [AGUrlManager urlLoginWithAccount:account password:pwd];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    return request;
}


+ (ASIFormDataRequest *)requestWithRegisterInfo:(AGRegisterModel *)registerInfo{
    NSURL *url = [AGUrlManager urlRegister];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setPostValue:[registerInfo getAccountInfo] forKey:@"account"];
    [request setPostValue:registerInfo.password forKey:@"password"];
    [request setPostValue:registerInfo.nickname forKey:@"nickname"];
    [request setPostValue:[NSNumber numberWithInteger:registerInfo.gender] forKey:@"gender"];
    [request setPostValue:registerInfo.code forKey:@"code"];
    [request setData:UIImageJPEGRepresentation(registerInfo.faceImg, 0.3) withFileName:@"faceImg.jpg"  andContentType:@"image/jpeg" forKey:@"image"];
    
//    // 获取Caches目录路径
//    NSString *cachesPath = NSTemporaryDirectory(); //[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *imagName = [NSString stringWithFormat:@"%f.png",[[NSDate new] timeIntervalSince1970]];
//    NSString *path = [cachesPath stringByAppendingPathComponent:imagName];
//    [UIImagePNGRepresentation(registerInfo.faceImg) writeToFile:path atomically:YES];
//    
//    [request setFile:path forKey:@"image"];
    [request buildRequestHeaders];
    
    return request;
}


+ (ASIFormDataRequest *)requestResetWithAccount:(NSString *)account code:(NSString *)code password:(NSString *)pwd{
    NSURL *url = [AGUrlManager urlResetPwd];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:account forKey:@"account"];
    [request setPostValue:code forKey:@"code"];
    [request setPostValue:pwd forKey:@"newPassword"];
    
    return request;
}
@end

@implementation AGRequestManager (Disteribute)

#pragma mark - distribute plan request
+ (ASIFormDataRequest *)requestCreatePlanWithUserId:(NSString *)userId planModel:(AGJiebanPlanModel *)planModel{
    NSURL *url = [AGUrlManager urlCreatePlanWithUserId:userId];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:planModel.jiebanInfoJson forKey:@"plan"];
    
    return request;
}

+ (ASIHTTPRequest *)requestGetPlanWithUserId:(NSString *)userId planId:(NSString *)planId{
    NSURL *url = [AGUrlManager urlGetPlanWithId:planId withUserId:userId];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    return request;
}

+ (ASIFormDataRequest *)requestEditPlanWithUserId:(NSString *)userId PlanModel:(AGJiebanPlanModel *)planModel{
    NSURL *url = [AGUrlManager urlEditPlanWithId:[NSString stringWithFormat:@"%lld",planModel.jiebanId] withUserId:userId];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setValue:planModel.jiebanInfoJson forKey:@"plan"];
    
    return request;
}

+ (ASIHTTPRequest *)requestDeletePlanWithUserId:(NSString *)userId planId:(NSString *)planId{
    NSURL *url = [AGUrlManager urlDeletePlanWIthId:planId withUserId:userId];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    return request;
}

@end

@implementation AGRequestManager(feedInfo)

+ (ASIFormDataRequest *)requestDistributeFeed:(AGShareItem *)item{
    NSURL *url = [AGUrlManager urlDistributeFeed:[NSString stringWithFormat:@"%lld",item.userId]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:item.shareContent forKey:@"content"];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    if ([item.sharePhotos count] >0) {
//        for (int i=0; i<[item.sharePhotos count]; i++) {
//            UIImage *image = [item.sharePhotos objectAtIndex:i];
//            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
//            
//            [request setPostValue:[NSString stringWithFormat:@"image%d.jpeg",i] forKey:@"photoContent"];
//            [request addData:imageData withFileName:[NSString stringWithFormat:@"image%d.jpeg",i] andContentType:@"image/jpeg" forKey:@"photoContent"];
//        }
    }

    return request;
}

+ (ASIFormDataRequest *)requesDeleteFeed:(NSString *)feedId userId:(NSString *)userId{
    NSURL *url = [AGUrlManager urlDeleteFeed:userId feedId:feedId];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    return request;
}

+ (ASIHTTPRequest *)requestFeedWithUserId:(NSString *)userId pageSize:(NSInteger)pageSize lastId:(NSString *)lastId{
    NSURL *url = [AGUrlManager urlGetFeed:userId pageSize:pageSize lastId:lastId];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    return request;
}

+ (ASIHTTPRequest *)requestFeedWatchId:(NSString *)watchId userId:(NSString *)userId pageSize:(NSInteger)pageSize lastId:(NSString *)lastId{
    NSURL *url = [AGUrlManager urlGetFeed:userId watchUserId:watchId pageSize:pageSize lastId:lastId];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    return request;
}

@end

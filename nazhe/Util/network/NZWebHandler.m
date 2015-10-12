//
//  NZWebHandler.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/13.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZWebHandler.h"
#import "Reachability.h"
#import "FileDetail.h"

#define BOUNDARY @"----------cH2gL6ei4Ef1KM7cH2KM7ae0ei4gL6"

//static NSInteger const WebPostMethod = 0 ;
static NSInteger const WebGetMethod  = 1 ;
static NSInteger const WebUploadMethod  = 2 ;
static NSInteger const WebTimeOut = 10.0 ;
static NSString* const WebHandlerDomain = @"网络错误" ;

@interface NZWebHandler()
@property (nonatomic , strong) NSMutableArray* webRequests ;
@end

@implementation NZWebHandler

+ (BOOL) networkAvailable
{
    if( [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable ){
        return NO ;
    }
    return YES ;
}

- (id) init
{
    self = [super init] ;
    if( self ){
        self.webRequests = [[NSMutableArray alloc] init] ;
    }
    return self ;
}

- (void) cancelAllRequest
{
    if( nil != self.webRequests )
        for ( ASIFormDataRequest * request in self.webRequests ) {
            [request clearDelegatesAndCancel] ;
        }
}

- (NSString *)GetBaseURL:(NSString *)urlString {
    
    NSString *baseURL = [NSString stringWithFormat:@"%@/%@", apiBaseUrl, urlString];
    return baseURL;
}

- (NSString *)GetImgBaseURL:(NSString *)urlString {
    
    NSString *baseURL = [NSString stringWithFormat:@"%@/%@", imgBaseUrl, urlString];
    return baseURL;
}

- (void)postURLStr:(NSString *)url postDic:(NSDictionary *)postDic block:(WebBaseHandlerBlock )block
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[self GetBaseURL:url]]];
    [self httpAddHeadParamWith:request] ;
    for( NSString * key in postDic.allKeys ){
        [request setPostValue:postDic[key] forKey:key] ;
    }
    request.timeOutSeconds = WebTimeOut ;
    [self.webRequests addObject:request] ;
    NSLog(@"===url:%@===", request.url);
    NSLog(@"===post:%@===", [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding]);
    typeof(request) _wRequest = request ;
    [request setCompletionBlock:^{
        NSDictionary * result = [NSJSONSerialization JSONObjectWithData:_wRequest.responseData options:NSJSONReadingMutableContainers error:nil] ;
        [_webRequests removeObject:_wRequest];
        NSLog(@"===data:%@===", result);
//        NSLog(@"post请求地址:%@,参数:%@",_wRequest.url,[[NSString alloc] initWithData:_wRequest.postBody encoding:NSUTF8StringEncoding]);
        block(result,nil) ;
    }] ;
    [request setFailedBlock:^{
        [_webRequests removeObject:_wRequest];
        NSError *error = [NSError errorWithDomain:WebHandlerDomain code:WebErrorRequestFalse userInfo:nil];
        NSLog(@"===error:%@===",error);
//        NSLog("%@,\n出错地址:%@",error,url);
        block(nil, error);
    }];
    [request startAsynchronous];
    
}

/*****************************   上传图片   *****************************/
+ (id)upload:(NSString *)url widthParams:(NSDictionary *)params {
    
    NSError *err = nil;
    NSMutableURLRequest *myRequest = [ [NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:0];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setValue:[@"multipart/form-data; boundary=" stringByAppendingString:BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    for(NSString *key in params) {
        id content = [params objectForKey:key];
        if ([content isKindOfClass:[NSString class]] || [content isKindOfClass:[NSNumber class]]) {
            NSString *param = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",BOUNDARY,key,content,nil];
            [body appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
            
        } else if([content isKindOfClass:[FileDetail class]]) {
            
            FileDetail *file = (FileDetail *)content;
            
            NSString *param = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n",BOUNDARY,key,file.name,nil];
            [body appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:file.data];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    NSString *endString = [NSString stringWithFormat:@"--%@--",BOUNDARY];
    
    [body appendData:[endString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [myRequest setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:&err];
    NSLog(@"myRequest = %@",myRequest.URL);
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:returnData options:noErr error:nil];
    
    return jsonObj;
}

- (void)getURLStr:(NSString *)url block:(WebBaseHandlerBlock )block
{
//    if( false == [self checkParamAndNetwork:WebGetMethod url:url postDic:nil uploadFilePath:nil block:block] ){
//        return ;
//    }
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"GET"] ;
    [self httpAddHeadParamWith:request] ;
    request.timeOutSeconds = WebTimeOut;
    [_webRequests addObject:request];
    
    __weak ASIFormDataRequest *weakRequest = request;
    [request setCompletionBlock:^{
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:weakRequest.responseData options:NSJSONReadingMutableContainers error:nil];
        [_webRequests removeObject:weakRequest];
        NSLog(@"get请求地址:%@",weakRequest.url);
        block(result,nil);
    }];
    [request setFailedBlock:^{
        [_webRequests removeObject:weakRequest];
        NSError *error = [NSError errorWithDomain:WebHandlerDomain code:WebErrorRequestFalse userInfo:nil];
        NSLog("%@,\n出错地址:%@",error,url);
        block(nil, error);
    }];
    [request startAsynchronous];
}
- (void)uploadFileURLStr:(NSString *)url postDic:(NSDictionary *)dic postFile:(NSString *)filePath block:(WebBaseHandlerBlock)block
{
//    if( false == [self checkParamAndNetwork:WebUploadMethod url:url postDic:dic uploadFilePath:filePath block:block] ){
//        return ;
//    }
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self httpAddHeadParamWith:request] ;
    for (NSString *key in dic.allKeys) {
        [request setPostValue:dic[key] forKey:key];
    }
    [request addFile:filePath forKey:@"headImg"];
    request.timeOutSeconds = 120.0f ;
    [_webRequests addObject:request];
    NSLog(@"===url:%@===", request.url);
    NSLog(@"===post:%@===", [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding]);
    __weak ASIFormDataRequest *weakRequest = request;
    [request setCompletionBlock:^{
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:weakRequest.responseData options:NSJSONReadingMutableContainers error:nil];
        [_webRequests removeObject:weakRequest];
        NSLog(@"===data:%@===", result);
//        NSLog(@"uploadFile请求地址:%@,参数:%@",weakRequest.url,[[NSString alloc] initWithData:weakRequest.postBody encoding:NSUTF8StringEncoding]);
        block(result,nil);
    }];
    [request setFailedBlock:^{
        [_webRequests removeObject:weakRequest];
        NSError *error = [NSError errorWithDomain:WebHandlerDomain code:WebErrorRequestFalse userInfo:nil];
        NSLog(@"===error:%@===",error);
//        NSLog("%@",error);
        block(nil, error);
    }];
    [request startAsynchronous];
}
- (void)uploadFileURLStr:(NSString *)url postDic:(NSDictionary *)dic postFile:(NSString *)filePath block:(WebBaseHandlerBlock)block progressView:(UIProgressView *)progressView
{
//    if( false == [self checkParamAndNetwork:WebUploadMethod url:url postDic:dic uploadFilePath:filePath block:block] ){
//        return ;
//    }
    if (progressView == nil) {
        NSError *error = [[NSError alloc] initWithDomain:WebHandlerDomain code:WebErrorParamFalse userInfo:nil];
        NSLog("无进度条%@",error);
        block(nil,error);
        return;
    }
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self httpAddHeadParamWith:request] ;
    for (NSString *key in dic.allKeys) {
        [request setPostValue:dic[key] forKey:key];
    }
    [request setUploadProgressDelegate:progressView];
    [request setPostValue:@"uploadFile" forKey:@"name"];
    [request addFile:filePath forKey:@"uploadFile"];
    request.timeOutSeconds = 120.0f ;
    [_webRequests addObject:request];
    
    __weak ASIFormDataRequest *weakRequest = request;
    [request setCompletionBlock:^{
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:weakRequest.responseData options:NSJSONReadingMutableContainers error:nil];
        [_webRequests removeObject:weakRequest];
        NSLog(@"uploadFile请求地址:%@,参数:%@",weakRequest.url,[[NSString alloc] initWithData:weakRequest.postBody encoding:NSUTF8StringEncoding]);
        block(result,nil);
    }];
    [request setFailedBlock:^{
        [_webRequests removeObject:weakRequest];
        NSError *error = [NSError errorWithDomain:WebHandlerDomain code:WebErrorRequestFalse userInfo:nil];
        NSLog("%@",error);
        block(nil, error);
    }];
}

// ------ private

- (BOOL) checkParamAndNetwork:(NSInteger) method url:(NSString *)url postDic:(NSDictionary *)postDic uploadFilePath:(NSString *)uploadFilePath  block:(WebBaseHandlerBlock )block
{
    switch (method) {
        case 0:
        {
            if( nil == url || nil == postDic ){
                NSError * error = [[NSError alloc] initWithDomain:WebHandlerDomain code:WebErrorParamFalse userInfo:nil] ;
                NSLog("%@,\n出错地址:%@",error,url);
                block(nil , error) ;
                return false;
            }
        }
            break;
        case 1:
        {
            if( nil == url){
                NSError * error = [[NSError alloc] initWithDomain:WebHandlerDomain code:WebErrorParamFalse userInfo:nil] ;
                NSLog("%@,\n出错地址:%@",error,url);
                block(nil , error) ;
                return false;
            }
        }
            break;
        case 2:
        {
            if( nil == url || nil == uploadFilePath ){
                NSError * error = [[NSError alloc] initWithDomain:WebHandlerDomain code:WebErrorParamFalse userInfo:nil] ;
                NSLog("%@,\n出错地址:%@",error,url);
                block(nil , error) ;
                return false;
            }
        }
            break ;
            
        default:
            break;
    }
    if( NO == [[self class] networkAvailable] ){
        NSError * error = [[NSError alloc] initWithDomain:WebHandlerDomain code:WebErrorNetWorkNotAvilable userInfo:nil] ;
        NSLog("%@,\n出错地址:%@",error,url);
        block(nil , error) ;
        return false;
    }
    
    return true ;
}

- (void) httpAddHeadParamWith:(ASIFormDataRequest *) request
{
    if( self.requestHeadDict == nil ){
        return ;
    }
    for( NSString *key in self.requestHeadDict.allKeys ){
        [request addRequestHeader:key value: self.requestHeadDict[key]] ;
    }
    [self.requestHeadDict removeAllObjects] ;
}



@end

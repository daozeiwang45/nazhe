//
//  NZWebHandler.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/13.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIFormDataRequest.h"


typedef NS_ENUM(NSInteger, SFBWebError)
{
    // 参数错误
    WebErrorParamFalse = 0 ,
    // 返回值错误
    WebErrorReturealse ,
    // 请求错误
    WebErrorRequestFalse ,
    // 网络不可用
    WebErrorNetWorkNotAvilable ,
    
};

typedef void(^WebBaseHandlerBlock)(NSDictionary * retInfo , NSError * error);

@interface NZWebHandler : NSObject

@property(nonatomic , strong) NSMutableDictionary * requestHeadDict ;

+ (BOOL) networkAvailable  ;
- (void) cancelAllRequest ;

/**
 *  获取API完整URL路径
 *
 *  @param urlString URL
 *
 *  @return 完整APIURL路径
 */
-(NSString *)GetBaseURL:(NSString *)urlString;

/**
 *  获取Img完整URL路径
 *
 *  @param urlString URL
 *
 *  @return 完整ImgURL路径
 */
-(NSString *)GetImgBaseURL:(NSString *)urlString;

/**
 *  @author jichwAndy, 15-04-20 22:04:27
 *
 *  上传图片
 *
 *  @param url    <#url description#>
 *  @param params <#params description#>
 *
 *  @return <#return value description#>
 */
+ (id)upload:(NSString *)url widthParams:(NSDictionary *)params;

- (void)postURLStr:(NSString *)url postDic:(NSDictionary *)postDic block:(WebBaseHandlerBlock )block;
- (void)getURLStr:(NSString *)url block:(WebBaseHandlerBlock )block;
- (void)uploadFileURLStr:(NSString *)url postDic:(NSDictionary *)dic postFile:(NSString *)filePath block:(WebBaseHandlerBlock)block;
- (void)uploadFileURLStr:(NSString *)url postDic:(NSDictionary *)dic postFile:(NSString *)filePath block:(WebBaseHandlerBlock)block progressView:(UIProgressView *)progressView;

@end

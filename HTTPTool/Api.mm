//
//  Api.m
//  earthquakeWarn
//
//  Created by 罗籽科技 on 15/10/29.
//  Copyright © 2015年 degal. All rights reserved.
//

#import "Api.h"
#import "SBJson.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLResponseSerialization.h"


@implementation Api


-(id)init:(id)delegate
{
    return [self init:delegate tag:nil cache:0];
}
-(id)init:(id)delegate cache:(int)cache
{
    return [self init:delegate tag:nil cache:0];
}
-(id)init:(id)delegate tag:(id)tag
{
    return [self init:delegate tag:tag cache:0];
}
-(id)init:(id)delegate tag:(id)tag cache:(int)cache
{
    self._delegate = delegate;
    self._tag = tag;
    self._cache = cache;

    return self;
}


-(void) startRequest:(NSString*)api
{
    [self startRequest:api params:nil imageData:nil field:nil isPost:NO];
}

-(void) startRequest:(NSString*)api params:(NSDictionary *)params
{
    [self startRequest:api params:params imageData:nil field:nil isPost:NO];
}

-(void) startPostRequest:(NSString*)api params:(NSDictionary *)params
{
    [self startRequest:api params:params imageData:nil field:nil isPost:YES];
}

-(void) startRequest:(NSString*)api params:(NSDictionary *)params imageData:(NSData*)imageData field:(NSString*)field isPost:(BOOL)isPost
{
    

            
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            
            
            //manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
            if (self.HideHud == NO) {
                 [MBProgressHUD showMessage:Tip toView:APPDELEGATE.window];
            }
            
 
            
            if(imageData && field)
            {
                
                [ manager POST:api parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    
                } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//                    [hud hide:YES];
                    
                    
                    [MBProgressHUD hideAllHUDsForView:APPDELEGATE.window animated:YES];
                    
                } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//                    [hud hide:YES];
                    
                    [MBProgressHUD hideAllHUDsForView:APPDELEGATE.window animated:YES];
                }];
                
            }else if (isPost)
            {
                
                
                [manager POST:api parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    //返回成功 数据源为responseObject
//                    [hud hide:YES];
                    
                    [MBProgressHUD hideAllHUDsForView:APPDELEGATE.window animated:YES];
                    
                    TLog(@"%@ response: %@ ", api, operation.responseString);
                    
                    [self callback:operation.responseString];
                  
                    
                } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                    //返回失败 数据源为error
//                    [hud hide:YES];
                    
                    [MBProgressHUD hideAllHUDsForView:APPDELEGATE.window animated:YES];
                    
                    [self showError:@"服务器连接超时, 请检查网络"];
                    
                    TLog(@"message: %@", operation.error);
                   
                }];
            }else{
                
                [manager GET:api parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    
                    TLog(@"%@ response: %@ ", api, operation.responseString);
                    
                    [self callback:operation.responseString];
                    
                    
                    [MBProgressHUD hideAllHUDsForView:APPDELEGATE.window animated:YES];
//                    [hud hide:YES];
                    
                } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                    [self showError:@"服务器连接超时, 请检查网络"];
                    
                    TLog(@"message: %@", operation.responseString);
                    
                    
                    [MBProgressHUD hideAllHUDsForView:APPDELEGATE.window animated:YES];
                    
//                    [hud hide:YES];
                }];
           
            }
    
    
}


-(void) callback:(NSString*)response
{
    
    if(!self._delegate) return;
    
    id JSON = [response JSONValue];
    //!JSON || ![JSON isKindOfClass:[NSDictionary class]]
    if (!JSON) {
        TLog(@"返回格式不正确");
        return;
    }
    [self showLoaded:JSON];
//    id success = [JSON objectForKey:@"success"];
//    NSString* message = [JSON objectForKey:@"message"];
//    NSNumber* code = [JSON objectForKey:@"error"];
//    id data = [JSON objectForKey:@"data"];
//    
//    if(success && ![success boolValue]) {
//        if([message isKindOfClass:[NSString class]] && message.length>0) {
//        } else {
//            message = @"";
//        }
//        if(code && [code isKindOfClass:[NSNumber class]]) {
//            [self showError:message];
//        }
//        return;
//    }
//    if(data) {
//        [self showLoaded:data];
//    } else {
//        [self showLoaded:JSON];
//    }
}


-(void) showLoaded:(id)JSON
{
    
    if(!self._delegate) return;
    
    if ([self._delegate respondsToSelector:@selector(loaded:tag:)])
    {
        [self._delegate performSelector:@selector(loaded:tag:) withObject:JSON withObject:self._tag];
        return;
    }
    
    if ([self._delegate respondsToSelector:@selector(loaded:)])
    {
        [self._delegate performSelector:@selector(loaded:) withObject:JSON];
    }
}
-(void) showError:(NSString*)error
{
    TLog(@"showError:%@", error);
    
    
    if(!self._delegate) return;
    
    if ([self._delegate respondsToSelector:@selector(error:tag:)])
    {
        [self._delegate performSelector:@selector(error:tag:) withObject:error withObject:self._tag];
        return;
    }
    
    if ([self._delegate respondsToSelector:@selector(error:)])
    {
        [self._delegate performSelector:@selector(error:) withObject:error];
    }
}

+ (MBProgressHUD *)hudWithTitle:(NSString *)title showView:(UIView *)showView
{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:showView];
    
    [showView addSubview:hud];
    
    hud.labelText = title;
    
    [hud show:YES];
    
    return hud;
}

/*
-(void)initWithTitle:(NSString * )title ShowView:(UIView *)showView
{

    
    hud = [[MBProgressHUD alloc]initWithView:showView];
    [showView addSubview:hud];
   	hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.margin = 8.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:1.0];
   
    
}
 */



@end

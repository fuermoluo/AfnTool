//
//  Api.h
//  earthquakeWarn
//
//  Created by 罗籽科技 on 15/10/29.
//  Copyright © 2015年 degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface Api : NSObject
//{
//    MBProgressHUD *hud;
//}

@property (nonatomic, retain)id _delegate;
@property (nonatomic, retain)id _tag;
@property (nonatomic, assign)int _cache;
@property (nonatomic, assign)BOOL HideHud;

@property (nonatomic, strong)UIView * hudView;

-(void) callback:(NSString*)response;

-(id)init:(id)delegate;
-(id)init:(id)delegate cache:(int)cache;
-(id)init:(id)delegate tag:(id)tag;
-(id)init:(id)delegate tag:(id)tag cache:(int)cache;

-(void) startRequest:(NSString*)api;

-(void) startPostRequest:(NSString*)api params:(NSDictionary *)params;

-(void) startRequest:(NSString*)api params:(NSMutableDictionary *)params;

//-(void)initWithTitle:(NSString * )title ShowView:(UIView *)showView;

+ (MBProgressHUD *)hudWithTitle:(NSString *)title showView:(UIView *)showView;


@end

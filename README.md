基于AFNetworking的网络请求工具封装，使用简单

使用方法：
1.导入头文件  #import "Api.h"

2.    NSString * url = [NSString stringWithFormat:@"%@yours",kHttpURL];

      Api * api = [[Api alloc]init:self tag:@"查询购物车"];//添加tag，用于区分同一个页面多次请求

      api.hudView =self.view;//是否显示hud

      NSDictionary * paras = @{@"service":@"cart_query";//参数

      [api startPostRequest:url params:paras];

3. 在回调里处理数据
#pragma  -- mark ApiDelegate回调函数
-(void)loaded:(id)response tag:(NSString*)tag{
//成功回调
}

-(void)error:(id)response tag:(NSString*)tag{
//失败回调
}

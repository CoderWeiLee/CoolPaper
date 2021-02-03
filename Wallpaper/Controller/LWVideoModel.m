//
//  LWVideoModel.m
//  Wallpaper
//
//  Created by 李伟 on 2021/2/3.
//

#import "LWVideoModel.h"
#import <MJExtension/MJExtension.h>
@implementation LWVideoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"id": @"ID"};
}
@end

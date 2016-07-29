//
//  TYRefreshHeader.h
//  TYRefresh
//
//  Created by tiny on 16/7/29.
//  Copyright © 2016年 tiny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TYRefreshCompleteBlock)();

@interface TYRefreshHeader : NSObject

/**
 *  给ScrollView添加一个header刷新功能
 *
 *  @param scrollView scollView
 *  @param block      刷新回调
 *
 *  @return 创建完成的对象
 */
+(instancetype)headerOfScrollView:(UIScrollView*)scrollView
                     refreshBlock:(TYRefreshCompleteBlock)block;

/**
 *  开始刷新
 */
-(void)beginRefreshing;

/**
 *  结束刷新
 */
-(void)endRefreshing;

/**
 *  刷新中文本
 */
@property (nonatomic, copy, readwrite) NSString *loadingText;

/**
 *  下拉刷新文本
 */
@property (nonatomic, copy, readwrite) NSString *pulldownText;

/**
 *  松开刷新文本
 */
@property (nonatomic, copy, readwrite) NSString *releaseText;

@end

//
//  TYRefreshFooter.h
//  TYRefresh
//
//  Created by tiny on 16/7/29.
//  Copyright © 2016年 tiny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TYRefreshCompleteBlock)();

@interface TYRefreshFooter : NSObject

/**
 *  绑定滚动视图
 *
 *  @param scrollView 滚动视图
 *  @param block      刷新回调
 */
+ (instancetype)footerOfScrollView:(UIScrollView *)scrollView
                        refreshingBlock:(TYRefreshCompleteBlock)block;

/**
 *  开始刷新
 */
- (void)beginRefreshing;

/**
 *  结束刷新
 */
- (void)endRefreshing;

/**
 *  无数据停止刷新
 */
- (void)endRefreshingWithNoMoreDataWithTitle:(NSString *)title;

/**
 *  重设无数据状态
 */
- (void)resetNoMoreData;
@end

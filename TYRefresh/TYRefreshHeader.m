//
//  TYRefreshHeader.m
//  TYRefresh
//
//  Created by tiny on 16/7/29.
//  Copyright © 2016年 tiny. All rights reserved.
//

#import "TYRefreshHeader.h"

@interface TYRefreshHeader ()
{
    CGFloat    _lastPosition;
    CGFloat    _contentHeight;
    CGFloat     _headerHeight;
    BOOL        _isRefreshing;

}

@property (nonatomic,copy) TYRefreshCompleteBlock refreshingBlock;

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)UIView *headerView;

@property (nonatomic,strong)UILabel *statusLabel;

@property (nonatomic,strong)UIImageView *arrowView;

@property (nonatomic,strong)UIActivityIndicatorView *indicator;

@end

@implementation TYRefreshHeader

-(instancetype)init
{
    if (self = [super init]) {
        _loadingText    = @"加载中";
        _pulldownText   = @"下拉刷新";
        _releaseText    = @"松开刷新";
    }
    return self;
}

-(void)initialize
{
    CGFloat headerHeight = 35;
    _headerHeight = headerHeight;
    _isRefreshing = NO;
    _lastPosition = 0;
    
    CGFloat scrollViewW = self.scrollView.bounds.size.width;
    CGFloat arrowW  = 13;
    CGFloat arrowH  = headerHeight;
    CGFloat labelw  = 130;
    CGFloat labelH  = headerHeight;
    //初始化UI
    _headerView         = [[UIView alloc] init];
    _headerView.frame   = CGRectMake(0,-_headerHeight , scrollViewW, _headerHeight);
    [_scrollView addSubview:_headerView];
    
    //布局内部的子控件
    _statusLabel                = [[UILabel alloc] init];
    _statusLabel.frame          = CGRectMake((scrollViewW - labelw)/2, 0, labelw, labelH);
    _statusLabel.textAlignment  = NSTextAlignmentCenter;
    _statusLabel.font           = [UIFont systemFontOfSize:14];
    _statusLabel.textColor      = [UIColor blackColor];
    _statusLabel.text           = _pulldownText;
    [_headerView addSubview:_statusLabel];
    
    _arrowView                  = [[UIImageView alloc] init];
    _arrowView.frame            = CGRectMake((scrollViewW - labelw)/2-arrowW-10, 0, arrowW, arrowH);
    _arrowView.image            = [UIImage imageNamed:@"arrow"];
    [_headerView addSubview:_arrowView];
    _arrowView.hidden           = NO;
    
    _indicator          = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.frame    = CGRectMake((scrollViewW-labelw)/2-arrowW, 0, arrowW, arrowH);
    [_headerView addSubview:_indicator];
    _indicator.hidden   = YES;
    
    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - kvo回调
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        _contentHeight = _scrollView.contentSize.height;
        
        if (_scrollView.isDragging) {
            CGFloat currentPosition = _scrollView.contentOffset.y;
            
            if (!_isRefreshing) {
                [UIView animateWithDuration:0.3f animations:^{
                    //下拉过程超过_headerHeight*1.5
                    if (currentPosition < -_headerHeight* 1.5 ) {
                        _statusLabel.text       = _releaseText;
                        _arrowView.transform    = CGAffineTransformMakeRotation(M_PI);
                    }else {
                        //上拉
                        if (currentPosition - _lastPosition > 5) {
                            _lastPosition = currentPosition;
                            _statusLabel.text = _pulldownText;
                            _arrowView.transform = CGAffineTransformMakeRotation(M_PI*2);
                            //下拉不超过_headerHeight*1.5
                        }else if(_lastPosition - currentPosition > 5) {
                            _lastPosition = currentPosition;
                        }
                    }
                }];
            }
            
        }else {
            //松开手时
            if ([_statusLabel.text isEqualToString:_releaseText]) {
                [self beginRefreshing];
            }
        }
        
    }
    
}


+(instancetype)headerOfScrollView:(UIScrollView *)scrollView refreshBlock:(TYRefreshCompleteBlock)block
{
    TYRefreshHeader *header = [[TYRefreshHeader alloc] init];
    header.refreshingBlock = block;
    header.scrollView = scrollView;
    [header initialize];
    return header;
}

-(void)beginRefreshing
{
    if (!_isRefreshing) {
        _isRefreshing = YES;
        
        _statusLabel.text   = _loadingText;
        _arrowView.hidden   = YES;
        _indicator.hidden   = NO;
        [_indicator startAnimating];
        
        [UIView animateWithDuration:0.3f animations:^{
            CGFloat currentPosition = _scrollView.contentOffset.y;
            if (currentPosition > -_headerHeight * 1.5) {
                _scrollView.contentOffset = CGPointMake(0, currentPosition - _headerHeight * 1.5);
            }
            _scrollView.contentInset = UIEdgeInsetsMake(_headerHeight * 1.5, 0, 0, 0);
        }];
        
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
    }
}


-(void)endRefreshing
{
    _isRefreshing = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3f animations:^{
            CGFloat currentPosition = _scrollView.contentOffset.y;
            if (currentPosition != 0) {
                _scrollView.contentOffset    = CGPointMake(0, currentPosition + _headerHeight * 1.5);
                _scrollView.contentInset     = UIEdgeInsetsMake(0, 0, 0, 0);
                
                _statusLabel.text = _pulldownText;
                
                _arrowView.hidden    = NO;
                _arrowView.transform = CGAffineTransformMakeRotation(M_PI*2);
                
                [_indicator stopAnimating];
                _indicator.hidden = YES;
            }
        }];
    });
}

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - setter

- (void)setLoadingText:(NSString *)loadingText {
    _loadingText        = loadingText;
    _statusLabel.text   = _loadingText;
}

- (void)setReleaseText:(NSString *)releaseText {
    _releaseText        = releaseText;
    _statusLabel.text   = _releaseText;
}

- (void)setPulldownText:(NSString *)pulldownText {
    _pulldownText       = pulldownText;
    _statusLabel.text   = _pulldownText;
}

@end

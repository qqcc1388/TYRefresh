//
//  ViewController.m
//  TYRefresh
//
//  Created by tiny on 16/7/29.
//  Copyright © 2016年 tiny. All rights reserved.
//

#import "ViewController.h"
#import "TYRefreshHeader.h"
#import "TYRefreshFooter.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)TYRefreshHeader *header;
@property (nonatomic,strong)TYRefreshFooter *footer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    _header =  [TYRefreshHeader headerOfScrollView:self.tableView refreshBlock:^{

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"开始刷新了");
            sleep(2);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_header endRefreshing];
                NSLog(@"结束刷新了");
            });
        });
    }];
//
    _footer =  [TYRefreshFooter footerOfScrollView:self.tableView refreshingBlock:^{
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSLog(@"开始刷新了");
                    sleep(2);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_footer endRefreshing];
                        NSLog(@"结束刷新了");
                    });
                });
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"xx";
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

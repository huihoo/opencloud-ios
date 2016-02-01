//
//  HomeViewController.m
//  OpenCloud
//
//  Created by colin liao on 7/17/15.
//  Copyright (c) 2015 colin liao. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeListTableViewCell.h"
#import "DateModel.h"
#import "SizeModel.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,ObtainDataDelegate>

@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,strong)UITableView *listTableView;

@end

@implementation HomeViewController

- (NSMutableArray *)listArray {
    
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self UI];
    [APPManager sharedAppManager].obtainDataDelegate = self;
    [[APPManager sharedAppManager] obatainHomeListData];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    self.tabBarController.navigationItem.titleView = [[APPManager sharedAppManager] getNaViLabel:ControllerType_Home];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//获取信息回调
- (void)obtainData:(id)info {
    [self.listArray removeAllObjects];
    for (NSString *str in info) {
        NSArray *array = [str componentsSeparatedByString:@"\t"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"name"] = array[0];
        dic[@"type"] = array[1];
        dic[@"size"] = [SizeModel sizeBOfString:array[2]] ;
        dic[@"time"] = [DateModel dateInvertToDateStr:array[3]];
        [self.listArray addObject:dic];
    }
    [self.listTableView reloadData];
}

- (void)UI {
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    screenRect.size.height -= 49;
    UITableView *listTableView = [[UITableView alloc] initWithFrame:screenRect style:UITableViewStylePlain];
    listTableView.delegate = self;
    listTableView.dataSource = self;
    [self.view addSubview:listTableView];
    listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.listTableView = listTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"HomeListTableViewCell";
    HomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        
        cell = WL_XIB(@"HomeListTableViewCell");
    }
    cell.infoDic = self.listArray[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"dled");
    HomeListTableViewCell *cell = (HomeListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [UpYunHttpRequest deleteFileWithDic:cell.infoDic Success:^(id info) {
        
    } Failure:^(NSError *error) {
        
    }];
}

@end

//
//  TransferViewController.m
//  OpenCloud
//
//  Created by colin liao on 7/17/15.
//  Copyright (c) 2015 colin liao. All rights reserved.
//

#import "TransferViewController.h"
#import "TransferCollectionViewCell.h"
#include "FileNameObj.h"

NSString* kTransferCollectionViewCell = @"TransferCollectionViewCell";

@interface TransferViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LoadMessageChangedDelegate>

@property(weak,nonatomic)IBOutlet UICollectionView* transferCollectionView;
@property(nonatomic)TransferCollectionViewCell*  transferCell;

@end

@implementation TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    self.transferCollectionView.dataSource = self;
    self.transferCollectionView.delegate = self;
    [APPManager sharedAppManager].delegate = self;
    
    [self.transferCollectionView registerNib:WL_NIB(kTransferCollectionViewCell) forCellWithReuseIdentifier:kTransferCollectionViewCell];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.tabBarController.navigationItem.titleView = [[APPManager sharedAppManager] getNaViLabel:ControllerType_Transfer];
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [APPManager sharedAppManager].fileNameArray.count;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TransferCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTransferCollectionViewCell forIndexPath:indexPath];
    [cell initWithIndex:indexPath];
    if (indexPath.row == 0) {
        self.transferCell = cell;
    }
    FileNameObj* obj = [APPManager sharedAppManager].fileNameArray[indexPath.row];
    [cell changePercent:obj.curSchedule];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(300, 50);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsMake(80, 10, 10, 10);
}



-(void)refresh:(NSArray *)uploadFileArray withIsNeedReload:(BOOL)isNeedRload
{
    NSLog(@"代理");
    if (isNeedRload) {
        [self.transferCollectionView reloadData];
    }else
    {
//        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        TransferCollectionViewCell* cell = [self.transferCollectionView dequeueReusableCellWithReuseIdentifier:kTransferCollectionViewCell forIndexPath:indexPath];
        
        FileNameObj* obj = [uploadFileArray objectAtIndex:0];
        [self.transferCell changePercent:obj.curSchedule];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

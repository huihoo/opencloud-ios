//
//  AddViewController.m
//  OpenCloud
//
//  Created by colin liao on 7/17/15.
//  Copyright (c) 2015 colin liao. All rights reserved.
//

#import "AddViewController.h"
#import "ZYQAssetPickerController.h"
#import "FileNameObj.h"
#import "FileDirectoryCollectionViewCell.h"

NSString* kFileDirectoryCollectionViewCell = @"FileDirectoryCollectionViewCell";

@interface AddViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ZYQAssetPickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property(weak,nonatomic)IBOutlet UICollectionView* fileDirectorCollectionView;
@property(nonatomic)NSString* curChooseDirectorStr;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置要放置的文件夹
    
    self.fileDirectorCollectionView.delegate = self;
    self.fileDirectorCollectionView.dataSource = self;
    
    [self.fileDirectorCollectionView registerNib:WL_NIB(kFileDirectoryCollectionViewCell) forCellWithReuseIdentifier:kFileDirectoryCollectionViewCell];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.tabBarController.navigationItem.titleView = [[APPManager sharedAppManager] getNaViLabel:ControllerType_Add];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [APPManager sharedAppManager].fileDirectoryArray.count;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FileDirectoryCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFileDirectoryCollectionViewCell forIndexPath:indexPath];
    [cell initWithFileDirectoryObject:[APPManager sharedAppManager].fileDirectoryArray[indexPath.row]];
    
    return cell;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(80, 20, 70, 20);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float wide = (IOS_IPHONE_WINDOW_WIDE - 40 - 40)/3.0;
    return CGSizeMake(wide, (wide/80)*100);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FileDirectoryCollectionViewCell* cell = (FileDirectoryCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    self.curChooseDirectorStr = cell.fileDirectoryObj.fileDirectory;
    
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册读取", nil];
    [actionSheet showInView:self.view];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"]) {
        UIImage* image = [info  objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSData* imageData = UIImagePNGRepresentation(image);
        if (nil == imageData) {
            imageData = UIImageJPEGRepresentation(image, 1.0f);
        }
        
        //本地操作
        //获取documents的文件路径
        NSString* documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //获取到文件管理器
        NSFileManager* fileManager = [NSFileManager defaultManager];
        
        //将data拷贝到文件管理器中 路径为documents中存储为pnrg
        //        [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        //判断师傅已经有upload文件夹
        if (![fileManager fileExistsAtPath:[documentsPath stringByAppendingString:@"/upload"]]) {
            [fileManager createDirectoryAtPath:[documentsPath stringByAppendingString:@"/upload"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        //将路径设置到upload上面
        NSString* uploadPath = [documentsPath stringByAppendingPathComponent:@"upload"];
        //每个将要上传的文件用时间取名区分
        NSTimeInterval timeInterval =  [[NSDate date] timeIntervalSince1970];
        NSString* fileNameString = [NSString stringWithFormat:@"%.f",timeInterval];
        
        
        //将要上传的文件夹放在本地报错，app重启的时候能够找到上传到的哪个位置
        [[NSUserDefaults standardUserDefaults] setValue:self.curChooseDirectorStr forKey:[NSString stringWithFormat:@"%@.png",fileNameString]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //将将要上床的文件加入到appmanager中控制
        [[APPManager sharedAppManager] addFileNameObj:[[FileNameObj alloc] initWithString:[NSString stringWithFormat:@"%@.png",fileNameString]]];
        
        //将文件放入到本地
        [fileManager createFileAtPath:[uploadPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileNameString]] contents:imageData attributes:nil];
        
        
        [[APPManager sharedAppManager] startUpload];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

//
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        NSLog(@"取消");
    }
    
    switch (buttonIndex) {
        case 0:
            //打开相机
            [self loadCamera];
            break;
        case 1:
            //从相册读取
            [self loadLocalPhoto];
            break;
            
        default:
            break;
    }
}

-(void)loadCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES
                         completion:nil];
    }else
    {
        NSLog(@"模拟器不能打开相机");
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"模拟器不能打开相机，请别装逼"];
    }
}

-(void)loadLocalPhoto
{
//    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    picker.delegate =  self;
//    picker.allowsEditing = YES;
//    [self presentViewController:picker animated:YES completion:nil];
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
    
    picker.maximumNumberOfSelection = 10;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
        if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
            return duration >= 5;
        }else{
            return  YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    for (int i = 0 ; i < assets.count; i++) {
        ALAsset *asset= assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        
        
        NSData* imageData = UIImagePNGRepresentation(tempImg);
        if (nil == imageData) {
            imageData = UIImageJPEGRepresentation(tempImg, 1.0f);
        }
        //本地操作
        //获取documents的文件路径
        NSString* documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //获取到文件管理器
        NSFileManager* fileManager = [NSFileManager defaultManager];

        //将data拷贝到文件管理器中 路径为documents中存储为pnrg
//        [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        //判断师傅已经有upload文件夹
        if (![fileManager fileExistsAtPath:[documentsPath stringByAppendingString:@"/upload"]]) {
            [fileManager createDirectoryAtPath:[documentsPath stringByAppendingString:@"/upload"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        //将路径设置到upload上面
        NSString* uploadPath = [documentsPath stringByAppendingPathComponent:@"upload"];
        //每个将要上传的文件用时间取名区分
        NSTimeInterval timeInterval =  [[NSDate date] timeIntervalSince1970];
        NSString* fileNameString = [NSString stringWithFormat:@"%.f",timeInterval+i];
        
        
        //将要上传的文件夹放在本地报错，app重启的时候能够找到上传到的哪个位置
        [[NSUserDefaults standardUserDefaults] setValue:self.curChooseDirectorStr forKey:[NSString stringWithFormat:@"%@.png",fileNameString]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //将将要上床的文件加入到appmanager中控制
        [[APPManager sharedAppManager] addFileNameObj:[[FileNameObj alloc] initWithString:[NSString stringWithFormat:@"%@.png",fileNameString]]];
        
        //将文件放入到本地
        [fileManager createFileAtPath:[uploadPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileNameString]] contents:imageData attributes:nil];
    }
    
    [[APPManager sharedAppManager] startUpload];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

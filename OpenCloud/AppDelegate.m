//
//  AppDelegate.m
//  OpenCloud
//
//  Created by colin liao on 7/17/15.
//  Copyright (c) 2015 colin liao. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ShareViewController.h"
#import "TransferViewController.h"
#import "MoreViewController.h"
#import "AddViewController.h"
#include "FileNameObj.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //初始化uitabbarcontroller
    UITabBarController* tabBarVC = [[UITabBarController alloc] init];
    UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:tabBarVC];
    
    
    
    
    
    
    //图片的设置
    UIImage* homeSelectImage = [UIImage imageNamed:@"cloud_choose@2x.png"];
    homeSelectImage = [homeSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage* homeNormalImage = [UIImage imageNamed:@"cloud@2x.png"];
    homeNormalImage = [homeNormalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIImage* shareSelectImage = [UIImage imageNamed:@"share_choose@2x.png"];
    shareSelectImage = [shareSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage* shareNormalImage = [UIImage imageNamed:@"share@2x.png"];
    shareNormalImage = [shareNormalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIImage* transferSelectImage = [UIImage imageNamed:@"transfer_choose@2x.png"];
    transferSelectImage = [transferSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage* transferNormalImage = [UIImage imageNamed:@"transfer@2x.png"];
    transferNormalImage = [transferNormalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIImage* moreSelectImage = [UIImage imageNamed:@"more_choose@2x.png"];
    moreSelectImage = [moreSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage* moreNormalImage = [UIImage imageNamed:@"more@2x.png"];
    moreNormalImage = [moreNormalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage* addSelectImage = [UIImage imageNamed:@"add_choose@2x.png"];
    addSelectImage = [addSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage* addNormalImage = [UIImage imageNamed:@"add@2x.png"];
    addNormalImage = [addNormalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //初始化每个controller
    HomeViewController* homeVC = [[HomeViewController alloc] init];
    homeVC.tabBarItem.title = @"首页";
    homeVC.tabBarItem.selectedImage = homeSelectImage;
    homeVC.tabBarItem.image = homeNormalImage;
    
    ShareViewController* shareVC = [[ShareViewController alloc] init];
    shareVC.tabBarItem.title = @"分享";
    shareVC.tabBarItem.image = shareNormalImage;
    shareVC.tabBarItem.selectedImage = shareSelectImage;
    
    TransferViewController * transferVC = [[TransferViewController alloc] init];
    transferVC.tabBarItem.title = @"传输";
    transferVC.tabBarItem.image = transferNormalImage;
    transferVC.tabBarItem.selectedImage = transferSelectImage;
    
    MoreViewController* moreVC = [[MoreViewController alloc] init];
    moreVC.tabBarItem.title = @"设置";
    moreVC.tabBarItem.image = moreNormalImage;
    moreVC.tabBarItem.selectedImage = moreSelectImage;
    
    AddViewController* addVC = [[AddViewController alloc] init];
    addVC.tabBarItem.image = addNormalImage;
    addVC.tabBarItem.selectedImage = addSelectImage;
    addVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);

    //设置文字选中与非选中的颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:WLColor(64, 224, 208), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    //消除tabbar和navi的边框
//    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
//    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    
    
    tabBarVC.viewControllers = @[homeVC,shareVC,addVC,transferVC,moreVC];
    tabBarVC.tabBar.barTintColor = WLColor(240 , 255 , 255 );
//    UIView* barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tabBarVC.tabBar.frame.size.width, tabBarVC.tabBar.frame.size.height)];
//    barView.backgroundColor = WLColor(240 , 255 , 255 );
//    [tabBarVC.tabBar insertSubview:barView atIndex:0];
    tabBarVC.navigationController.navigationBar.barTintColor = WLColor(64, 224, 208);
    
    //消除导航边框
    
    self.window.rootViewController = naviVC;
    [self.window makeKeyAndVisible];
    
    
    //读取upload中文件(先判断是否有upload文件夹，如果没有将不进行后面的操作)，即时没有上传完成的文件，加入到上传列表中去
    //获取documents的文件路径
    NSString* documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[documentsPath stringByAppendingString:@"/upload"]]) {
        
        NSArray* fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[documentsPath stringByAppendingString:@"/upload"] error:nil];
        if (0< fileArray.count) {
            for (int i = 0; i < fileArray.count; i++) {
                NSString* fileStr = [fileArray objectAtIndex:i];
                if ([fileStr containsString:@".png"]) {
                    //文件存在需要上传
                    [[APPManager sharedAppManager] addFileNameObj:[[FileNameObj alloc] initWithString:fileStr]];
                }
            }
            
            [[APPManager sharedAppManager] startUpload];
        }else
        {
            NSLog(@"有文件夹但是没有需要上传的文件");
        }
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "ColinLiao.OpenCloud" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"OpenCloud" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"OpenCloud.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

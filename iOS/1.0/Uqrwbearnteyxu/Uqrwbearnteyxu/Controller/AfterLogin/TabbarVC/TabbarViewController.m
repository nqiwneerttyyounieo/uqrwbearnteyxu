//
//  TabbarViewController.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 05/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "TabbarViewController.h"
#import "DCPathButton.h"


@interface TabbarViewController ()<DCPathButtonDelegate,UITabBarControllerDelegate>

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.delegate=self;
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:FALSE];

    
    [self configureDCPathButton];
    // Do any additional setup after loading the view.
    
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

- (void)configureDCPathButton
{
    // Configure center button
    //
    DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                         highlightedImage:[UIImage imageNamed:@"chooser-button-tab-highlighted"]];
    dcPathButton.delegate = self;
    
    // Configure item buttons
    //
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-music"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-music-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-place"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-place-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-camera"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-camera-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    
    // Add the item button into the center button
    //
    [dcPathButton addPathItems:@[itemButton_1,
                                 itemButton_2,
                                 itemButton_3,
                                 ]];
    
    // Change the bloom radius, default is 105.0f
    //
    dcPathButton.bloomRadius = 90;
    
    // Change the DCButton's center
    //
    dcPathButton.dcButtonCenter = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 25.5f);
    
    // Setting the DCButton appearance
    //
    dcPathButton.allowSounds = YES;
    dcPathButton.allowCenterButtonRotation = YES;
    
    dcPathButton.bottomViewColor = [UIColor grayColor];
    
    dcPathButton.bloomDirection = kDCPathButtonBloomDirectionTop;
    
    [self.view addSubview:dcPathButton];
    
}

#pragma mark - Tabbar Delegates

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
{
    if (tabBarController.selectedIndex == 2) {
            return NO;
    }
    
    return YES;
}



#pragma mark - DCPathButton Delegate

- (void)willPresentDCPathButtonItems:(DCPathButton *)dcPathButton {
    
    NSLog(@"ItemButton will present");
    
}

- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    NSLog(@"You tap %@ at index : %lu", dcPathButton, (unsigned long)itemButtonIndex);
}

- (void)didPresentDCPathButtonItems:(DCPathButton *)dcPathButton {
    
    NSLog(@"ItemButton did present");
    
}

- (void)willDismissDCPathButtonItems:(DCPathButton *)dcPathButton{
    
}
- (void)didDismissDCPathButtonItems:(DCPathButton *)dcPathButton{
    
}


@end

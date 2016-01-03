//
//  ProfileViewController.m
//  Uqrwbearnteyxu
//
//  Created by Developer on 03/01/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import "ProfileViewController.h"
#import "SlideNavigationController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.navigationController.navigationBar.hidden =  YES;
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.navigationController.navigationBar.hidden =  NO;
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

- (IBAction)btnMenuClicked:(id)sender {
    [[SlideNavigationController sharedInstance] openMenu:MenuRight withCompletion:^{
        
    }];
    
}

@end

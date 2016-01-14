//
//  RadarViewController.m
//  Uqrwbearnteyxu
//
//  Created by Developer on 14/01/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import "RadarViewController.h"
#import "VIewUtility.h"
#import "UserModel.h"
#import "CommansUtility.h"

#define smallPadding 2
#define largePadding 25

@interface RadarViewController()

@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@end

@implementation RadarViewController{
    NSMutableArray *arrayOfViews;
    NSCache *imageCache;
    UserModel *userModel;
    
    UIImageView *profileImageView;
    UIImage *imgProfile;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    imageCache = [[NSCache alloc]init];
    userModel = [[CommansUtility sharedInstance]loadUserObjectWithKey:@"loggedInUser"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        //  You may want to cache this explicitly instead of reloading every time.
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userModel.strProfileURLThumb]];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Capture the indexPath variable, not the cell variable, and use that
            profileImageView.image = image;
        });
    });
    
    
    [self addRadar];
 
    [self.sliderView addTarget:self action:@selector(sliderViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    
}


-(void)addRadar{
    int xPos = 0;
    int yPos = 80;
    int width = self.view.frame.size.width;
    int height = self.view.frame.size.width;
    
    int numberOfViews = (width / 27)/2;
    
    arrayOfViews = [[NSMutableArray alloc]init];
    
    self.sliderView.maximumValue = numberOfViews+1;
    self.sliderView.minimumValue = 0;
    
    for (int k=0; k<(numberOfViews+1); k++) {
        UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        mainView.backgroundColor = [UIColor grayColor];
        [VIewUtility addHexagoneShapeMaskFor:mainView];
        [self.view addSubview:mainView];
        
        
        if(k == (numberOfViews)){
            UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos+smallPadding, yPos+smallPadding, width-(2*smallPadding), height-(2*smallPadding))];
            lineView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82.0/255.0 blue:89.0/255.0 alpha:1];
            [VIewUtility addHexagoneShapeMaskFor:lineView];
            
            lineView.image =imgProfile;
            lineView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82.0/255.0 blue:89.0/255.0 alpha:1];
            profileImageView = lineView;
            [self.view addSubview:lineView];

        }
        else{
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(xPos+smallPadding, yPos+smallPadding, width-(2*smallPadding), height-(2*smallPadding))];
            lineView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82.0/255.0 blue:89.0/255.0 alpha:1];
            [VIewUtility addHexagoneShapeMaskFor:lineView];
            
            [self.view addSubview:lineView];
    
        }



        xPos = xPos + largePadding;
        yPos = yPos + largePadding;
        width = width - (2*largePadding);
        height = height - (2*largePadding);
        
        [arrayOfViews addObject:mainView];
    }
}


-(void)sliderViewValueChanged:(id)sender{
    int value = ceil(self.sliderView.value);
    value =(int) arrayOfViews.count - value;
    
    for (int k=0; k<arrayOfViews.count; k++) {
        UIView *view = [arrayOfViews objectAtIndex:k];
        if(k==value){
            view.backgroundColor = [UIColor colorWithRed:148/255 green:249.0/255 blue:253.255 alpha:1];
        }
        else{
            view.backgroundColor = [UIColor grayColor];
        }
    }
}

@end

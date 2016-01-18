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
#define largePadding 10

@interface RadarViewController()

@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@end

@implementation RadarViewController{
    NSMutableArray *arrayOfLineViews,*arrayOfViews;
    NSCache *imageCache;
    UserModel *userModel;
    
    UIImageView *profileImageView;
    UIImage *imgProfile;
    int _xPosForRadar;
    int _yPosForRadar;

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
    
    
 
    [self addOuterLayers];
    [self addRadar];

    
    [self.sliderView addTarget:self action:@selector(sliderViewValueChanged:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    
}


-(void)addOuterLayers{
    int xPos = -64;
    int yPos = 0;
    int width = self.view.frame.size.width+128;
    int height = self.view.frame.size.width+128;
    
    int numberOfViews = (width / largePadding)/2;
    
    UIView *mainContainer = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    mainContainer.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:mainContainer];

    int xPosForInner = 0;
    int yPosForInner = 0;
    int widthForInner = self.view.frame.size.width+140;
    int heightForInner = self.view.frame.size.width+140;

    
    for (int k=0; k<(numberOfViews-2); k++) {
        UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(xPosForInner, yPosForInner, width, height)];
        mainView.backgroundColor = [UIColor grayColor];
        [VIewUtility addHexagoneShapeMaskFor:mainView];
        [mainContainer addSubview:mainView];
        
        
        if(k == (numberOfViews)){
            UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(xPosForInner+smallPadding, yPosForInner+smallPadding, width-(2*smallPadding), height-(2*smallPadding))];
            lineView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82.0/255.0 blue:89.0/255.0 alpha:1];
            [VIewUtility addHexagoneShapeMaskFor:lineView];
            
            lineView.image =imgProfile;
            lineView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82.0/255.0 blue:89.0/255.0 alpha:1];
            profileImageView = lineView;
            [mainContainer addSubview:lineView];
            
        }
        else{
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(xPosForInner+smallPadding, yPosForInner+smallPadding, width-(2*smallPadding), height-(2*smallPadding))];
            lineView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82.0/255.0 blue:89.0/255.0 alpha:1];
            [VIewUtility addHexagoneShapeMaskFor:lineView];
            
            [mainContainer addSubview:lineView];
            
        }
        
        
        
        xPosForInner = xPosForInner + largePadding;
        yPosForInner = yPosForInner + largePadding;
        width = width - (2*largePadding);
        height = height - (2*largePadding);
        
        xPos = xPos + largePadding;
        yPos = yPos + largePadding;

        NSLog(@"XPOS %d",xPos);
        
        if(xPos>0){
            _xPosForRadar = xPos;
            _yPosForRadar = yPos;
            break;
        }
    }

}


-(void)addRadar{
    int xPos = _xPosForRadar;
    int yPos = _yPosForRadar;
    int width = self.view.frame.size.width- (_xPosForRadar *2);
    int height = self.view.frame.size.width - (_xPosForRadar *2);
    
    int numberOfViews = (width / largePadding)/2;
    
    arrayOfViews = [[NSMutableArray alloc]init];
    arrayOfLineViews = [[NSMutableArray alloc]init];
    
    self.sliderView.maximumValue = numberOfViews-2;
    self.sliderView.minimumValue = 0;
    
    for (int k=0; k<(numberOfViews-2); k++) {
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
            [arrayOfViews addObject:lineView];

        }
        else{
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(xPos+smallPadding, yPos+smallPadding, width-(2*smallPadding), height-(2*smallPadding))];
            lineView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82.0/255.0 blue:89.0/255.0 alpha:1];
            [VIewUtility addHexagoneShapeMaskFor:lineView];
            
            [self.view addSubview:lineView];
            [arrayOfViews addObject:lineView];
            
    
        }



        xPos = xPos + largePadding;
        yPos = yPos + largePadding;
        width = width - (2*largePadding);
        height = height - (2*largePadding);
        
        [arrayOfLineViews addObject:mainView];

    }
}

#pragma mark - Slider values event
#pragma mark 

-(void)sliderViewValueChanged:(id)sender{
    int value = ceil(self.sliderView.value);
    value =(int) arrayOfLineViews.count - value;
    
    for (int k=0; k<arrayOfLineViews.count; k++) {
        UIView *view = [arrayOfLineViews objectAtIndex:k];
        if(k==value){
            view.backgroundColor = [UIColor colorWithRed:148/255 green:249.0/255 blue:253.255 alpha:1];
            
            UIView *mainView = [arrayOfViews objectAtIndex:k];
            mainView.backgroundColor =[UIColor redColor];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(mainView.frame.size.width/2, 0, 20, 20)];
            btn.backgroundColor = [UIColor yellowColor];
            
            [mainView addSubview:btn];
            
        }
        else{
            view.backgroundColor = [UIColor grayColor];
        }
    }
}

@end

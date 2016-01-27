//
//  RadarFriendDetailViewController.m
//  CustomDatePicker
//
//  Created by Developer on 23/01/16.
//  Copyright © 2016 Vignet. All rights reserved.
//

#import "RadarFriendDetailViewController.h"
#import "VIewUtility.h"
#import "PPImageScrollingCellView.h"

@interface RadarFriendDetailViewController()
@property (nonatomic,weak)IBOutlet UIImageView *imgViewProfile;
@property (nonatomic,weak)IBOutlet UILabel *lblProfileName;
@property (nonatomic,weak)IBOutlet UILabel *lblStatus;
@property (nonatomic,weak)IBOutlet UILabel *lblDistance;

@property (nonatomic,weak)IBOutlet PPImageScrollingCellView *sportsView;


@end


@implementation RadarFriendDetailViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUp];
    self.view.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82/255.0 blue:89/255.0 alpha:0.8];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


-(void)setUp{
    [self setUpProfile];
    
    NSArray *array = @[
                       @{ @"category": @"Your sports (25)",
                          @"images":
                              @[
                                  @{ @"name":@"icon29.png", @"title":@"A-0"},
                                  @{ @"name":@"icon29.png", @"title":@"A-1"},
                                  @{ @"name":@"icon29.png", @"title":@"A-2"},
                                  @{ @"name":@"icon29.png", @"title":@"A-3"},
                                  @{ @"name":@"icon29.png", @"title":@"A-4"},
                                  @{ @"name":@"icon29.png", @"title":@"A-5"}
                                  
                                  ]
                          }
                       ];
    

    
    [self setImageData:[array objectAtIndex:0]];
    
}

-(void)setUpProfile{
    [VIewUtility addHexagoneShapeMaskFor:self.imgViewProfile];
    //self.imgViewProfile.image = [UIImage imageNamed:@"icon29.png"];
    
    self.lblProfileName.text = self.friendModel.strFirstName;
    self.lblStatus.text = self.friendModel.strClientUserName;
    self.lblDistance.text = @"";
    self.imgViewProfile.backgroundColor = [UIColor lightGrayColor];
    NSLog(@"URL %@",self.friendModel.strThumbImgPath);
    if(self.friendModel.strThumbImgPath.length){
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        //  You may want to cache this explicitly instead of reloading every time.
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.friendModel.strThumbImgPath]];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Capture the indexPath variable, not the cell variable, and use that
            self.imgViewProfile.image = image;
        });
    });
    }
    
}

- (void)setImageData:(NSDictionary*)collectionImageData
{
    self.sportsView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82/255.0 blue:89/255.0 alpha:0.8];
    
    [self.sportsView setImageData:[collectionImageData objectForKey:@"images"]];
}


@end

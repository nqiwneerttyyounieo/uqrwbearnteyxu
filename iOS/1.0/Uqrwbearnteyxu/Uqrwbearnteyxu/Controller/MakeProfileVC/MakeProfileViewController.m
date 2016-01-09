//
//  MakeProfileViewController.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 06/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "MakeProfileViewController.h"
#import "TextFieldValidator.h"
#import "VIewUtility.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AADatePicker.h"
#import "CommansUtility.h"


@interface MakeProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imgviewProfile;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *btnMale;
@property (strong, nonatomic) IBOutlet UIButton *btnFemale;
@property (strong, nonatomic) IBOutlet UIButton *btnGo;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtUserName;

@property   (strong,nonatomic)UIImagePickerController *cameraPicker;
@property   (strong,nonatomic)UIImagePickerController *imagePicker;
@end

@implementation MakeProfileViewController{
    UITapGestureRecognizer *tapGuestureForKeyboard;
    AADatePicker *datePicker;
    UITextField *activeTextfield;
    
    UITapGestureRecognizer *tapGuesture;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    UserModel *model = [[CommansUtility sharedInstance]loadUserObjectWithKey:@"loggedInUser"];

    
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


#pragma mark - SetUp
#pragma mark

-(void)setUp{
    [self setUpTextfields];
    [self setUpHexagonShapes];
    [self addTapGuesture];
    [self setupDatePicker];
    [self leftPanelView:self.txtUserName withImage:[UIImage imageNamed:@"person-icon.png"]];

}
-(void)addTapGuestureForKeyboard{
    if(tapGuestureForKeyboard){
        [self.view removeGestureRecognizer:tapGuestureForKeyboard];
    }
    
    tapGuestureForKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGuestureKeyboardFired:)];
    [self.view addGestureRecognizer:tapGuestureForKeyboard];
}


-(void)SetDatePickerTime:(UIDatePicker *)picker{
    
}
-(void)setupDatePicker{
    NSLocale *uk = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setLocale:uk];
    //[uk release];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
  
    [self.datePicker addTarget:self action:@selector(SetDatePickerTime:) forControlEvents:UIControlEventValueChanged];
    
//    [self.datePicker setValue:[UIColor colorWithRed:70/255.0f green:161/255.0f blue:174/255.0f alpha:1.0f] forKeyPath:@"textColor"];

  //  [self.datePicker setCalendar:cal];
  //  [UIView appearanceWhenContainedIn:[UITableView class], [UIDatePicker class], nil].backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];

  //  self.datePicker.tintColor = [UIColor whiteColor];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker setValue:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f] forKeyPath:@"textColor"];
    SEL selector = NSSelectorFromString(@"setHighlightsToday:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
    BOOL no = NO;
    [invocation setSelector:selector];
    [invocation setArgument:&no atIndex:2];
    [invocation invokeWithTarget:self.datePicker];
    
    return;
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-mm-DD"];
    
    NSDate *minimum = [formatter dateFromString:@"1950-01-01"];

    datePicker = [[AADatePicker alloc] initWithFrame:CGRectMake(0, 20, 320, 264)];//datePicker.delegate = self;
    [self.view addSubview:datePicker];
}

-(void)setUpHexagonShapes{
    [VIewUtility addHexagoneShapeMaskFor:self.btnGo];
    [VIewUtility addHexagoneShapeMaskFor:self.imgviewProfile];
}


-(void)setUpTextfields{
   // [self setupAlerts];
    [self addBottomBorder:self.txtUserName];
}

-(void)setupAlerts{
    [self.txtUserName addRegx:@"" withMsg:@"You username is already taken by another person. Please choose diffrent one."];
}

-(void)setUpActionSheet{
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Gallery",
                                @"Camera",
                                nil];
        popup.tag = 1;
        [popup showInView:self.view];
}

-(void)addBottomBorder:(UIView *)view{
    CALayer *layer=[[CALayer alloc]init];
    layer.frame=CGRectMake(0, view.frame.size.height-1, view.frame.size.width,1);
    layer.backgroundColor=[UIColor whiteColor].CGColor;
    
    [view.layer addSublayer:layer];
}

-(void)addTapGuesture{
    tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGuestureForProfile:)];
    self.imgviewProfile.userInteractionEnabled =YES;
    [self.imgviewProfile addGestureRecognizer:tapGuesture];
}

-(void)leftPanelView:(UITextField *)txt withImage:(UIImage *)image{
    UIView *panel =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:panel.bounds];
    imageview.image=image;
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [panel addSubview:imageview];
    
    txt.leftView = panel;
    txt.leftViewMode =UITextFieldViewModeAlways;
    
}


#pragma mark - Tap guesture

-(void)tapGuestureKeyboardFired:(UITapGestureRecognizer *)guesture{
        [self.view removeGestureRecognizer:tapGuesture];
        tapGuesture=nil;
        if(activeTextfield){
            [activeTextfield resignFirstResponder];
            //[self animateTextField:activeTextfield up:NO];
        }
}
-(void)tapGuestureForProfile:(UITapGestureRecognizer *)guesture{
    [self setUpActionSheet];
}


#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextfield=textField;
    [self addTapGuestureForKeyboard];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextfield = nil;
}

-(void)tapGuestureFired:(UITapGestureRecognizer *)tap{
    [self.view removeGestureRecognizer:tapGuesture];
    tapGuesture=nil;
    if(activeTextfield){
        [activeTextfield resignFirstResponder];
        //[self animateTextField:activeTextfield up:NO];
    }
}



#pragma mark - ActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
                [self showGallery];
    }
    else if (buttonIndex==1)
    {
        [self showCamera];
    }
}

-(void)showCamera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.cameraPicker=[[UIImagePickerController alloc]init];
        self.cameraPicker.delegate=self;
        self.cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.cameraPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        
        
        //  self.cameraPicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
        self.cameraPicker.modalPresentationStyle = UIModalPresentationFullScreen;
        
        
        self.cameraPicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        
        [self presentViewController:self.cameraPicker animated:YES completion:nil];
    }
    
}

-(void)showGallery
{
    self.imagePicker=[[UIImagePickerController alloc]init];
    self.imagePicker.delegate=self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    self.imagePicker.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
}

- (void) imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];

    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo)
    {
        UIImage *aImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        self.imgviewProfile.contentMode = UIViewContentModeScaleToFill;
        
        self.imgviewProfile.image= aImage;
        
    }
    
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Button delegate

- (IBAction)btnLogoutClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

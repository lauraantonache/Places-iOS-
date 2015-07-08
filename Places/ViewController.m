//
//  ViewController.m
//  Places
//
//  Created by iOS3 on 07/07/15.
//  Copyright (c) 2015 lauraa. All rights reserved.
//

#import "ViewController.h"
#import "Profile.h"
#import "Settings.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (weak, nonatomic) IBOutlet UIView* settingsView;
@property (weak, nonatomic) IBOutlet UIView* profileView;

@property (strong, nonatomic) Profile* profile;

@property (strong,nonatomic) IBOutlet UILabel* firstNameLabel;
@property (strong,nonatomic) IBOutlet UILabel* lastNameLabel;

@property (strong, nonatomic) IBOutlet UITextField* firstName;
@property (strong, nonatomic) IBOutlet UITextField* lastName;
@property (weak, nonatomic) IBOutlet UIDatePicker* birthday;

@property (strong, nonatomic) IBOutlet UIImageView* profilePicture;

@property (strong, nonatomic) Settings* setting;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint* redViewCenteredToButtonConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* profileButtonWidthConstraint;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _profile = [Profile new];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    

}

bool isKeyBoardEnabled;
CGRect frameEndUser ;
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
        double textPositionRelativeToKeyboard;
    if (isKeyBoardEnabled )
    {
        if ([_lastName isFirstResponder])
        {
            textPositionRelativeToKeyboard =  _lastName.frame.origin.y + _lastName.frame.size.height
            -  (self.view.frame.size.height - self.view.frame.origin.y- frameEndUser.size.height);
        }
        else if([_firstName isFirstResponder])
        {
            textPositionRelativeToKeyboard =  _firstName.frame.origin.y + _firstName.frame.size.height
            -  (self.view.frame.size.height -self.view.frame.origin.y- frameEndUser.size.height);
        }
        
        if(textPositionRelativeToKeyboard > 0 )
        {
            CGRect newFrame = self.view.frame;
            newFrame.origin.y = -2*textPositionRelativeToKeyboard - 52;
            
            [self.view setFrame:newFrame];
        }
        else if (textPositionRelativeToKeyboard < -2*(_firstName.frame.size.height))
        {
            CGRect newFrame = self.view.frame;
            newFrame.origin.y = 0;
            
            [self.view setFrame:newFrame];
        }

    }
}

-(void)keyboardWillShow: (NSNotification *) object
{
    isKeyBoardEnabled = YES;
    NSDictionary* userInfo = [NSDictionary new];
    userInfo = object.userInfo;
    
    frameEndUser = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
 //   CGRect frame = [[userInfo[UIKeyboardFrameEndUserInfoKey]] CGRectValue];
    double textPositionRelativeToKeyboard;
    
    if ([_lastName isFirstResponder])
    {
        textPositionRelativeToKeyboard =  _lastName.frame.origin.y + _lastName.frame.size.height
        -  (self.view.frame.size.height - frameEndUser.size.height);
    }
    else if([_firstName isFirstResponder])
    {
        textPositionRelativeToKeyboard =  _firstName.frame.origin.y + _firstName.frame.size.height
        -  (self.view.frame.size.height - frameEndUser.size.height);
    }
    
    if(textPositionRelativeToKeyboard > 0 )
    {
        CGRect newFrame = self.view.frame;
        newFrame.origin.y = -2*textPositionRelativeToKeyboard - 52;
        
        [self.view setFrame:newFrame];
    }
}

-(void)keyboardWillHide: (id) object
{
    isKeyBoardEnabled = NO;
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = 0;
    
    [self.view setFrame:newFrame];
}

- (IBAction)buttonPressed:(UIButton*)sender
{
    if (![sender isSelected])
    {
        if ([sender isEqual:_profileButton]) {
            [_profileButton setSelected:YES];
            [_settingsButton setSelected:NO];
            [_profileView setHidden:NO];
            [_settingsView setHidden:YES];
            self.redViewCenteredToButtonConstraint.constant = 0;
        }
        else if ([sender isEqual:_settingsButton])
        {
            [_profileButton setSelected:NO];
            [_settingsButton setSelected:YES];
            [_profileView setHidden:YES];
            [_settingsView setHidden:NO];
            //self.redViewCenteredToButtonConstraint.constant = 100;
            self.redViewCenteredToButtonConstraint.constant = _profileButton.frame.size.width;
        }
        
        [UIView animateWithDuration:0.2 animations:^
         {
             [self.view layoutIfNeeded];
         }];
    }
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if([_settingsButton isSelected])
    {
     self.redViewCenteredToButtonConstraint.constant = _profileButton.frame.size.width;
    }
    else
    {
        self.redViewCenteredToButtonConstraint.constant = 0;
    }
    [self.view layoutIfNeeded];
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:_firstName])
    {
        _profile.firstName = textField.text;
        //NSLog(@"%@",_profile.firstName);
    }
    else if ([textField isEqual:_lastName])
    {
        _profile.lastName = textField.text;
       // NSLog(@"%@",_profile.lastName);
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_firstName])
    {
        [_lastName becomeFirstResponder];
        return YES;
    }
    else if ([textField isEqual:_lastName])
    {
        if(_profile.firstName != nil && _profile.lastName != nil)
        {
            [_birthday becomeFirstResponder];
            [_lastName resignFirstResponder];
            return YES;
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter both names" delegate: nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            //alert.title = @"Enter both names";
            //UIColor* color = [UIColor new];
            if(_firstName.text == nil || _profile.firstName == nil || [_firstName.text length]== 0)
                _firstNameLabel.textColor = [UIColor redColor];
            if(_lastName.text == nil || _profile.lastName == nil || [_lastName.text length] == 0)
                _lastNameLabel.textColor = [UIColor redColor];
            

            [alert show];
        }
    }
    
    return NO;
}


-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_firstName])
    {
        _firstNameLabel.textColor = [UIColor blackColor];
    }
    if ([textField isEqual:_lastName])
    {
        _lastNameLabel.textColor = [UIColor blackColor];
    }
    return YES;
}


-(IBAction)changedDate:(UIDatePicker*)sender
{
    _profile.birthday = sender.date;
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd/MMM/yyyy";
    NSString *formattedDate = [NSString new];
    formattedDate = [dateFormatter stringFromDate:_profile.birthday];
    NSLog(@"%@",formattedDate);
    
}

-(IBAction)touchedThePicture:(id)sender
{

    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Select Photo from Gallery", nil];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
        [self uploadPictureFrom:UIImagePickerControllerSourceTypeCamera];
    else if (buttonIndex == 1)
        [self uploadPictureFrom:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)uploadPictureFrom:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController* imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    _profile.image = info[UIImagePickerControllerOriginalImage];
    _profilePicture.image = _profile.image;
}



-(void) closeKeyboard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

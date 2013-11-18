//
//  ChildViewController.m
//  InstrumentionDemo
//
//  Created by Nicolas Flacco on 11/15/13.
//  Copyright (c) 2013 Nicolas Flacco. All rights reserved.
//

#import "ChildViewController.h"

@interface ChildViewController ()

@end

@implementation ChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // A button to change background color
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Change Color" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 50.0, 160.0, 40.0);
    [self.view addSubview:button];
    
    // A text view (used to show keyboard event detection)
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(45,100,200,300)];
    textView.font = [UIFont fontWithName:@"Helvetica" size:12];
    textView.font = [UIFont boldSystemFontOfSize:12];
    textView.backgroundColor = [UIColor grayColor];
    textView.scrollEnabled = YES;
    textView.pagingEnabled = YES;
    textView.editable = YES;
    textView.text = @"...";
    textView.delegate = self;
    [self.view addSubview:textView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Text View
- (void)textViewDidBeginEditing:(UITextView *)textView {
    UIColor *seaGreen = [UIColor colorWithRed: 180.0/255.0 green: 238.0/255.0 blue:180.0/255.0 alpha: 1.0];
    NSLog(@"Opened textView");
    textView.backgroundColor = seaGreen;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        NSLog(@"Closed textView");
        textView.backgroundColor = [UIColor grayColor];
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

// Button
- (void)buttonPress:(UIButton*)button {
    NSLog(@"Pressed button!");
    if (self.view.backgroundColor != [UIColor greenColor]) {
        self.view.backgroundColor = [UIColor greenColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

@end

//
//  ViewController.m
//  GopherSmash
//
//  Created by Johnny Chan on 3/14/15.
//  Copyright (c) 2015 llamaface. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) CGFloat origImageHeight;
@property (assign, nonatomic) CGFloat gopherHeight;
@property (weak, nonatomic) IBOutlet UIImageView *gopherImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gopherVerticalSpaceConstraint;

@end


static CGFloat kMinGopherHeight = 0.1f;
static CGFloat kGrowHeight = 1;
static CGFloat kSmashHeight = 3;
static CGFloat kGopherTime = 0.1f;

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.timer = [NSTimer scheduledTimerWithTimeInterval:kGopherTime
												  target:self
												selector:@selector(gopherTimer:)
												userInfo:nil
												 repeats:YES];
	
	self.origImageHeight = self.gopherImage.frame.size.height;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


- (void)gopherTimer:(NSTimer*)timer
{
	NSLog(@"gopherTimer");
	
	self.gopherHeight += kGrowHeight;
	
	[self verifyGopherHeight];
}

- (void)verifyGopherHeight
{
	self.gopherHeight = (self.gopherHeight >= self.origImageHeight) ? self.origImageHeight : self.gopherHeight;
	
	self.gopherHeight = (self.gopherHeight < kMinGopherHeight) ? kMinGopherHeight : self.gopherHeight;
	
	self.gopherVerticalSpaceConstraint.constant = -self.gopherHeight;
}

- (IBAction)smashAction:(id)sender {
	self.gopherHeight -= kSmashHeight;
	
	[self verifyGopherHeight];
}

@end

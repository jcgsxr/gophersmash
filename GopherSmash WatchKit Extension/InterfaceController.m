//
//  InterfaceController.m
//  GopherSmash WatchKit Extension
//
//  Created by Johnny Chan on 3/14/15.
//  Copyright (c) 2015 llamaface. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceImage *gopherImage;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSUInteger level;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *levelLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *smashButton;
@property (assign, nonatomic) BOOL isImageHidden;

@end




static CGFloat kGopherTime = 1.0f;
static NSString *kLevelKey = @"level";
static NSString *kSuiteName = @"com.llamaface.gophersmash";

@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
	self.isImageHidden = NO;
	
	NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kSuiteName];
	self.level = [defaults integerForKey:kLevelKey];
	
	if (self.level <= 0)
		self.level = 1;

	[self beginTimer];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
	
	
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)gopherTimer:(NSTimer*)timer {
//	NSLog(@"gopherTimer");
	
	self.isImageHidden = YES;
	[self.gopherImage setHidden:self.isImageHidden];

	double randSec = (arc4random() % 5);
	if (randSec < 2)
		randSec = 2;
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(randSec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self beginTimer];
	});
}

- (void)beginTimer
{
	NSLog(@"beginTimer");
	self.isImageHidden = NO;
	[self.gopherImage setHidden:self.isImageHidden];
	
	CGFloat levelTime = (CGFloat)(self.level * 2) / 100;
	self.timer = [NSTimer scheduledTimerWithTimeInterval:kGopherTime - levelTime
												  target:self
												selector:@selector(gopherTimer:)
												userInfo:nil
												 repeats:NO];
}

- (IBAction)smashAction {
	[self.smashButton setEnabled:NO];
	[self.timer invalidate];
	[self.gopherImage setHidden:YES];
	
	// TODO: Figure out actual value of spacer height that indicates that the gopher image is visible.
	if (!self.isImageHidden) {
		[self.levelLabel setText:@"Nice job! Get ready..."];
		
		// Proceed to next level.
		self.level++;
		NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kSuiteName];
		[defaults setInteger:self.level forKey:kLevelKey];

		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.smashButton setEnabled:YES];
			[self.levelLabel setText:[NSString stringWithFormat:@"Level: %ld", self.level]];
			[self beginTimer];
		});
	}
	else {
		[self.levelLabel setText:@"You missed! Get ready..."];
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.smashButton setEnabled:YES];
			[self.levelLabel setText:[NSString stringWithFormat:@"Level: %ld", self.level]];
			[self beginTimer];
		});
	}
}

@end




//
//  InterfaceController.m
//  GopherSmash WatchKit Extension
//
//  Created by Johnny Chan on 3/14/15.
//  Copyright (c) 2015 llamaface. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceImage *spacerImage;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *gopherImage;
@property (assign, nonatomic) CGFloat origImageHeight;
@property (assign, nonatomic) CGFloat gopherHeight;
@property (strong, nonatomic) NSTimer *timer;

@end

static CGFloat kMinGopherHeight = 0.1f;
static CGFloat kGrowHeight = 2;
static CGFloat kMaxGopherHeight = 150;

@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
	
	self.origImageHeight = kMaxGopherHeight;
	self.gopherHeight = kMinGopherHeight;
	[self.gopherImage setHeight:kMinGopherHeight];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gopherTimer:) userInfo:nil repeats:YES];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
	
	
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)gopherTimer:(NSTimer*)timer
{
	NSLog(@"gopherTimer");
	
	self.gopherHeight -= kGrowHeight;
	
	[self verifyGopherHeight];
	
	[self.spacerImage setHeight:self.gopherHeight];
}

- (void)verifyGopherHeight
{
	self.gopherHeight = (self.gopherHeight >= kMaxGopherHeight) ? kMaxGopherHeight : self.gopherHeight;
	
	self.gopherHeight = (self.gopherHeight < kMinGopherHeight) ? kMinGopherHeight : self.gopherHeight;
}

- (IBAction)smashAction {
	
	NSLog(@"smash");
	
	self.gopherHeight += kGrowHeight;
	
	[self verifyGopherHeight];
	
	[self.spacerImage setHeight:self.gopherHeight];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
	NSLog(@"didSelectRowAtIndex %ld", (long)rowIndex);
}


@end




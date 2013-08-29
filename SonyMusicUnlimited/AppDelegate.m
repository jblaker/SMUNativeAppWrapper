//
//  AppDelegate.m
//  SonyMusicUnlimited
//
//  Created by Jeremy Blaker on 8/20/13.
//  Copyright (c) 2013 blakerdesign. All rights reserved.
//

#import "AppDelegate.h"
#import "SMUManager.h"
#import "iChat.h"

#define kURLToLoad @"https://music.sonyentertainmentnetwork.com"

@implementation AppDelegate

@synthesize webView, window;

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults registerDefaults:[NSDictionary dictionaryWithObject:@YES forKey:kShouldUpdateStatusKey]];
  [self.updateStatusMessageMenuItem setState:[defaults boolForKey:kShouldUpdateStatusKey]];
  [webView setMainFrameURL:kURLToLoad];
  [[SMUManager sharedInstance] setup];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
	[self bringMainWindowToFront:nil];
	return YES;
}

- (void)bringMainWindowToFront:(id)sender {
	[window makeKeyAndOrderFront:sender];
	if ([[webView mainFrameURL] isEqualTo:@""]) {
		[webView setMainFrameURL:kURLToLoad];
	}
}

+ (AppDelegate *)appDelegate {
	return (AppDelegate *)[[NSApplication sharedApplication] delegate];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
  iChatApplication *iChat = (iChatApplication *)[SBApplication applicationWithBundleIdentifier:@"com.apple.iChat"];
  [iChat setStatusMessage:@"Available"];
}

#pragma mark - UI Actions

- (IBAction)togglePlayback:(id)sender {
  [[SMUManager sharedInstance] togglePlayback];
}

- (IBAction)nextTrack:(id)sender {
  [[SMUManager sharedInstance] nextTrack];
}

- (IBAction)previousTrack:(id)sender {
  [[SMUManager sharedInstance] previousTrack];
}

- (IBAction)likeTrack:(id)sender {
  [[SMUManager sharedInstance] likeTrack];
}

- (IBAction)dislikeTrack:(id)sender {
  [[SMUManager sharedInstance] dislikeTrack];
}

- (IBAction)toggleShouldUpdateStatus:(id)sender {
  [[SMUManager sharedInstance] toggleShouldUpdateStatus];
}

@end
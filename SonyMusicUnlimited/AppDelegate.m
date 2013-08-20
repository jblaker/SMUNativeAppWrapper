//
//  AppDelegate.m
//  SonyMusicUnlimited
//
//  Created by Jeremy Blaker on 8/20/13.
//  Copyright (c) 2013 blakerdesign. All rights reserved.
//

#import "AppDelegate.h"

#define kURLToLoad @"https://music.sonyentertainmentnetwork.com"

@implementation AppDelegate

@synthesize webView=_webView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
  [NSApp setApplicationIconImage:[NSImage imageNamed:@"AppIcon"]];
  [_webView setMainFrameURL:kURLToLoad];
}

- (void)togglePlayback:(id)sender {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerPlayPause"];
}

- (void)previousTrack:(id)sender {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerPrevious"];
}

- (void)nextTrack:(id)sender {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerNext"];
}

- (void)likeTrack:(id)sender {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerLike"];
}

- (void)dislikeTrack:(id)sender {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerDislike"];
}

- (void)triggerJavascriptEvent:(NSString *)eventName forElementID:(NSString *)elementID {
  NSString *javascriptCommand = [NSString stringWithFormat:@"var event = document.createEvent(\"HTMLEvents\"); event.initEvent(\"%@\", true, true); document.getElementById('%@').dispatchEvent(event)", eventName, elementID];
  [_webView stringByEvaluatingJavaScriptFromString:javascriptCommand];
}

@end
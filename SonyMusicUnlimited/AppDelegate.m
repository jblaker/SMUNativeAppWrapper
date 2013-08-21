//
//  AppDelegate.m
//  SonyMusicUnlimited
//
//  Created by Jeremy Blaker on 8/20/13.
//  Copyright (c) 2013 blakerdesign. All rights reserved.
//

#import "AppDelegate.h"

#define kNowPlayingClass @"GBJWNX1BGBC"
#define kURLToLoad @"https://music.sonyentertainmentnetwork.com"

@implementation AppDelegate

@synthesize webView=_webView;
@synthesize nowPlaying=_nowPlaying;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
  [NSApp setApplicationIconImage:[NSImage imageNamed:@"AppIcon"]];
  [_webView setMainFrameURL:kURLToLoad];
  
  NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(displayNowPlaying) userInfo:nil repeats:YES];
  [timer fire];
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

- (void)displayNowPlaying {
  NSString *title = [self innerHTMLForElementWithClassName:kNowPlayingClass atIndex:0];
  NSString *album = [self innerHTMLForElementWithClassName:kNowPlayingClass atIndex:2];
  NSString *artist = [self innerHTMLForElementWithClassName:kNowPlayingClass atIndex:4];
  if ( [title isEqualToString:@""] ) {
    [_nowPlaying setTitle:@"Nothing Playing"];
  } else {
    [_nowPlaying setTitle:[NSString stringWithFormat:@"Now Playing: %@ - %@ - %@", title, album, artist]];
  }
}
- (NSString *)innerHTMLForElementWithClassName:(NSString *)className atIndex:(int)index {
  return [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByClassName('%@')[%i].innerHTML", className, index]];
}

@end
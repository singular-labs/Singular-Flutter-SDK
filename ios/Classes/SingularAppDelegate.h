//
// Created by TY Tandon on 19/7/21.
//

#ifndef SINGULARAPPDELEGATE_H
#define SINGULARAPPDELEGATE_H

@interface SingularAppDelegate : NSObject

@property NSDictionary * _Nullable launchOptions;
@property NSUserActivity * _Nullable userActivity;
@property NSURL * _Nullable openURL;

+ (SingularAppDelegate *_Nullable)shared;

- (void) continueUserActivity: (NSUserActivity*_Nullable) userActivity restorationHandler: (void (^_Nullable)(NSArray * _Nullable))restorationHandler;
- (void) handleOpenUrl:(NSURL*_Nullable)url options:(NSDictionary*_Nullable) options;
@end
#endif //SINGULARAPPDELEGATE_H


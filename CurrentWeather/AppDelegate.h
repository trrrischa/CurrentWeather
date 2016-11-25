//
//  AppDelegate.h
//  CurrentWeather
//
//  Created by Ekaterina on 25.11.16.
//  Copyright © 2016 Ekaterina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


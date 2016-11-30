//
//  WeatherParams.m
//  CurrentWeather
//
//  Created by Ekaterina on 29.11.16.
//  Copyright © 2016 Ekaterina. All rights reserved.
//

#import "WeatherParams.h"

@interface WeatherParams ()

+(NSString*) degreesToDirection:(int)degree;

@end

@implementation WeatherParams

+ (NSFetchRequest<WeatherParams *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"Weather"];
}

@dynamic date;
@dynamic temperature;
@dynamic humidity;
@dynamic windSpeed;
@dynamic condition;
@dynamic windDirection;

+ (id) loadWithDictionary:(NSDictionary *)dict
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(persistentContainer)])
    {
        context = [delegate persistentContainer].viewContext;
        
       // Create a new managed object
        WeatherParams *newWeatherParams = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:context];
        
        
        NSTimeZone *currentTimeZone = [NSTimeZone defaultTimeZone];
        NSDate *utcDate = [NSDate dateWithTimeIntervalSince1970:[dict[@"dt"] doubleValue]];
        NSInteger secondsOffset = [currentTimeZone secondsFromGMTForDate:utcDate];
        newWeatherParams.date = [NSDate dateWithTimeInterval:secondsOffset sinceDate:utcDate];

        newWeatherParams.temperature = [dict[@"main"][@"temp"] intValue];
        newWeatherParams.humidity = [dict[@"main"][@"humidity"] intValue];
        newWeatherParams.windSpeed = [dict[@"wind"][@"speed"] floatValue];
        newWeatherParams.windDirection = [self degreesToDirection:[dict[@"wind"][@"deg"] intValue]];
        if ([dict[@"weather"] isKindOfClass:[NSArray class]]) {
            newWeatherParams.condition = [dict[@"weather"] objectAtIndex:0][@"description"];

        }
        
        NSError *error;
        if (![newWeatherParams.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

        return newWeatherParams;
    }
    else
        return nil;
}

+(NSString*) degreesToDirection:(int)degree{
    
    
    if ((degree <= 10) || (degree >= 350))
        return @"North";
    
    if ((degree >= 80) && (degree <= 100))
        return @"East";
    
    if ((degree >= 170) && (degree <= 190))
        return @"Sauth";

    if ((degree >= 260) && (degree <= 280))
        return @"West";
    
    if ((degree >= 170) && (degree <= 190))
        return @"South";

    if ((degree > 10) && (degree < 80))
        return @"NorthEast";
    
    if ((degree > 100) && (degree < 170))
        return @"SouthEast";
    
    if ((degree > 190) && (degree < 260))
        return @"SouthWest";
    
    if ((degree > 260) && (degree < 350))
        return @"NorthWest";
  
    return nil;
    
}

@end

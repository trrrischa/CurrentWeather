//
//  WeatherParams.h
//  CurrentWeather
//
//  Created by Ekaterina on 29.11.16.
//  Copyright © 2016 Ekaterina. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherParams : NSManagedObject

+ (NSFetchRequest<WeatherParams *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) double temperature;
@property (nonatomic) int16_t humidity;
@property (nonatomic) double windSpeed;
@property (nullable, nonatomic, copy) NSString *condition;
@property (nullable, nonatomic, copy) NSString *windDirection;

+ (id) loadWithDictionary:(NSDictionary *)dict;


@end
NS_ASSUME_NONNULL_END

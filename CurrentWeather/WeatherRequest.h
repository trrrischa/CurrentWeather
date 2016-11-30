//
//  WeatherRequest.h
//  CurrentWeather
//
//  Created by Ekaterina on 30.11.16.
//  Copyright © 2016 Ekaterina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherParams.h"

@interface WeatherRequest : NSObject

+ (void) sendWeatherRequestWithLattitude:(float) lattutude
                              Longtitude:(float) longtitude
                       completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))handler;

@end

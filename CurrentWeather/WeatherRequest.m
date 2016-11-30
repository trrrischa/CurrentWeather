//
//  WeatherRequest.m
//  CurrentWeather
//
//  Created by Ekaterina on 30.11.16.
//  Copyright © 2016 Ekaterina. All rights reserved.
//

#import "WeatherRequest.h"

static NSString *baseURL = @"http://api.openweathermap.org/data/2.5/weather?units=metric&APPID=6655ac05f53b8b3e79ecf3c9b5c11658";

@implementation WeatherRequest

+ (void) sendWeatherRequestWithLattitude:(float) lattutude
                              Longtitude:(float) longtitude
                       completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))handler
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@&lat=%f&lon=%f",baseURL,lattutude,longtitude];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];

    [[session dataTaskWithRequest:urlRequest completionHandler:handler] resume];
    

}

@end

//
//  ViewController.m
//  CurrentWeather
//
//  Created by Ekaterina on 25.11.16.
//  Copyright © 2016 Ekaterina. All rights reserved.
//

#import "WeatherViewController.h"
#import "CoreLocation/CoreLocation.h"

@interface WeatherViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) WeatherParams *currentWeather;

@property (weak, nonatomic) IBOutlet UILabel *currentTemp;
@property (weak, nonatomic) IBOutlet UILabel *currentCondition;
@property (weak, nonatomic) IBOutlet UILabel *currentWindDirection;
@property (weak, nonatomic) IBOutlet UILabel *currentWindSpeed;
@property (weak, nonatomic) IBOutlet UILabel *currentHumidity;

@property (nonatomic) UIView *activityView;


- (void) UpdateControls;
- (void) UpdateWeather;
- (IBAction)RenewWeather:(id)sender;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];

    
    [self UpdateWeather];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void) UpdateControls {
    
    [self hideActivityViewer];

    self.currentTemp.text = [NSString stringWithFormat:@"%1.0f°C",self.currentWeather.temperature];
    self.currentHumidity.text = [NSString stringWithFormat:@"%i%%",self.currentWeather.humidity];
    self.currentCondition.text = self.currentWeather.condition;
    self.currentWindDirection.text = self.currentWeather.windDirection;
    self.currentWindSpeed.text = [NSString stringWithFormat:@"%1.1f m/s",self.currentWeather.windSpeed];
}

- (void) UpdateWeather {
    
    [self showActivityViewer];
    
    void (^handler)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error){
        if ([data length] >0 && error == nil)
        {
            NSError *localError = nil;
            NSObject *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            if (([jsonObject isKindOfClass:[NSDictionary class]]) && (localError == nil)) {
                NSLog(@"%@",jsonObject);
                if ([[NSUserDefaults standardUserDefaults] valueForKey:@"temperature"]) {
                    //check the difference between current temperature and previous
                    double prevTemperature = [[[NSUserDefaults standardUserDefaults] valueForKey:@"temperature"] doubleValue];
                    double diff = prevTemperature - self.currentWeather.temperature;
                    if (diff > 3) {
                        [self showMessage:[NSString stringWithFormat:@"temperature has decreased by %1.1f degrees",diff]];
                    }
                }
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%1.1f",self.currentWeather.temperature] forKey:@"temperature"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.currentWeather = [WeatherParams loadWithDictionary:(NSDictionary*)jsonObject];
                    [self UpdateControls];
                });
            }
        }
        else if ([data length] == 0 && error == nil)
        {
            NSLog(@"Nothing was downloaded.");
        }
        else if (error != nil){
            NSLog(@"Error = %@", error);
        }

    };
    [WeatherRequest sendWeatherRequestWithLattitude:self.locationManager.location.coordinate.latitude
                                         Longtitude:self.locationManager.location.coordinate.longitude
                                  completionHandler:handler];

    
}

- (IBAction)RenewWeather:(id)sender {
    
    [self UpdateWeather];
    
}

#pragma mark - ActivityView

- (void)showActivityViewer
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *window = delegate.window;
    self.activityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
    self.activityView.backgroundColor = [UIColor blackColor];
    self.activityView.alpha = 0.5;
    
    UIActivityIndicatorView *activityWheel = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(window.bounds.size.width / 2 - 12, window.bounds.size.height / 2 - 12, 24, 24)];
    activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    activityWheel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleBottomMargin);
    [self.activityView addSubview:activityWheel];
    [window addSubview: self.activityView];
    
    [[[self.activityView subviews] objectAtIndex:0] startAnimating];
}

- (void)hideActivityViewer
{
    [[[self.activityView subviews] objectAtIndex:0] stopAnimating];
    [self.activityView removeFromSuperview];
    self.activityView = nil;
}

#pragma mark - Message View

- (void)showMessage:(NSString *)infoString
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:infoString preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
//#pragma mark - LocationManager delegate
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    [self.locationManager stopUpdatingLocation];
//
//    void (^handler)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error){
//        if ([data length] >0 && error == nil)
//        {
//            NSError *localError = nil;
//            NSObject *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
//            if (([jsonObject isKindOfClass:[NSDictionary class]]) && (localError == nil)) {
//                NSLog(@"%@",jsonObject);
//                self.currentWeather = [WeatherParams loadWithDictionary:(NSDictionary*)jsonObject];
//                if ([[NSUserDefaults standardUserDefaults] valueForKey:@"temperature"]) {
//                    //check the difference between current temperature and previous
//                    double prevTemperature = [[[NSUserDefaults standardUserDefaults] valueForKey:@"temperature"] doubleValue];
//                    double diff = prevTemperature - self.currentWeather.temperature;
//                    if (diff > 3) {
//                        [self showMessage:[NSString stringWithFormat:@"temperature has decreased by %1.1f degrees",diff]];
//                    }
//                    
//                }
//                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%1.1f",self.currentWeather.temperature] forKey:@"temperature"];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self UpdateControls];
//                });
//                
//            }
//            
//            
//        }
//        else if ([data length] == 0 && error == nil)
//        {
//            NSLog(@"Nothing was downloaded.");
//        }
//        else if (error != nil){
//            NSLog(@"Error = %@", error);
//        }
//        
//    };
//    
//    [WeatherRequest sendWeatherRequestWithLattitude:self.locationManager.location.coordinate.latitude
//                                         Longtitude:self.locationManager.location.coordinate.longitude
//                                  completionHandler:handler];
//    
//
//}

@end

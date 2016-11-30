//
//  HistoryTableViewController.m
//  CurrentWeather
//
//  Created by Ekaterina on 25.11.16.
//  Copyright © 2016 Ekaterina. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "WeatherViewController.h"
#import "WeatherParams.h"
#import "HistoryTableViewCell.h"
#import "AppDelegate.h"

@interface HistoryTableViewController ()

@property (strong, nonatomic) NSArray *historyArray;
@property (weak, nonatomic) WeatherParams *selectedWeather;

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(persistentContainer)])
    {
        context = [delegate persistentContainer].viewContext;
        NSFetchRequest *request = [WeatherParams fetchRequest];
        NSArray *history = [[context executeFetchRequest:request error:nil] mutableCopy];
        if (history.count > 0)
            self.historyArray = history;
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.historyArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    
    // Configure the cell...
    WeatherParams *item = [self.historyArray objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.YYYY"];
    cell.dateLabel.text = [dateFormatter stringFromDate:item.date];
    
    cell.conditionsLabel.text = item.condition;
    cell.temperatureLabel.text = [NSString stringWithFormat:@"%1.0f°C",item.temperature];
    cell.humidityLabel.text = [NSString stringWithFormat:@"%i%%",item.humidity];
    cell.windDirectionLabel.text = item.windDirection;
    cell.windSpeedLabel.text = [NSString stringWithFormat:@"%1.1f m/s",item.windSpeed];
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    WeatherViewController *weatherVC = [segue destinationViewController];
    // Pass the selected object to the new view controller.
    weatherVC.currentWeather = self.selectedWeather;
    
}
*/

@end

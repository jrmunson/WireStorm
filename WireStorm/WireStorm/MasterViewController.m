//
//  MasterViewController.m
//  WireStorm
//
//  Created by Jim on 1/27/16.
//  Copyright © 2016 Jim. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "People.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@property (nonatomic, strong) NSString *jsonUrl;
@property (nonatomic, strong) NSDictionary *jsonDict;
@property (nonatomic,retain) UIAlertController *alert;
@property (nonatomic,retain) UIAlertAction *ok;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.objects = nil;
//    People *peopleRec;
    
    _jsonUrl = @"https://s3-us-west-2.amazonaws.com/wirestorm/assets/response.json";
    [self loadDataUsingNSURLSession];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleCell" forIndexPath:indexPath];

    NSDictionary *object = [_objects objectAtIndex:indexPath.row];
    NSLog(@"name %@", [object valueForKey:@"name"]);
    cell.textLabel.text = [object valueForKey:@"name"];
    cell.detailTextLabel.text = [object valueForKey:@"position"];
    
    // get small image
    NSURL * imageURL = [NSURL URLWithString:[object valueForKey:@"smallpic"]];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    cell.imageView.image = image;

    
    return cell;
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSObject *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - json

- (void)loadDataUsingNSURLSession {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:self.jsonUrl]
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        // handle response
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self processResponseUsingData:data];
                                        });
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.tableView reloadData];
                                        });
                                  }];
    
    [task setTaskDescription:@"jsonDownload"];
    [task resume];
}

- (void)processResponseUsingData:(NSData*)data
{
    
    
    if ([data isKindOfClass:[NSData class]] && data.length != 0) {
        
        NSError *parseJsonError = nil;
        _objects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseJsonError];
        
        if (parseJsonError) {
 
            _alert=   [UIAlertController
                      alertControllerWithTitle:@"Server Error"
                      message:@"Data returned from server is incorrect. Please try again later."
                      preferredStyle:UIAlertControllerStyleAlert];
            
            _ok = [UIAlertAction
                  actionWithTitle:@"OK"
                  style:UIAlertActionStyleDefault
                  handler:^(UIAlertAction * action)
                  {
                      [_alert dismissViewControllerAnimated:YES completion:nil];
                      
                  }];
            [_alert addAction:_ok];
            [self presentViewController:_alert animated:YES completion:nil];
        }
    }else{
        [self noData];
    }
}

-(void)noData{
    // show error alert
    _alert=   [UIAlertController
              alertControllerWithTitle:@"No Data"
              message:@"No data returned from server for these parameters."
              preferredStyle:UIAlertControllerStyleAlert];
    
    _ok = [UIAlertAction
          actionWithTitle:@"OK"
          style:UIAlertActionStyleDefault
          handler:^(UIAlertAction * action)
          {
              [_alert dismissViewControllerAnimated:YES completion:nil];
              
          }];
    [_alert addAction:_ok];
    [self presentViewController:_alert animated:YES completion:nil];
}


@end

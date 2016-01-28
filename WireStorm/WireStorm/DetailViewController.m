//
//  DetailViewController.m
//  WireStorm
//
//  Created by Jim on 1/27/16.
//  Copyright © 2016 Jim. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (nonatomic, strong) NSString *jsonUrl;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem)
        [self loadDataUsingNSURLSession];
}

#pragma mark - json

- (void)loadDataUsingNSURLSession {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:[_detailItem valueForKey:@"lrgpic"]]
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        // handle response
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            UIImage * image = [UIImage imageWithData:data];
                                            _lrgPic.image = image;
                                        });
                                    }];
    
    [task setTaskDescription:@"jsonDownload"];
    [task resume];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    //[self configureView];
}

+ (void) loadFromURL:(NSURL*)url callback:(void (^)(UIImage *image))callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//            NSObject *object = self.objects[indexPath.row];
            UIImage *image = [UIImage imageWithData:imageData];
            callback(image);
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

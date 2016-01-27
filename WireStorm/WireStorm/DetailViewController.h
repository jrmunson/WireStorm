//
//  DetailViewController.h
//  WireStorm
//
//  Created by Jim on 1/27/16.
//  Copyright © 2016 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end


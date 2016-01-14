//
//  ViewController.h
//  testDemo
//
//  Created by Imac 21 on 16/1/6.
//  Copyright © 2016年 Imac 21. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "foldTableViewCell.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *testTableView;

- (foldTableViewCell *)tableViewCellForThing:(NSIndexPath *)indexPath;

@end


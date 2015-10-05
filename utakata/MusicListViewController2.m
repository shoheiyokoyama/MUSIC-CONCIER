//
//  MusicListViewController.m
//  utakata
//
//  Created by Naoto Takahashi on 2015/08/28.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import "MusicListViewController.h"
#import "MusicServiceManager.h"
#import "MusicListViewController.h"
#import "PlayViewController.h"
#import "MusicItems.h"

#define GCDMainThread dispatch_get_main_queue()

@interface MusicListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak, readonly) MusicServiceManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain) NSArray *data;
@property (retain) NSArray *musicData;
@end

@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = @[@"title",@"artist",@"albam"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getListsData];
    
}

- (void)getListsData
{
    [[MusicServiceManager sharedManager] getJsonData:^(NSMutableArray *items, NSError *error)
     {
         if (error) {
             NSLog(@"error: %@", error);
         }
         self.musicData = items;
         
         /*
         // UIの更新はメインスレッドで
         dispatch_async(GCDMainThread, ^{
             [self.tableView reloadData];
         });
          */
         [self.tableView reloadData];
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_musicData count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
   // NSLog(@"%@",_musicData);
    NSString *name = _musicData[indexPath.row][@"songName"];
//    NSString *name = _data[indexPath.row];

    cell.textLabel.text = name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayViewController* playView = [[PlayViewController alloc] init];
    [self presentViewController:playView animated:YES completion:nil];
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"tapped" message:_data[indexPath.row] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    [alertView show];
//    
//    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

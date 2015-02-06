//
//  ChatViewController.m
//  WeChat
//
//  Created by Qiyuan Liu on 2/5/15.
//  Copyright (c) 2015 liuqiyuan.com. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *msgTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation ChatViewController
- (IBAction)onSend:(id)sender {
    PFObject *msg = [PFObject objectWithClassName:@"Message"];
    msg[@"text"] = self.msgTextField.text;
    msg[@"user"] = self.user;
    [msg saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"send msg success");
            [self loadData];
        } else {
            // There was a problem, check error.description
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self) {
        self.title = @"WeChat";
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self loadData];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTableItem"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleTableItem"];
    }
    
    PFUser *userObj = self.dataArray[indexPath.row][@"user"];
    if (userObj && userObj.username) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@:%@", userObj.username, self.dataArray[indexPath.row][@"text"]];

    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", self.dataArray[indexPath.row][@"text"]];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)loadData {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %ld scores.", objects.count);
            NSLog(@"msg:%@", objects[0][@"text"]);
            self.dataArray = objects;
            [self.tableView reloadData];
            // Do something with the found objects
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)onTimer{
    [self loadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

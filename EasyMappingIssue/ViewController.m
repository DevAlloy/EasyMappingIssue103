//
//  ViewController.m
//  EasyMappingIssue
//
//  Created by Tsyganov Stanislav on 30/06/15.
//  Copyright (c) 2015 DevAlloy. All rights reserved.
//

#import "ViewController.h"

#import <MagicalRecord/MagicalRecord.h>

#import "RDNServerResponseMapper.h"

#import "RDNCluster+RDNMapping.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"badJson" ofType:@""];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    RDNServerResponseMapper *clusterResponseMapper = [[RDNServerResponseMapper alloc] init];
    NSArray *clusters = [clusterResponseMapper mapServerResponse:responseDict];
    NSLog(@"%@", clusters);
    
    NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
    
    NSPredicate *clusterIdToFavourPredicate = [NSPredicate predicateWithFormat:@"clusterId == 30637176"];
    [RDNCluster MR_deleteAllMatchingPredicate:clusterIdToFavourPredicate];
    
    [rootSavingContext MR_saveToPersistentStoreAndWait];
    
    clusters = [RDNCluster MR_findAll];
    NSLog(@"%@", clusters);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

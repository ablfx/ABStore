//
//  TableViewController.m
//  ABStore Example
//
//  Created by Alexander Blunck on 9/28/13.
//  Copyright (c) 2013 Alexander Blunck. All rights reserved.
//

#import "TableViewController.h"
#import "AddPopUpView.h"
#import "Person.h"

@interface TableViewController ()
{
    NSMutableArray *_people;
}
@end

@implementation TableViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    _people = [NSMutableArray new];
    
    self.title = @"People";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(addButtonSelected)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self refreshData];
}



#pragma mark - Buttons
-(void) addButtonSelected
{
    [[AddPopUpView new] showWithCompletion:^(NSString *text) {
        
        //Create a new "Person" object in the context
        Person *newPerson = [Person createObject];
        newPerson.name = text;
        
        //Persist changes to persitent store
        [ABStore saveDefaultContext];
        
        [self refreshData];
        
    }];
}



#pragma mark - Refresh
-(void) refreshData
{
    [_people removeAllObjects];
    
    //Fetch all "Person" objects in context
    [_people addObjectsFromArray:[Person findAll]];
    
    [self.tableView reloadData];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Person *person = [_people objectAtIndex:indexPath.row];
    
    cell.textLabel.text = person.name;
    
    return cell;
}



#pragma mark - UITableViewDelegate
-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person *person = [_people objectAtIndex:indexPath.row];
    [_people removeObject:person];
    
    //Remove "Person" object from context
    [person deleteObject];
    
    //Persist changes to persitent store
    [ABStore saveDefaultContext];
    
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}


@end

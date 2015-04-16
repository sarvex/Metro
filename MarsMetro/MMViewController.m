//
//  MMViewController.m
//  MarsMetro
//

#import "MMViewController.h"
typedef enum {
    StartMode,
    EndMode
} SelectModeType;

@interface MMViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    //toolbar which will include the done button above the picker
    UIToolbar *pickerToolBar;
    //the picker object which will be used to display all the station names and line colors
    UIPickerView *stationPicker;
    //the current selected color will be used to display the stations present in that line
    NSString *selectedMetroLine;
    //the mode will determine whether the user has selected the source or the destination point

    SelectModeType selectedMode;
    //we keep a reference of both the start station dictionary and the end station dictionary for performing calculation

    __unsafe_unretained NSDictionary *startStationDict;
    __unsafe_unretained NSDictionary *endStationDict;

}
@end

@implementation MMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //we allow the singleton instance to create the map layout
    [[MetroPathEngine sharedEngine]createMetroMapLayout];

    //make sure the user cannot enter text manually in the textfields
    _startTextField.enabled = NO;
    _endTextField.enabled = NO;
    
    //test whether the dictionary is empty or not. If not then select the first line color as the default selected one.
    if([[[MetroPathEngine sharedEngine]stationDict]allKeys].count) {
    
        selectedMetroLine =[[[[MetroPathEngine sharedEngine]stationDict]allKeys]objectAtIndex:0];
    }
    
    //we create the picker which will allow the user to input.
    [self createPicker];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clearOutputFields {

    _descriptionLabel.text = @"";
    _costLabel.text = @"";
    _timeDurationLabel.text = @"";
}

#pragma mark picker methods
-(void)createPicker {
    
    
    
    
    
    stationPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height+44, self.view.frame.size.width, 40)];
    
    pickerToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, stationPicker.frame.origin.y, self.view.frame.size.width, 44)];
    
    
    
    stationPicker.backgroundColor=[UIColor whiteColor];
    stationPicker.dataSource=self;
    stationPicker.delegate=self;
    
    
    
    [pickerToolBar setBarStyle:UIBarStyleBlackOpaque];
    
    UIBarButtonItem *pickerDoneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneButtonClicked:)];
    
    pickerDoneButton.tintColor = [UIColor whiteColor];
    pickerDoneButton.title=@"Done";
    [pickerToolBar setItems:[NSArray arrayWithObject:pickerDoneButton]];
    
    
    
    
    
    
    
    [self.view addSubview:stationPicker];
    [self.view addSubview:pickerToolBar];
    
    
}

-(void)showPicker {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = stationPicker.frame ;
        
        frame.origin.y -=221;       //200
        stationPicker.frame = frame;
        
        frame = pickerToolBar.frame;
        
        frame.origin.y -=261;
        pickerToolBar.frame = frame;
    }];
}

-(void)hidePicker {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = stationPicker.frame ;
        
        frame.origin.y =self.view.frame.size.height+pickerToolBar.frame.size.height;
        stationPicker.frame = frame;
        frame = pickerToolBar.frame;
        
        frame.origin.y =self.view.frame.size.height+44;
        pickerToolBar.frame = frame;
        
        
    }];
    
}

-(void)pickerDoneButtonClicked:(UIBarButtonItem*)sender {
    [self hidePicker];
    [self clearOutputFields];
    NSInteger selectedIndex = [stationPicker selectedRowInComponent:1];
    NSDictionary *stationDict =[[[[MetroPathEngine sharedEngine]stationDict]objectForKey:selectedMetroLine] objectAtIndex:selectedIndex];
    ;
    switch (selectedMode) {
        case StartMode:
            startStationDict = stationDict;
            _startTextField.text =[stationDict objectForKey:@"title"] ;
            _selectStartButton.enabled = YES;
            _selectEndButton.enabled = YES;

            break;
            
        case EndMode:
            endStationDict = stationDict;

            _endTextField.text =[stationDict objectForKey:@"title"] ;

            _selectStartButton.enabled = YES;
            _selectEndButton.enabled = YES;

            break;
    }
    
}
#pragma mark picker delegate and datasource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 2;
    
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            return [[[[MetroPathEngine sharedEngine]stationDict]allKeys]count];
            break;
            
        default:
            return [[[[MetroPathEngine sharedEngine]stationDict]objectForKey:selectedMetroLine] count];

            break;
    }
    
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[[[MetroPathEngine sharedEngine]stationDict]allKeys]objectAtIndex:row];
            break;
            
       default:
        {
            NSDictionary *stationDict =[[[[MetroPathEngine sharedEngine]stationDict]objectForKey:selectedMetroLine] objectAtIndex:row];
            
            return [stationDict objectForKey:@"title"];
        }
            break;
    }

    
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if(component==0) {
    
        selectedMetroLine =[[[[MetroPathEngine sharedEngine]stationDict]allKeys]objectAtIndex:row];
        [pickerView reloadComponent:1];

    }
}


- (IBAction)selectStartPressed:(UIButton*)sender {
    selectedMode = StartMode;
    sender.enabled = NO;
    _selectEndButton.enabled = NO;

    [self showPicker];
}
- (IBAction)endButtonPressed:(UIButton *)sender {
    selectedMode = EndMode;
    sender.enabled = NO;
    _selectStartButton.enabled = NO;
    [self showPicker];
    
}
- (IBAction)calculateBtnPressed:(UIButton *)sender {
    //handle the test case where the user inputs the same station name. we display an alert when this happens
    if([[endStationDict objectForKey:@"stationID"] isEqualToString:[startStationDict objectForKey:@"stationID"]]) {
      UIAlertView *alertView=   [[UIAlertView alloc]initWithTitle:@"" message:@"Please select a different destination. The source and destination cannot be the same." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    
   MetroRoute *route = [[MetroPathEngine sharedEngine]calculateRouteBetweenStation:[startStationDict objectForKey:@"stationID"] toStation:[endStationDict objectForKey:@"stationID"]];

    
   
    //ensure that a valid route has been calculated first.
     if(route.routeList.count) {
         NSMutableString *description =[[route getFullDescription]mutableCopy];

         if(route.isRouteClosed) {
              _descriptionLabel.text = description;
             
         }
        //display the relevant values in the textfields.
         else { _timeDurationLabel.hidden = NO;
    _timeDurationLabel.text = [NSString stringWithFormat:@"Time: %.0f minutes",[route length]];
    _costLabel.text =[NSString stringWithFormat:@"Cost: %d$",[[route fareCost]intValue]];

    _costLabel.hidden = NO;
    _costLabel.text =[NSString stringWithFormat:@"Cost: %d$",[[route fareCost]intValue]];
      _descriptionLabel.text = description;
         }
    }
    
    else {
        UIAlertView *alertView=   [[UIAlertView alloc]initWithTitle:@"" message:@"Sorry but we could not find a route between these 2 stations." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}

@end

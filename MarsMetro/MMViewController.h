//
//  MMViewController.h
//  MarsMetro
//

#import <UIKit/UIKit.h>

@interface MMViewController : UIViewController
{
    
}

-(void)clearOutputFields ;

/**
 Method which is invoked whenever the Select End Station button is pressed
 @return returns the IBAction connection if the button is connected properly in the storyboard else returns nil
 @param sender is the reference of button which is tapped.
 */
- (IBAction)endButtonPressed:(UIButton *)sender;

/**
 Textfield which displays the destination input selected by the user
 */
@property (weak, nonatomic) IBOutlet UITextField *endTextField;
/**
 Label which displays the full route description based on the calculated path.
 */
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
/**
 Label which displays the time duration in minutes based on the calculated path.
 */
@property (weak, nonatomic) IBOutlet UILabel *timeDurationLabel;

/**
 Button which allows the user to select the destination
 */
@property (weak, nonatomic) IBOutlet UIButton *selectEndButton;
/**
 Method which is invoked whenever the Search button is pressed
 @return returns the IBAction connection if the button is connected properly in the storyboard else returns nil
 @param sender is the reference of button which is tapped.
 */

- (IBAction)calculateBtnPressed:(UIButton *)sender;
/**
 Method which is invoked whenever the select start station button is pressed
 @return returns the IBAction connection if the button is connected properly in the storyboard else returns nil
 @param sender is the reference of button which is tapped.
 */

- (IBAction)selectStartPressed:(id)sender;

/**
 Textfield which displays the start input selected by the user
 */

@property (weak, nonatomic) IBOutlet UITextField *startTextField;
/**
 Button which allows the user to select the start point
 */

@property (weak, nonatomic) IBOutlet UIButton *selectStartButton;

/**
 Label which displays the cost based on the calculated path.
 */
@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@end

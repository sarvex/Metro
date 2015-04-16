//
//  MetroStation.h
//  MarsMetro
//

#import <Foundation/Foundation.h>
/**
Class for representing a metro station. Note that the station should have a unique identifier name. 
 
 */

@interface MetroStation : NSObject {

    /**
     A unique string identifer for the station.  Must be unique among all stations
     */
    NSString *stationID;
    
    /**
     The display title of the station. Does not have to be unique.
     */
    NSString *title;
    
    /**
     The line color of the metro station
     */
    NSString *lineColor;

}
/** 
 Class Initializer for creating a new station object
 @param identifier a string identifier of the station
 @param lineColor a string identifier of the line color

 */
+ (MetroStation *)stationWithIdentifier:(NSString *)identifier color:(NSString*)lineColor;
@property (nonatomic, strong) NSString *stationID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong)  NSString *lineColor;
@property (nonatomic, strong)  NSString *endPointOne;
@property (nonatomic, strong)  NSString *endPointTwo;
@property (nonatomic, assign)  BOOL isStationClosed;
@property(nonatomic,strong) NSString *closedReason;
@property (nonatomic, assign)  BOOL isSwitch;

@end

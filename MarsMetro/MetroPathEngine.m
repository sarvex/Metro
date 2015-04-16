//
//  MetroPathEngine.m
//  MarsMetro
//

#import "MetroPathEngine.h"


#import "MetroPath/MetroMap.h"
#import "MetroPath/MetroRoute.h"
#import "MetroPath/MetroStation.h"
#import "MetroTrack.h"
#import "MetroRouteStep.h"
static MetroPathEngine *_sharedProcessor = nil;


@implementation MetroPathEngine
@synthesize stationDict;
@synthesize map;
+ (id)sharedEngine
{
    @synchronized(self)
    {
        if (_sharedProcessor == nil)
            _sharedProcessor = [[self alloc] init];
        
    }
    return _sharedProcessor;
    
    
    return _sharedProcessor;
}

-(MetroStation*)createStationWithIdentifier:(NSString*)identifier forLine:(NSString*)lineColor {

    MetroStation *aStation = [MetroStation stationWithIdentifier:identifier color:lineColor];
     return aStation;
}
-(void)createMetroMapLayout {
    map = [[MetroMap alloc]init];

    //we first initialize the list of stations
    [self initializeMetroStations];
    
    
    //secondly we initialize the metro tracks
    [self initializeMetroTracks];
    
    
    //thirdly we determine the switch stations on the layout
    [self determineStationSwitchPoints];
    [self determineClosedStations];
  
    //we calculate the end points of each track with respect to the track color.
    [map calculateLineEndPoints];
    
    

}

-(void)determineClosedStations {

    NSArray *closedStationsArray = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ClosedStations" ofType:@"plist"]];
    
    for (NSDictionary *closedStationDict in closedStationsArray) {
        
        NSString *stationName = [closedStationDict objectForKey:@"station"];
        
        if(stationName && stationName.length) {
        
            MetroStation *metroStation  = [map.stations objectForKey:stationName];
            if(metroStation) {
                
            metroStation.isStationClosed = YES;
                if([closedStationDict objectForKey:@"reason"])
            metroStation.closedReason =[closedStationDict objectForKey:@"reason"];
            
            }
        }
        
        
    }

}

-(void)determineStationSwitchPoints {

    //we need to know which are the stations which allow switching the line colors.
    
    NSArray *switchArray  = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"SwitchPoints" ofType:@"plist"]];
    
    for (NSString *switchString in switchArray) {
        MetroStation *station = [map stationWithUID:switchString];
        station.isSwitch = YES;
        
    }
}

-(void)initializeMetroTracks {

    //we get the list of all track connections from the file and add them to the map.
    
    NSArray *trackListArray = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"TrackList" ofType:@"plist"]];
    
    for (NSDictionary *trackDict in trackListArray) {
        //make sure that the tracks are not nil to avoid exception
        if([map stationWithUID:[trackDict objectForKey:@"fromStation"]] &&[map stationWithUID:[trackDict objectForKey:@"toStation"]])
            [map createBiDirectionalTrack:[MetroTrack trackWithName:[trackDict objectForKey:@"identifier"] andWeight:[NSNumber numberWithInt:5] lineColor:[trackDict objectForKey:@"lineColor"]] fromStation:[map stationWithUID:[trackDict objectForKey:@"fromStation"]] toStation:[map stationWithUID:[trackDict objectForKey:@"toStation"]]];
        
    }

}


-(void)initializeMetroStations
{
    //lets get the list of all the stations first and add them to the map.
    self.stationDict = [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"StationList" ofType:@"plist"]];
    
    
    for (NSString *key in [stationDict  allKeys]) {
        
        NSArray *lineArray = [stationDict objectForKey:key];
        
        for (NSDictionary *lineStationDict in lineArray) {
            MetroStation *station=  [self createStationWithIdentifier:[lineStationDict objectForKey:@"stationID"] forLine:key];
            [map addStation:station];
        }
    }

    
}

-(MetroRoute*)calculateRouteBetweenStation:(NSString*)fromStationID toStation:(NSString*)toStationID {
   
    MetroRoute *route = [map calculateShortestRouteFromStation:[map stationWithUID:fromStationID] toNode:[map stationWithUID:toStationID]]
    
    ;
    
    return route;

    
}

@end

//
//  MetroRoute.m
//  MarsMetro
//

#import "MetroRoute.h"
#import "MetroRouteStep.h"
#import "MetroStation.h"
#import "MetroTrack.h"
@implementation MetroRoute
@synthesize routeList;
@synthesize fareCost;
@synthesize isRouteClosed;

- (id)init
{
    self = [super init];
    
    if (self) {
        
        routeList = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)addStepFromStation:(MetroStation *)station withTrack:(MetroTrack*)track
{
    BOOL isFirst = NO;
    if(routeList.count==0)
        isFirst = YES;
    
    MetroRouteStep *step = [[MetroRouteStep alloc] initWithStation:station andTrack:track asBeginning:isFirst];
    
    [routeList addObject:step];
}

- (NSString *)getFullDescription
{
    NSMutableString *string = [NSMutableString string];
    
    
    if(isRouteClosed) {
        MetroRouteStep *closedStep = [routeList objectAtIndex:0];

       [string appendFormat:@"Route is closed due to %@", closedStep.station.closedReason];
        return string;
    }
    
   // [string appendString:@"Start: \n"];
    //Firstly we test whether the start and end stations are on the same lines or not.
    //This is for handling the description text specifically as per the example in the requirement.
    BOOL isSameColorLine = NO;
    
    
    
    
    if(routeList.count>1) {
    
        MetroRouteStep *firstStep = [routeList objectAtIndex:0];
        
        MetroRouteStep *finalStep = [routeList lastObject];
        
        if([firstStep.track.lineColor isEqualToString:finalStep.station.lineColor]){
        
            isSameColorLine = YES;
        }
    }
    
    MetroRouteStep *previousStep;
    for (int count=0; count<[routeList count]; count++) {
        
        MetroRouteStep *step = routeList[count];
    
        
        if(!previousStep)
        {
            
            if(isSameColorLine) {
                  [string appendFormat:@"Take %@ line at %@ going through",step.track.lineColor,step.station.stationID];
            }
            
            else
            [string appendFormat:@"Take %@ line at %@ moving towards %@ \n",step.track.lineColor,step.station.stationID,step.track.lineEndPoint];

        }
        else if(step.track && ![step.track.lineColor isEqualToString:previousStep.station.lineColor] &&![step.track.lineColor isEqualToString:previousStep.track.lineColor])
            [string appendFormat:@"Change to %@ line at %@ moving towards %@\n",step.track.lineColor,step.station.stationID,step.track.lineEndPoint];
        else if (isSameColorLine) {
            (count==routeList.count-1)?[string appendFormat:@" to reach %@",step.station.stationID]:((count==routeList.count-2)?[string appendFormat:@" %@",step.station.stationID]:[string appendFormat:@" %@,",step.station.stationID]);

            
        }
        
        previousStep = step;
    }
    
    return string;
}

-(NSNumber*)fareCost {
//we dont need to add the cost of the starting station, so we take the integer starting from -1.
    int cost = -1;
    MetroRouteStep *previousStep;

    for (MetroRouteStep *step in routeList) {
        
if(previousStep && step.track && ![step.track.lineColor isEqualToString:previousStep.station.lineColor] &&![step.track.lineColor isEqualToString:previousStep.track.lineColor])
    cost +=1;
      
        cost+=1;
        
        previousStep = step;

    }
    return [NSNumber numberWithInt:cost];
}

- (NSUInteger)count {
    
    return [routeList count];
}

- (MetroStation *)startStation {
    
    return ([self count] > 0) ? [[routeList objectAtIndex:0] station] : nil;
}

- (MetroStation *)endStation {
    
    return ([self count] > 0) ? [[routeList objectAtIndex:([self count] - 1)] station] : nil;
}

- (float)length {
    
    float totalLength = 0;
    
    for (MetroRouteStep *step in routeList) {
        
        if (step.track) {
            
            totalLength += [step.track.weight floatValue];
        }
    }
    
    return totalLength;
}

@end

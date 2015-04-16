# MetroPath

Overview

MarsMetro is an application which has been developed on the iOS platform. The application allows the user to select a start station and a destination, which are taken as input to calculate the shortest path.

The calculation of the shortest path is based on the DIJKSTRA’S shortest path algorithm. 
The classes have been designed as per the basic OOPS principles. We have the following classes in the code which are responsible for calculating the path.

1.MetroMap: Class that represents the station points and the tracks(edges) between them. Uses the Djikstra's shortest path algorithm to calculate the shortest points.

2.MetroStation: Class for representing a metro station. Note that the station should have a unique identifier name. 

3.MetroTrack: Class represents the track which will be responsible for interconnecting two stations.

4 MetroRoute: Class contains information about the route constructed between two stations. Note that the contents of this class are readonly.

5. MetroRouteStep: Class which describes the step in a route between two metro stations.

6. MetroPathEngine: The path engine class is used as a singleton which is responsible to create the layout and also invoke shortest path calculation methods by taking input.

User Interface:
The UI of this application is based on the MVC pattern and it includes a single view controller 
called MMViewController. 
When the user taps on the select start button,  a picker will be shown where the user can select the line colour and further select the station. On pressing the done button, the station  will be displayed in the ‘start point’ textfield. The flow is similar when the user presses on the select destination button.

The main calculation is performed when the user presses on the ‘Search’ button. The full route description is displayed below, along with the cost and duration.


Unit Testing:
The unit tests for this application have been added in 2 classes:
1. MarsMetroTests
2. MMViewControllerTests

The can be run via Xcode in Test mode and verified accordingly.


Notes:
Please note that all the stations, tracks and switch points have been added to an XML file.
There are 3 XML files for this purpose:
1. StationList.plist (has all the stations as per the line colour)
2.TrackList.plist (has all the track connections included)
3.SwitchPoints.plist (has all the switch points included)

This application can be tested on the iOS simulator. For testing on the device, the apple developer account needs to configured properly to allow deployment to an iOS device.


# Landmark Remark

## To start:
Run `pod install` to install the pods. This will install Firebase.
To open the project, open the Xcode workspace file `LandmarkRemark.xcworkspace`. 


## Approach
This is iOS native app written in Swift, supporting iOS 10 and above.
It builds and runs in Xcode 10.2.
I have used Firebase for Backend-as-a-service to persist the notes across devices and users.
Overall I have approached this as a proof-of-concept with bare minimum functionality to fit with the timeframe given.
There are many aspects which need to be improved for actual production ready application. 


## App Overview
### Intro setup screen
At first launch, introduction screen with a brief description of the app is displayed to the user.   
This flow is used to setup the user name as well for the notes.

### Map screen
Once user name is setup the user is redirected to the main screen showing the map.
The map shows the current location of the user and asks for the permission with some description.  
Once permission is granted, the location shows up on the map. 
Tap on the gps icon on the top right to move the map to current location.

### Add notes
New note can be added by tapping on the button "Add Button" at the bottom of the map.  
This will bring up the note entry screen.  
It is a simple text input with maximum of 140 characters to keep the notes small.

### Search notes
User can search notes by tapping on the button "Search" at the bottom of the map.  
It displays the list of all the notes which can be filtered by typing on the search bar on the top.  
Note that it's using the built-in search bar in navigation which doesn't show until you scroll down on the table view. 


## Design Pattern / Architecture 
I have used CleanSwift design pattern which is designed to follow the clean architecture model. 
It has some modifications to make it work easier in iOS system.
I'm using code templates from Clean Swift which creates the boilerplate code. 
Quick description of the components in Clean Swift (more details can be found from the Clean Swift website https://clean-swift.com/clean-swift-ios-architecture/)
- view controller: display module, primary concern is displaying contents in view
- interactor: business logic of the scene and usually takes care of user interactions. This may call workers to do specific tasks.
- presenter: presenter module and converts data model from interactor into something presentable for the display.
- worker: specific task worker and only does one thing.
- router: takes care of any data passing between view controllers


### Code structure
Code is grouped by 'scenes' e.g. IntroPages, MainMap, AddNotes etc. and any utilities or helper type of classes are organised under Shared/Utilities.


## Cocoapod
Cocoapod was used to configure Firebase, and no other pods were used.


## Assumptions
- Location accuracy is set to nearest 10 meters and assumed that is enough accuracy for landmarks.
- Timestamp of the notes added is saved in the data store in case it needs to be sorted later.
- Offline use is as smooth as possible. Automatically syncs when back online.
- Location is required to add a note.
- Note message is limited to 140 max for best display.
- Multiple notes at the same location don't show up individually and overlap each other. 
- No maximum length is set for username.
- Users cannot change their username.
- There is no limit of how many notes users can add. 


## Hours
Total of 12 hours
- 1 hr on planning / analysis / design
- 10 hrs of development + testing
  - 2 hours: showing map and current location
  - 4 hours: add notes and show notes
  - 4 hours: search notes
- 1 hr on documentation 


## Known Issues / Limitations

- Security: 
   - There is no authentication setup for accessing Firestore. Firebase Authentication can be setup to properly implement this. For the simplicity of demo and using the POC I have omitted the authentication and the Firestore is setup in test mode which allows anyone with the keys to acces the data.
   - User name needs to be linked with Firebase Authentication and validated to be unique per user. Currently user name is stored locally and not synced in Firebase. 
- Functionality:
   - Currently the notes are loaded once when the map view is loaded and do not show any updates. Live updates can be implemented to show the newly added notes as it happens.
   - When search result note is selected, not only move the map to the note's location but also open the note contents. 
   - Cannot delete the notes at the moment - need to add this. 
   - If multiple notes are added at the same or similar location they overlap and do not show well. Clustering functionality can be implemented to show clusters if multiple notes are shown in the same area.
   - The notes pin on the map can be shown in different colours to differentiate the user's own notes from others. 
   - Location is displayed in GPS coordinates - it can instead be displayed in street address for better usability.
   - If there are a lot of notes i.e. >1000 it may cause performance issues. Proper strategy such as pagination needs to be implemented to handle large amount of data. 
   - Text search can be implemented as actual search query on Firestore. There is no partial text search query available from Firestore so alternative method would need to be implemented  
   - iOS 10 compatibility: the app can be run from iOS 10 but display and usability is degraded. More improvements can be made to enhance better support iOS 10.
- Design: Design is kept at bare minimum so those can definitely be improved. Also iPad screen layouts are not tested. 
- Usability: All of the copies or texts can be improved to be more user friendly.
- Accessibility: No particular consideration was given for accessibility. This will need improvement and review.
- Localisation: No localisation was done but all the text strings displayed to the user are in Localizable.strings file to allow easy localisation and translation.
- Some of the enhancement opportunities are marked as TODOs in the code comments.


### Icons/resources
All of the icons and images used in the app were downloaded from FlatIcon.
 - Icons made by [Smashicons](https://www.flaticon.com/authors/smashicons) from www.flaticon.com is licensed by [CC 3.0 BY](http://creativecommons.org/licenses/by/3.0/)

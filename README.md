# ScoutCamp
iOS app supporting the teams cateogrization process in the ZHR organisation.

## Documentation
Documentation, as the whole project, is under development. You can find it [here](https://docs.google.com/document/d/1m-diZK8i68yxEU1yuLx0baG4IDTn4DcOh97H_G2jxhU/edit?usp=sharing).

## Setup
1. Clone the repository.
2. Install [CocoaPods](https://cocoapods.org).
3. Run `pod install` in the project directory.
4. Open `ScoutCamp.xcworkspace` in Xcode.
5. Build and run the project.

## Brief description
- The app is used by the ZHR teams to categorize themselves. The process is done by the team leader, who is responsible for the team. The leader can add new teams, edit their data, and categorize them. 
- Categorization process is based on filling sheets of assignments. Specific category is assigned to each team based on the number of points they have. The points are calculated based on the pre-defined values of each assignment. The app is used to allow to fill the sheets and calculate the points under the hood.
- Currently backend is hosted in the Firebase platform. Next step would be move it to the BE app written by my friend that allow us use the GraphQL API.

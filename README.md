# Flutter To-Do List

An assessment project for the demonstration of my technical knowledge of the Flutter framework.

## Project Description
This To-Do list app allows users to add To-Do cards which are stored locally on their mobile device / browser. All input will be validated before saving locally. Users can delete To-Do cards by marking the cards as complete. The app will calculate and display the remaining time for a To-Do card. There is also basic unit test included with this project.

The base logic of the application uses SharedPreferences to store data locally. This app can be further improved by adding language localizations, a dark mode setting and a proper cloud database where To-Do cards can be stored and synced from any device.

## How to Use The Project
The app is hosted on Heroku and the link is provided below:
https://flutter-to-do-list.herokuapp.com/#/

## How to Run The Project
1. Clone this repository and open the folder with Android Studio or any Flutter IDE of your choice.
2. Ensure an ios / android device or simulator is installed on your PC.
3. Run the app with the following command:
   `flutter run`

## How to Run The Tests
1. Run the command below:
   `flutter test unit_test.dart`






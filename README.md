# Magic Ball
[![Language](https://img.shields.io/badge/language-Swift%205.0-orange.svg)](https://swift.org)

  

Fun magic 8 ball app will give you the answers to your questions.

The app consists of two screens. Shake the device and your ball will be changed, you can watch this interaction on the main screen. The app uses https://8ball.delegator.com API as data source. 
On the answers screen you can see the history of ball’s answers. The history of answers also serves as a data source in offline mode. You can edit history by adding new ones or removing existing.

  

## Description

- The project is based on three-layered architecture. Presentation
layer is responsible for UI part of application. Application layer
contains business logic. Data layer incapsulates interaction with
database and network

- MVVM architecture with Flow coordinator pattern is used for
building flows

- RxSwift helps to share data between ViewControllers, ViewModels and
Models

- Invented by [Yalantis](https://github.com/Yalantis)  NavigationNode pattern is used for navigation
through the app

  

# Project's convention

- Layout for views should be defined programmatically
- Images must be stored in Assets/Images folder
- Colors must be stored in Assets/Colors folder
- All strings must be localized
- All code connected with user-related resources(such as strings,
images, colors) must be generated throught Swiftgen

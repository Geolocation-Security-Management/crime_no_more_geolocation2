# Crime No More - Team Geolocation 2

## Description

The geolocation security management system allows the active personnels to be better mobalised. The nearest guard can receive the push notification from the control room once the crime scene is reported. The guard can also naviagte to the crime scene through the mobile app and update the control room accordingly. The control room can track the crime scene and the guard's real time location.

## The progress done so far

### Mobile App

1. Login feature for the mobile app.
2. Get the realtime location for the mobile app.
3. Get the push notification from postman API to mobile app about the crime scene.
4. Show the navigation to the crime scene.

### Web App

refer to this github repo: [Web App GitHub Repo](https://github.com/thatjosh/geolocation-security-web-client)
## Tech stack used for Mobile App

### Front end

Flutter

### Backend Service

Firebase, Firebase Realtime database

### Cloud Service

Google Cloud Platform and Google Map API

### Calling API
Postman API

## How to use the app

1. Git clone this repo:
`git clone https://github.com/shaunliew/crime_no_more_geolocation2.git`

2. go to your terminal and run the commands below.
 
`flutter analyze`

 `flutter test`

 `flutter run lib/main.dart`
   
3. If possible, use physical device to run the mobile app.

4. For login credential, please use the credential below.
   
```
{
  "email": "chuashanghang02@gmail.com",
  "password": "123456",
}
```

## Demo Video

[video link](https://drive.google.com/file/d/1p4j4hVwkwLbCyh8qbk1l_d1g2TU-ygLw/view?usp=sharing)
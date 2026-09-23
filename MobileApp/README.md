# *AI Travel Squad* : This is a mobile application developed using Flutter, designed to help users discover tourist attractions in Palestine and select destinations that suit their specific travel preferences.

The app offers a simple, interactive experience that begins with the user entering trip details; it then analyzes these preferences to display suitable tourist spots.

📌 Project Concept
The "AI Travel Squad" concept centers on creating an intelligent travel assistant that helps users select appropriate tourist attractions without the need for manual searching. Users input trip details such as:

📍 City
💰 Budget
👥 Number of people
🥾 Trip type
👤 Age group
The app then uses this data to display the tourist destinations that best align with the user's choices..
## ⚙️ ⚙️ App Workflow:
The user journey within the app proceeds as follows:

Splash Screen ↓ Home Page ↓ Route Preferences ↓ Route Details Input ↓ Data Verification ↓ Suggested Locations ↓ Location Details ↓ Favorites / Explore

🧠 System Workflow
1️⃣ Splash Screen
Appears upon launching the AI ​​Travel Squad app.

After a brief moment, the app transitions to the Home Page.

2️⃣ Home Page
Features a brief introduction to the app and displays the main options.

The user can begin the journey by tapping:

Start Journey

This leads to the Route Preferences screen..

## 3️⃣ Preferences Screen

At this stage, the user enters trip details.

### Required Information:

| Data             | Examples
| 📍 City          | Nablus, Jerusalem, Ramallah, Bethlehem |
| 💰 Budget        | Low, Medium, High 
| 👥 Number of People | 1, 2, 3...
| 🥾 Trip Type     | Historical, Nature, Adventure, Family, Friends 
| 👤 Age Group     | Children, Youth, Adults, All Ages   

Before proceeding to the results, the app verifies that all required information has been entered.

If a field is left blank, a message appears prompting the user to complete the information.# 🔍 4️⃣ Recommendation System

Upon clicking **Find Destinations**, the data selected by the user is sent to the results screen.

The application compares the user's preferences with the data on tourist attractions available within the app.

Currently, the matching system relies primarily on:

City
   +
Trip Type
   ↓
Matching Locations
   ↓
Displaying Suitable Locations

A compatibility score is displayed for each location, such as:

AI Match: 95%

> In the current version, the recommendation system is a matching system based on data and preferences; it can be further developed in the future to utilize a genuine AI model..

# 🏛️ 5️⃣ Suggested Places Screen — Results Screen

After processing the preferences, the suggested tourist spots are displayed to the user.

The preferences selected by the user are displayed at the top of the screen:

Your Preferences

📍 Nablus
💰 Medium
🥾 Historical
👤 Adults
👥 2 People
A list of suitable places then appears.

Each place entry includes:

* 📷 Place image
* 📍 City
* 🏛️ Place type
* 📝 Brief description
* 📊 Match percentage
* 🔎 "View Details" button

# 🏛️ 6️⃣ Place Details

Selecting a place takes the user to the details page..

The page includes:

*   A large photo of the place
*   Name of the place
*   City
*   Type of place
*   Description of the place
*   Match percentage
*   ❤️ Add to Favorites
*   🗺️ Open location on the map
*   🔎 Suggest similar places

# ❤️ 7️⃣ Favorites

Users can add places they like to their **Favorites** list.

This allows them to easily revisit these places later without having to search for them again..

Example:

Favorites

❤️ Old City
❤️ Hisham's Palace
❤️ Sebastia

# ✏️ 8️⃣ Edit Preferences

If the user is not satisfied with the results, they can return to the preferences screen and modify their choices..Using the button:

**Edit Preferences ✏️**

The path becomes:

Results

↓ Edit Preferences

↓ Modify Preferences

↓ Find Destinations

↓ New Results

This allows the user to try out more than one set of preferences..

# 📥 9️⃣ Download Travel Guide

The app also offers a **Download Travel Guide** option.

This allows users to download a travel guide to use during their trip.

The download status is displayed to the user, such as:

Connecting...
Downloading 35%
Downloading 80%
Downloading 100%
Download completed successfully!

In case of a weak connection, a suitable message is displayed to the user instead of an unexplained failure.
# 🧩 Key App Features

* ✈️ Trip planning
* 🇵🇸 Discovering tourist attractions in Palestine
* ​​🧠 User-preference-based recommendation system
* 📍 City selection
* 💰 Budget selection
* 👥 Group size selection
* 🥾 Trip type selection
* 👤 Age group selection
* 📊 Match percentage display
* ❤️ Saving places to favorites
* 📖 Viewing location details
* ✏️ Editing preferences
* 📥 Downloading the travel guide
* 📱 Simple, user-friendly interface
# 🛠️ Technologies Used

## Flutter

**Flutter** was used to develop the mobile application, build user interfaces, and handle screen navigation.

## Dart

**Dart** is the programming language used to develop the application.

## Material Design

Ready-made Flutter components were used, such as:


Scaffold
AppBar
Card
DropdownButtonFormField
TextFormField
ElevatedButton
LinearProgressIndicator
ListView




# 📂 Project Structure:
lib/
│
├── main.dart
│
├── data/
│   └── place_data.dart
│
├── models/
│   └── place_model.dart
│
└── screens/
    │
    ├── splash_screen.dart
    ├── home_screen.dart
    ├── preferences_screen.dart
    ├── result_screen.dart
    ├── place_details.dart
    ├── favorites_screen.dart
    └── download_screen.dart

#🔄 Data flow within the app

User data moves from the preferences screen to the results screen. 
Preferences Screen
    │
        ├── City
        ├── Budget
        ├── Number of People
        ├── Trip Type
        └── Age Group
                │
                ↓
        Results Screen
                │
                ↓
       Comparing Preferences
                │
                ↓
       Suitable Places
                │
                ↓
        Place Details
# 🧱 Place Data Model

Information for each tourist site is stored using `PlaceModel`.

Example:


PlaceModel(
  name: "Old City",
  city: "Jerusalem",
  type: "Historical",
  description: "One of the oldest cities in the world.",
  image: "...",
  score: 98,
)

The model includes:


name
city
type
description
image
score


# 🎯 Project Goal

**AI Travel Squad** aims to make planning tourist trips easier and more interactive by offering recommendations for tourist attractions based on user needs.

The project also aims to:

### Promoting Palestinian Tourism:
* 🏛️ Facilitating the discovery of tourist attractions
* 🧠 Providing personalized recommendations
* 📱 Offering a mobile-based travel assistant
* 👥 Enhancing the user experience during trip planning

# 🚀 Future Developments

The project could be further developed by adding:
* 🌤️ Real-time weather information
* 📍 GPS integration
* 💾 Permanent saving of favorites
* Adding a booking system

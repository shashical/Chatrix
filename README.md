 ![chatrix_logo (1)](https://github.com/shashical/realtime_messaging/assets/106883666/9a600f40-1a50-43d1-aa59-710286cb5ba1)
#  Chatrix - Realtime Encrypted Messaging App
This is a real-time encrypted messaging app built using Flutter as the client-side framework, Firebase as the server-side infrastructure, and Cloud Firestore as the database. The app provides secure and private messaging functionality while ensuring real-time communication between users.
Messages are end to end encrypted even the owner can not see what you are sending in messages and also support send document and  images from camera and gallery. Users can see other users profile and whether they are online now or not , pin or mute  chats/groups.  Delete for me/everyone, Clear chats are  also supported in our app
# Features
+ Light/dark mode toggle
+ Change wallpaper
+  Mobile number verification
+  Messages are **end to end Encrypted**
+  Chats are  in realtime
+  One to one chat functionality
+  Chat in group functionality
+  Notification Support
+  Document send Support; 
+  Search functionality
+  invite friends
+  Block/Unblock functionality
+  Update profile
+  Tracks unread messages counts
+  Online Presence
+  Cross-Platform (android and ios)
  
# Tech Stack
**Client:** Flutter

**Server:** Firebase

**DataBase:** Cloud Firestore
# Screenshots
# Installation
To get started with Chatrix, follow these steps:
1. Clone the repository:
   
    ```bash
    git clone https://github.com/shashical/realtime_messaging.git
    ```
2. Navigate to the project directory:
   ```bash
   cd App/realtime_messaging
    ```
3. Install the dependencies:
   ```bash
   flutter pub get
  
4. Set up Firebase and Firestore in your Firebase console
   refer this
   
    https://firebase.google.com/docs/flutter/setup?continue=https%3A%2F%2Ffirebase.google.com%2Flearn%2Fpathways%2Ffirebase-flutter%23article-https%3A%2F%2Ffirebase.google.com%2Fdocs%2Fflutter%2Fsetup&platform=android
5. Connect a physical device or emulator.
6. Run the app:
   ```bash
   flutter run
# Download Apk file
# Environment Variables
Firebase server key
```bash
 SERVER_KEY
```
# Demo
# Working of App
 Verify your number with otp to login in app. A basic information form appears after login asking about profile photo ,username and about .
 ## Home screen
 The top right corner has a pop up menu containing account, new group, Light/Dark mode and logout options.
 A bottom navigation bar allows switch between chats and groups screen
 ## Chats screen
 All the user chats will appear here in such a way that most recent chat appears at top
 Pinned chats will appears first then remaining chat appears in the same order as mentioned above.
 Multiple selects support: on selcting chats a options bar will appear on the screen has pin/unpin, mute/unmute, delete chat options
 A floating action button opens a bottom sheets having all contact saved app user to start chat and section containing non app users having send invites option 
 search functionality
 
# Authors
 + [@shashical](https://github.com/shashical.git)
 + [@rai-rajeev](https://github.com/rai-rajeev.git)

# Important Note 

Please provide required permissions for smooth functioning of app  

 

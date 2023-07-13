 ![chatrix_logo (1)](https://github.com/shashical/realtime_messaging/assets/106883666/9a600f40-1a50-43d1-aa59-710286cb5ba1)
#  Chatrix - Encrypted Real-time Messaging App
This is an encrypted real-time messaging app built using Flutter as the client-side framework, Firebase as the server-side infrastructure, and Cloud Firestore as the database. The app provides secure and private messaging functionality while ensuring real-time communication between the users.
Messages are end-to-end encrypted, that is, not even the developers or the owner of the app can see your messages.
# Features
+  Mobile number verification
+  Search functionality
+ Light/Dark theme toggle
+ Real-time messaging
+ Messages are **End-To-End Encrypted (E2EE)**
+ Chats can be one-to-one or in a group
+ Chats and groups can also be pinned and muted
+ Change wallpaper option
+  Notification feature
+  Supports sending images and documents
+  Invite other users who are in your contacts
+  Block/Unblock a user functionality
+  Update profile option
+  Tracks unread messages counts
+  Tracks whether the user is currently active or not
  
# Tech Stack
**Client:** Flutter

**Server:** Firebase

**DataBase:** Cloud Firestore
# Screenshots
# Installation
To get started with Chatrix, follow these steps:

1. Ensure that you have Flutter and Dart SDK installed on your machine. For installation instructions, refer to the official [Flutter documentation](https://docs.flutter.dev/get-started/install).
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
  
4. To set up Firebase and Firestore for your project, refer [this](https://firebase.google.com/docs/flutter/setup?continue=https%3A%2F%2Ffirebase.google.com%2Flearn%2Fpathways%2Ffirebase-flutter%23article-https%3A%2F%2Ffirebase.google.com%2Fdocs%2Fflutter%2Fsetup&platform=android).
5. Connect a physical device or emulator.
6. Run the app:
   ```bash
   flutter run
# Download Apk file

https://drive.google.com/file/d/17Nve1M5f5DNKvbSWR5JLuxdWbcEwUPfz/view?usp=sharing
# Environment Variables
Firebase Cloud Messaging (FCM) server key 
```bash
 SERVER_KEY
```
# Demo
+ Authenticate yourself and get started
+ Enjoy chatting in real-time, whether in groups or in personal
+ Explore the various features and functionalities provided by the app
# Working of the App
 To log in to the app, please verify your number with the OTP (One-Time Password) you get after entering your number. After logging in, a basic information form will appear, requesting a profile photo, username, and a brief description.
 ## Home page
 In the top right corner, there is a pop-up menu that includes options for your user account (where you can view and edit your account), creating a new group, toggling between Light and Dark theme, and logging out. Choosing to create a new group will take you to another screen where you can select the members you want in your group and then you can initialize the group with a name and photo in the screen that follows.

A bottom navigation bar allows you to switch between the chats and groups screens.
 ## Chats screen
All user chats will be displayed here, with the most recent chat appearing at the top. Pinned chats will appear first, followed by the remaining chats in the same order as mentioned before.

Multiple select support is available. By selecting your desirable chats, an options' bar will appear on the screen, offering the ability to pin/unpin, mute/unmute, or delete the chat(s).

  A floating action button opens a bottom sheet containing all the contacts saved in the app. This allows users to start a chat with the users saved in your contacts. There is also a section for those in the contacts who aren't a user of the app, providing an option to send invitations.

A search functionality is available for searching the contacts.
Tapping on the profile image within each chat will direct you to the profile page of that user.
 ## Groups screen 
 All the groups in which the user is a member will be displayed here, following the same order as the chats screen. The functionalities here are similar to the chats screen, with the ability to perform actions on the groups such as pinning, muting, or deleting.

 ##  Chat Window
 The chat window provides a platform for users to communicate with each other. When you open a chat, the conversation between you and the other user will be displayed.
 
 
 At the bottom of the chat window, there is a text input field where you can type and send messages. You can enter your message and press the send button to send it to the other user.
 
 Additional features:
 
**Attach Icon:** Located beside the text field, the attach icon allows you to send various types of files. You can choose to send media such as documents or images. Images can be from gallery or camera.

**Pop-up Menu:** There is a pop-up menu button present on the top right of the screen. This menu provides options such as clearing the chat history, blocking or unblocking the other user, and changing the wallpaper for this particular chat window.

**Online Status:** In the app bar, you can see the online status of users. This indicates whether the user is currently active in the app or not.

**Multiple Select:** You can select multiple messages in the chat window. When you do so, some options will appear on the app bar, allowing you to perform certain actions on the selected messages (such as deleting and copying, depending on whether you have selected one or more than one).

**Message Editing:** By tapping on a specific message, you are provided with options to edit or correct it. This allows you to make changes to the content of a message sent by you. Note that you can do so only until the message is not read by the other user.

 Tapping on the other user name/phone number (on the app bar) will take you to the other user's profile page.

 The send icon only appear when there is something to send in the text field 
## Group chat window
The group chat window functions similarly to the chat window, but the user interface is designed differently to accommodate group conversations. When you open a group, the conversation among all the group members will be displayed.

The features in the group chat window are similar to those in the chat window, including the ability to send messages, use the attach icon to send files, access the pop-up menu, perform multiple message selection, and edit messages.

Additionally, tapping on the app bar in the group chat window will direct you to the group information page.
## Group Information Page
As the name suggests, this page shows you the details of the group. These include the group name and photo, metadata such as the group creator and the creation timestamp and also a list of participants of the group. The admins saved in your contacts are diplayed first followed by the ones that are not saved in your contacts and then come the non-admins in the similar order. Search functionality (by name/phone number) is provided for this list as well. Parameters such as group name and photo can only be edited by the admins.







 
 
# Authors
 + [@shashical](https://github.com/shashical)
 + [@rai-rajeev](https://github.com/rai-rajeev)

# Important Note 

Please provide the required permissions for smooth functioning of the app.

Also, note that the convention in our app is that a single tick means 'sent' and a double tick means 'read'.

 

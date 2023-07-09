 ![chatrix_logo (1)](https://github.com/shashical/realtime_messaging/assets/106883666/9a600f40-1a50-43d1-aa59-710286cb5ba1)
#  Chatrix - Encrypted Real-time Messaging App
This is an encrypted real-time messaging app built using Flutter as the client-side framework, Firebase as the server-side infrastructure, and Cloud Firestore as the database. The app provides secure and private messaging functionality while ensuring real-time communication between the users.
Messages are end-to-end encrypted, that is, not even the developers or the owner of the app can see your messages.
# Features
+  Mobile number verification
+  Search functionality
+ Light/Dark theme toggle
+ Real-time messaging
+ Messages are **end-to-end Encrypted**
+ Chats can be one-to-one or in a group
+ Chats and groups can also be pinned and muted
+ Change wallpaper option
+  Notification feature
+  Supports sending images and documents
+  Invite other users who are in your contacts
+  Block/Unblock a user functionality
+  Update profile option
+  Tracks unread messages counts
+  Online presence
  
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
  
4. To set up Firebase and Firestore for your project, refer [this](https://firebase.google.com/docs/flutter/setup?continue=https%3A%2F%2Ffirebase.google.com%2Flearn%2Fpathways%2Ffirebase-flutter%23article-https%3A%2F%2Ffirebase.google.com%2Fdocs%2Fflutter%2Fsetup&platform=android).
5. Connect a physical device or emulator.
6. Run the app:
   ```bash
   flutter run
# Download Apk file
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

Multiple select support is available. By selecting chats, an options bar will appear on the screen, offering the ability to pin/unpin, mute/unmute, or delete a chat.

  A floating action button opens a bottom sheet containing all the contacts saved in the app. This allows users to start a chat with saved contacts. There is also a section for non-app users, providing an option to send invitations.

A search functionality is available for searching contacts.
Tapping on the profile image within each chat will direct you to the profile page of that user.
 ## Group screen 
 All the groups in which the user is a member will be displayed here, following the same order as the chats screen. The functionality is similar to the chats screen, with the ability to perform actions on the groups such as pinning, muting, or deleting.

 ##  Chat Window
 The chat window provides a platform for users to communicate with each other. When you open a chat, the conversation between you and the other user will be displayed.
 
 
 At the bottom of the chat window, there is a text input field where you can type and send messages. You can enter your message and press the send button to share it with the other user.
 Additional features
 
Attach Icon: Located in the bottom right corner of the chat window, the attach icon allows you to send various types of files. You can choose to send documents, images from your gallery, or capture photos/videos using the camera.

Pop-up Menu: There is a pop-up menu accessible through a specific action (e.g., long-pressing on a chat or tapping on a user's profile). This menu provides options such as clearing the chat history, blocking or unblocking a user, and changing the wallpaper for the chat window.

Online Status: In the  app bar, you can see the online status of users. This indicates whether the user is currently active or available for chat.

Multiple Select: You can select multiple messages in the chat window by long-pressing on a message. Once selected, an options bar will appear on the screen, allowing you to perform actions on the selected messages. Common options include copying the messages and deleting them.

Message Editing: By tapping on a specific message, you are provided with options to edit or correct it. This allows you to make changes to the content of a sent message.

 The send icon only appear when there is something to send in the text field 
## Group chat window
The group chat window functions similarly to the chat window, but the user interface is designed differently to accommodate group conversations. When you open a group, the conversation among all the group members will be displayed.

The features in the group chat window are similar to those in the chat window, including the ability to send messages, use the attach icon to send files, access the pop-up menu, perform multiple message selection, and edit messages.

Additionally, tapping on the app bar in the group chat window will direct you to the group information page. This page provides details and  such as the group name, members, and other group-related options.
## Group Information Screen
key features of this Screen
Group Name and Description: The page prominently displays the name of the group, along with a description that provides a brief overview or purpose of the group.

Number of Group Members: The page shows the total number of members present in the group.

Group Image: Administrators of the group are allowed to change the group image. They can upload or choose an image to represent the group visually.

List of Group Members: Following the group information, there is a list of group members displayed. Each member is usually represented by their username or profile picture.

Search Functionality: A search icon is present before the list of members. This feature allows you to search for specific members within the group. You can search by entering a phone number or a name to find a particular member quickly.

Member Interaction: Tapping on any member's profile in the list will direct you to the chat window, where you can initiate a chat with that specific member.






 
 
# Authors
 + [@shashical](https://github.com/shashical.git)
 + [@rai-rajeev](https://github.com/rai-rajeev.git)

# Important Note 

Please provide required permissions for smooth functioning of app  

 

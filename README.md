# Abullahtas.dev Web Blog App

This project is a Blog Platform web application developed with Flutter and powered by Firebase and Hasura. The application has a powerful Glassmorphism design and includes SEO compatibility, state management with GetX, a user-friendly interface and admin panel. The goal of the project is to provide an effective experience on the web by creating a blogging platform that offers advanced features with Flutter Web.


# 🔗 Demo
[click here](https://abdullahtas.dev/) to check out a demo of the working application

# 📂 Project Folder Structure

```

root
├── lib
│ ├── core
│ │ ├── network # API integrations and GraphQL configurations
│ │ ├── utils # Utility functions and general tools
│ ├── data
│ │ ├── models # Data models (User, Post, etc.)
│ │ ├── repositories # Hasura and Firebase data processing classes
│ ├── presentation
│ │ ├── admin # Admin panel components and pages
│ │ ├── frontend # Pages and components of the user interface
│ │ ├── controllers # GetX controlled management (Frontend and Backend)
│ │ ├── widgets # Common widgets
│ ├── themes # Light and Dark theme configuration
│ └─── main.dart # Application start point
├── assets # Media files used in the app
└── pubspec.yaml # Package dependencies and settings
```

#  🚀 Features

**Blog Posts:** Support for written and audio blog posts

**Admin Panel:** Manage, edit and delete blogs

**Glassmorphism Design:** A modern and transparent user interface

**SEO Compatibility:** SEO optimization with meta_seo package

**Dark and Light Mode Support:** Personalize the user experience

**Mobile and Web Compatible:** Responsiveness and mobile compatibility

# 📦 Packages Used

**GetX:** State management and navigation

**meta_seo:** Meta tag management for SEO optimization

**firebase_storage:** Firebase storage

**file_picker:** File picker

**audioplayers:** To play audio blog files

**flutter_quill:** Rich text editor

**graphql_flutter:** GraphQL queries and Hasura integration


# 📋 Installation

Follow the steps below to run this project in your local environment:

## 1. Clone the Project

```
git clone https://github.com/username/flutter-web-blog-platform.git
cd flutter-web-blog-platform
```

## Install Required Dependencies

```
flutter pub get
```
## 3. Firebase CLI Configuration

You can use this article for project configuration with Firebase CLI. [Click to go to the article](https://abdullahtas.medium.com/flutter-firebase-cli-c47deb4447a7).


The structures you need to activate via Firebase Console;

* Firebase Storage
* Firebase Auth

## 4. Hasura Settings
* Using Hasura, you can run your SQL queries and manage your database operations.

* GraphQL Endpoint: Add the appropriate GraphQL endpoint for your Hasura project to **core/network/graphql_service.dart**.

* Sample SQL Queries: The following queries are sample SQL queries used in the Hasura database:

```
CREATE TABLE posts (
id SERIAL PRIMARY KEY,
title VARCHAR(255) NOT NULL,
content TEXT,
cover_image VARCHAR(255),
audio_url VARCHAR(255),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 5. Running the Application
Run the following command to start your project:

```
flutter run -d chrome
```

If you encounter a visual loading problem when you run your project, run it with the following command:

```
flutter run -d chrome --web-renderer html

```

If you are going to get build and deploy with hosting, you can get build by running the following command:

```

flutter build web --web-renderer html --release

```

You need to type **/admin-login** to login to the admin page!




## 🤝 Contributing

If you want to contribute to the project, you can submit a pull request or report a bug in GitHub Issues. We look forward to your contributions!


Make a fork.
Create a new branch.

```
git checkout -b feature/feature-name
```
Commit your changes.

```
git commit -m 'Add feature: New feature'
```

Send Branch.

```
git push origin feature/feature-name
```

Open a pull request.



## 📞 Contact

**If you have any questions or suggestions, feel free to contact us.




# ADMINS SCREENSHOTS


<img width="1434" alt="Ekran Resmi 2024-10-28 16 43 04" src="https://github.com/user-attachments/assets/4d24ed92-d690-4cf1-a17b-29fadae0d70e">
<img width="1434" alt="Ekran Resmi 2024-10-28 16 42 50" src="https://github.com/user-attachments/assets/017e6f64-657f-41d3-9d53-7239eb61bc16">
<img width="1434" alt="Ekran Resmi 2024-10-28 16 42 34" src="https://github.com/user-attachments/assets/4ed0f277-c31d-495d-a868-117b438be797">
<img width="1434" alt="Ekran Resmi 2024-10-28 16 42 28" src="https://github.com/user-attachments/assets/7f4a1d0c-b22d-44ed-b672-80bb5541c8e9">


# BLOG SCREENSHOTS


<img width="333" alt="Ekran Resmi 2024-10-28 17 09 46" src="https://github.com/user-attachments/assets/fc5f67dd-3707-4299-8bf3-c36e24f2815c">

<img width="333" alt="Ekran Resmi 2024-10-28 17 09 41" src="https://github.com/user-attachments/assets/2228df2f-3657-42f5-bf06-d110e11cdcf2">

<img width="333" alt="Ekran Resmi 2024-10-28 17 09 35" src="https://github.com/user-attachments/assets/5c39e9a0-7780-4d1b-8d7f-35765f9103a5">

<img width="333" alt="Ekran Resmi 2024-10-28 17 09 31" src="https://github.com/user-attachments/assets/a0d60a4d-20ca-4984-80a0-cdfa60ed014e">

<img width="413" alt="Ekran Resmi 2024-10-28 17 14 15" src="https://github.com/user-attachments/assets/98272d9a-0d72-40cb-9288-298183074851">

<img width="1434" alt="Ekran Resmi 2024-10-28 17 09 03" src="https://github.com/user-attachments/assets/32cf0e66-ab41-41c4-81f7-37f56cc1639a">

<img width="1434" alt="Ekran Resmi 2024-10-28 17 08 59" src="https://github.com/user-attachments/assets/0321ad52-8978-4c4a-8775-ff5f20027f45">

<img width="1434" alt="Ekran Resmi 2024-10-28 17 08 55" src="https://github.com/user-attachments/assets/9f60a962-e7ff-4088-ad2d-6597e9e1b918">

<img width="1434" alt="Ekran Resmi 2024-10-28 17 13 58" src="https://github.com/user-attachments/assets/9a769212-b6f8-446b-a3ef-4b7fb2b3649e">

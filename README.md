# Biomark Mobile Application

## Overview

This project is a mobile application developed for Biomark, a research organization that collects personal information to build predictive models for personalized digital services. Volunteers (participators) can register, manage their profiles, and receive recognition as model contributors. This app ensures data security, with masked identities and secure handling of sensitive information.

## Features

1. User Registration and Login - Simple authentication using email and password.
2. Profile Management - View and edit specific fields in the user profile where the sensitive data which are collected are stored securely.
3. Account Recovery - Users can recover accounts using security questions without directly mapping recovery information to profile data.
4. Data Security - Sensitive data is encrypted, and security best practices are applied to protect user identities.
5. Unsubscribe and Data Deletion - Users can permanently delete their profiles from the Biomark system, ensuring data privacy.

## Project Structure

* Frontend - Developed in Flutter with a focus on an intuitive, easy-to-navigate UI.
* Backend - Utilizes Firebase for authentication and Firestore for storing user data securely.

## Screens

1. Landing Screen
2. Register Screen -  Collects user data and registers them in the Biomark database.
3. Login Screen - Authenticates users to access their profiles.
4. Account Recovery Screen - Allows users to recover their accounts by verifying security questions.
5. Forget Password Screen - Allows users to update teh password.
6. Profile Screen - Displays user information with options to update email and password.

## Security Features

* Data encryption for sensitive information.
* Secure storage using flutter_secure_storage.
* Masked identity handling to ensure that the data team cannot identify users from stored information.

## Getting Started

### Prerequisites

1. Flutter SDK
2. Firebase account for backend services

### Installation

1. Clone the repository - git clone [https://github.com/yourusername/biomark.git](https://github.com/EGD-Dithmeena/Biomark.git)
2. Navigate to the project directory - cd biomark
3. Install dependencies - flutter pub get
4. Configure Firebase for your project.
5. Run the app - flutter run
   
## Contributors
* E.G.D.Dulanji
* Lakindu Perera

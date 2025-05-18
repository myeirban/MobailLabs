# Shop App

A Flutter shopping app that integrates with the Fake Store API (https://fakestoreapi.com/).

## Features

- User authentication with token storage
- Product browsing and cart management
- Language selection (English/Mongolian)
- Persistent cart and language settings

## Getting Started

1. Make sure you have Flutter installed on your machine
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter pub run build_runner build` to generate JSON serialization code
5. Run `flutter run` to start the app

## Testing Credentials

For testing purposes, you can use the following credentials:

- Username: mor_2314
- Password: 83r5^\_

## Project Structure

- `lib/models/` - Data models for products and cart
- `lib/services/` - API service for communicating with the backend
- `lib/providers/` - State management using Provider
- `lib/screens/` - UI screens for the app

## Dependencies

- http: For making API requests
- provider: For state management
- shared_preferences: For storing language preference
- flutter_secure_storage: For storing authentication token
- json_annotation: For JSON serialization
- build_runner: For generating JSON serialization code

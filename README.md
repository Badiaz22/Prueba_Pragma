# Catbreeds - Flutter Mobile Application

A comprehensive Flutter mobile application for discovering and exploring cat breeds. This app provides detailed information about cat breeds from around the world, including physical characteristics, temperament, care requirements, and more.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Architecture](#project-architecture)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Dependencies](#dependencies)
- [Environment Setup](#environment-setup)
- [Running the Application](#running-the-application)
- [Testing](#testing)
- [API Integration](#api-integration)
- [State Management](#state-management)

## Overview

Catbreeds is a feature-rich mobile application built with Flutter that leverages The Cat API to provide users with comprehensive information about different cat breeds. The application follows clean architecture principles and implements best practices for scalable mobile development.

The app allows users to:
- Browse a paginated collection of cat breeds
- Search for specific breeds by name or characteristics
- View detailed information about each breed
- Explore breed characteristics including temperament, physical attributes, and care requirements
- Navigate smoothly between lists and detail views

## Features

### Core Features

- **Breed Discovery**: Browse through a comprehensive, paginated list of cat breeds with lazy loading
- **Advanced Search**: Search for specific cat breeds with real-time results
- **Detailed Information**: View comprehensive breed information including:
  - Physical characteristics (weight, dimensions, profile)
  - Temperament traits and personality
  - Intelligence and sociability levels
  - Compatibility with children and other pets
  - Grooming and health requirements
  - Origin and historical background
  - Life expectancy

### User Experience

- **Responsive Design**: Optimized for various screen sizes and orientations
- **Smooth Navigation**: Seamless transitions between home screen and detail views
- **Loading States**: Clear visual feedback during data fetching
- **Error Handling**: Graceful error management with user-friendly messages
- **Modern UI**: Clean Material Design implementation with custom theming
- **Infinite Scroll**: Automatic pagination as users scroll through breeds

## Tech Stack

### Core Framework
- **Flutter**: v3.4.3+
- **Dart**: v3.4.3+

### Key Technologies
- **State Management**: ChangeNotifier pattern
- **API Communication**: HTTP package
- **Dependency Injection**: Service locator pattern
- **Environment Variables**: flutter_dotenv
- **Testing**: flutter_test, mockito, build_runner

### Target Platforms
- Android
- iOS
- Web
- Linux
- Windows (Windows)
- macOS

## Project Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── domain/           # Business logic and entities
│   ├── entities/     # Data models (BreedEntity, WeightEntity, ImageEntity)
│   ├── exceptions/   # Custom exceptions
│   └── use_cases/    # Business logic operations
├── data/             # Data layer
│   ├── http/         # API communication
│   └── repository/   # Repository implementations
├── presentation/     # UI layer
│   ├── screens/      # Full screens (HomeScreen, CatDetailScreen)
│   ├── widgets/      # Reusable UI components
│   ├── providers/    # State management
│   └── delegates/    # Search delegate
├── di/               # Dependency injection
├── utils/            # Utilities (theme, colors)
└── main.dart         # App entry point
```

### Architecture Layers

**Domain Layer (Business Logic)**
- Contains entities and use cases
- Independent of frameworks and external libraries
- Defines business rules

**Data Layer (API & Storage)**
- Handles API communication with The Cat API
- Implements repositories
- Manages data fetching and caching

**Presentation Layer (UI)**
- Flutter widgets and screens
- State management with ChangeNotifier
- User interaction handling

## Getting Started

### Prerequisites

- Flutter SDK (>=3.4.3)
- Dart SDK (>=3.4.3)
- Git
- Android Studio / Xcode (for native debugging)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Badiaz22/Prueba_Pragma.git
cd catbreeds
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up environment variables:
Create a `.env` file in the project root:
```
CAT_API_URL=https://api.thecatapi.com/v1
CAT_API_KEY=your_api_key_here
```

Obtain your API key from [The Cat API](https://thecatapi.com/)

4. Generate launcher icons:
```bash
flutter pub run flutter_launcher_icons
```

## Project Structure

### Key Directories

**lib/domain/entities/**
- `breed_entity.dart`: Represents a complete cat breed with all attributes
- `weight_entity.dart`: Breed weight information
- `image_entity.dart`: Image metadata

**lib/domain/use_cases/**
- `get_breeds_use_case.dart`: Fetches paginated breed list
- `filter_breeds_use_case.dart`: Implements breed search functionality

**lib/presentation/screens/**
- `home_screen.dart`: Main screen displaying paginated breed list
- `cat_detail_screen.dart`: Detailed view of selected breed

**lib/presentation/widgets/**
- `home/`: Home screen components (header, search bar, cat list, indicators)
- `detail/`: Detail screen components (info cards, attributes, description)
- `search/`: Search functionality components

**lib/presentation/providers/**
- `breed_provider.dart`: Central state management using ChangeNotifier

**test/**
- Comprehensive unit and widget tests organized by type
- Helper utilities and mock implementations
- 100% test coverage for critical paths

## Dependencies

### Core Dependencies
```yaml
flutter:
  sdk: flutter
http: ^1.2.2                    # HTTP client for API calls
flutter_dotenv: ^5.1.0          # Environment variable management
cupertino_icons: ^1.0.6         # iOS style icons
```

### Development Dependencies
```yaml
flutter_test:
  sdk: flutter
mockito: ^5.4.4                 # Mock generation for testing
build_runner: ^2.4.6            # Code generation
flutter_launcher_icons: ^0.13.1 # App icon generation
flutter_lints: ^3.0.0           # Linting rules
coverage_viewer: ^0.0.1         # Coverage visualization
```

## Environment Setup

### 1. Flutter Environment

Ensure Flutter is properly installed:
```bash
flutter doctor
```

### 2. API Configuration

Create `.env` file with your The Cat API credentials:
```
CAT_API_URL=https://api.thecatapi.com/v1
CAT_API_KEY=your_api_key_here
```

### 3. IDE Setup (Recommended)

- **VS Code**: Install Flutter and Dart extensions
- **Android Studio**: Install Flutter and Dart plugins
- Both support hot reload and hot restart

## Running the Application

### Development Mode (Hot Reload)
```bash
flutter run
```

### Release Mode
```bash
flutter run --release
```

### Generate Icons
```bash
flutter pub run flutter_launcher_icons
```

### Build for Distribution

**Android APK:**
```bash
flutter build apk --release
```

**iOS IPA:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## Testing

### Run All Tests
```bash
flutter test
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Generate Coverage Report
```bash
flutter test --coverage
coverage_viewer  # View HTML coverage report
```

### Run Specific Test File
```bash
flutter test test/widget/widgets/home/home_screen_test.dart
```

### Test Structure

Tests are organized into:
- **Unit Tests** (`test/unit/`): Domain and data layer testing
- **Widget Tests** (`test/widget/`): UI component testing
- **Helpers** (`test/helpers/`): Test utilities and mock implementations

## API Integration

### The Cat API

This application uses [The Cat API](https://thecatapi.com/) to fetch breed information.

### API Endpoints Used

**Get Breeds with Pagination:**
```
GET /breeds?limit=10&page=0
```
Returns paginated list of cat breeds

**Search Breeds:**
```
GET /breeds?q=bengal
```
Returns breeds matching the search query

### Rate Limiting

- Free tier: 4 requests/second
- Implementation includes proper error handling for rate limit responses

### Authentication

API key required in request headers:
```
x-api-key: your_api_key_here
```

## State Management

### BreedProvider Architecture

The app uses `ChangeNotifier` pattern for state management:

```dart
class BreedProvider extends ChangeNotifier {
  // Properties
  List<BreedEntity> _breeds = [];
  List<BreedEntity> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  List<BreedEntity> get breeds => _breeds;
  bool get isLoading => _isLoading;
  
  // Methods
  Future<void> fetchBreeds() async { ... }
  Future<void> searchBreeds(String query) async { ... }
}
```

### Provider Usage in UI

```dart
// Access state
final breeds = widget.breedProvider.breeds;

// Listen to changes
AnimatedBuilder(
  animation: breedProvider,
  builder: (context, child) {
    return ListView.builder(
      itemCount: breedProvider.breeds.length,
      itemBuilder: (context, index) {
        return BreedCard(breed: breedProvider.breeds[index]);
      },
    );
  },
)
```

## Build Variants

The application supports multiple build variants:

- **Debug**: Full debugging capabilities, slower performance
- **Release**: Optimized for production, smaller size, faster execution
- **Profile**: Performance testing environment

## Code Quality

### Linting

Run Flutter linter:
```bash
flutter analyze
```

### Code Formatting

Format code with:
```bash
dart format lib/ test/
```

### Best Practices Implemented

- Clean architecture with separation of concerns
- Repository pattern for data access
- Use case pattern for business logic
- Dependency injection for loose coupling
- Widget composition for reusability
- Comprehensive error handling
- Type safety with strong typing
- Documentation comments throughout

## Contributing

When contributing to this project:

1. Follow the established project structure
2. Write tests for new features
3. Add documentation comments
4. Run `flutter analyze` before submitting
5. Ensure all tests pass with `flutter test`

## Troubleshooting

### API Connection Issues
- Verify `.env` file is created and accessible
- Check API key validity
- Ensure internet connection is available
- Check The Cat API service status

### Widget Test Failures
- Run `flutter test --verbose` for detailed output
- Ensure emulator/device is running
- Try `flutter clean && flutter pub get`

### Build Issues
- Run `flutter clean`
- Delete `pubspec.lock` and run `flutter pub get`
- Check Flutter version with `flutter --version`

## Future Enhancements

- Local breed favorites/bookmarks
- Breed comparison feature
- Offline support with caching
- Image gallery with full breed photos
- Social sharing functionality
- Breed recommendations
- User preferences and filters


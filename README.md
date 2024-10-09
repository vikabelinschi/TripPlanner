# TripPlanner

TripPlanner is a SwiftUI application that helps users find the cheapest travel routes between cities. It integrates a Core Data persistence layer, allowing for offline storage of city connections, and uses Combine for efficient data fetching and handling. The app is built using MVVM architecture and includes a Coordinator for navigation management, enabling a seamless and maintainable user experience.

### Features
- **Search for Flights**: Users can search for flight routes between available cities using the intuitive CitySelectorView with autocomplete.
- **Cheapest Route Calculation**: Leverages Dijkstra's algorithm to calculate and display the cheapest route between two cities.
- **Interactive Map**: Displays the selected route on a map using MapKit, with details on each connection and the total price.
- **Offline Mode**: Core Data is used to store connections data, ensuring that users can access routes even without an internet connection.
- **Modular Architecture**: The project follows the MVVM pattern with the use of Coordinator for clean navigation.

### Technologies Used
- **SwiftUI**: For building the user interface with declarative syntax.
- **Combine**: Handles asynchronous events and data fetching.
- **MapKit**: Provides a visual representation of routes on the map.
- **Core Data**: Stores and retrieves city connections for offline functionality.
- **MVVM with Coordinator Pattern**: Ensures maintainability and clear separation of concerns.

### Getting Started
To run the project:
1. Clone the repository.
2. Open `TripPlanner.xcodeproj` in Xcode.
3. The `xcconfig` file is included for convenience, but in a production environment, it is recommended to manage secrets appropriately.
4. Build and run the app.

> Note: The app uses a sample JSON file to populate city connections for unit testing.

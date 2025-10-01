# PostsApp

A SwiftUI iOS application that fetches posts from a public API, allows searching, and lets users mark posts as favorites. Favorite posts are persisted locally using Core Data. The project is built using the MVVM (Model-View-ViewModel) architecture.

---

## Project Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/PostsApp.git
2. Open the project in Xcode:

bash
Copy code
cd PostsApp
open PostsApp.xcodeproj
Build and run:
3. 
Choose a target device or simulator (e.g., iPhone 15).
Run the app with Cmd + R.

## Requirements
iOS 17.0 or later
Xcode 16.2 (16C5032a)
Swift 5.10
No external dependencies

## Architecture: MVVM
The project follows MVVM for separation of concerns:

### 1. Model
Represents the data structures such as Post. Core Data entities (FavoritePostEntity) are mapped into Post for use in the UI.

### 2. ViewModel
- Manages application logic, networking, and persistence. It exposes published properties observed by views.
- PostsViewModel: Fetches posts from the API, handles search, error, and loading states.
- FavoritesViewModel: Manages favorites, including adding, removing, and fetching from Core Data.

### 3. View
- SwiftUI views that present data from ViewModels. Views are declarative and kept lightweight:
- PostsListView: Displays a searchable list of posts.
- PostDetailView: Shows detailed information about a post.
- FavoritesListView: Displays the list of favorited posts.
- PostRowView: Reusable row for both list and favorites.
This separation makes the code more testable, maintainable, and scalable.

## Features
- Fetch posts from API: https://jsonplaceholder.typicode.com/posts
- Display posts in a list with title and user ID
- Search posts by title (real-time filtering)
- Navigate to a detail view for each post
- Mark/unmark posts as favorites with a heart icon
- View all favorites in a dedicated tab
- Persist favorites locally using Core Data
- Show loading indicator while fetching
- Handle error states (e.g., network errors)
- Pull-to-refresh support

## Core Data
The app uses Core Data for persisting favorite posts.
Entity: FavoritePostEntity
Attributes:
- id (Int64)
- userId (Int64)
- title (String)
- body (String)
Favorites are mapped into the Post model when used in the UI.

## Assumptions
- The API always returns valid JSON matching the Post model.
- Only basic fields (id, userId, title, body) are relevant for this app.
- Persistence is limited to favorites only, not the entire posts list.

## Possible Improvements
- Add unit tests for ViewModels and persistence layer
- Add UI tests for navigation and state updates
- Implement offline caching of all posts
- Use SwiftData (introduced in iOS 17) as an alternative to Core Data
- Add pagination for large lists
- Improve UI design with additional styling or grouped sections
- Provide better error handling with retry options

# balibado_longexam1

Flutter app consuming [dummyjson.com](https://dummyjson.com) (Users, Posts, Comments).

## Setup

1. `flutter pub get`
2. Add real font files to `assets/fonts/` (`FrutigerLTStd-Roman.otf`,
   `KlavikaBoldBold.otf`) . These
   binary assets could not be generated here — the folders exist as
   placeholders (each has a `.gitkeep`) but `pubspec.yaml` already
   references the expected filenames, so the app will build once the
   files are dropped in. `SplashScreen`/widgets fall back to Material
   icons if an asset is missing, so the app still runs without them.
3. `flutter run`

## Enhancement 1 — Auth + shared_preferences + Splash screen
- `lib/services/auth_service.dart` — `POST /user/login`, persists the
  user + tokens to `shared_preferences`.
- `lib/providers/auth_provider.dart` — app-wide auth state.
- `lib/screens/splash_screen.dart` — on boot, calls
  `AuthProvider.restoreSession()` and routes to `HomeScreen` (logged
  in) or `SigninScreen` (not logged in).
- `lib/screens/signin_screen.dart` — login form. Try
  `emilys` / `emilyspass` (or any account from
  https://dummyjson.com/users).

## Enhancement 2 — Posts by userID + Settings + Sign Out
- `lib/services/post_service.dart#getPostsByUser` —
  `GET /posts/user/{id}`.
- `lib/screens/profile_screen.dart` — shows the logged-in user's info
  and their posts.
- `lib/screens/settings_screen.dart` — dark-mode & notification
  preference toggles (persisted via `shared_preferences`) and a
  **Sign Out** button that clears the session and returns to
  `SigninScreen`.

## Enhancement 3 — Comments per post + clickable like + add comment
- `lib/services/comment_service.dart` — `GET /comments/post/{postId}`
  and `POST /comments/add`.
- `lib/screens/detail_screen.dart` + `lib/widgets/comment_tile.dart` —
  lists all comments for a post; tapping the heart icon toggles a
  local "liked" state and adjusts the like counter (dummyjson has no
  persistent like endpoint, so this is tracked client-side); an
  "Add a comment" button posts a new comment and prepends it to the
  list.

## Notes
- `provider` was added to `pubspec.yaml` dependencies (not present in
  the original file you shared) because it's used for `ThemeProvider`
  and the new `AuthProvider`. Remove/replace it if your course
  requires a different state-management approach.
- Folder name: `balibado_longexam1`. `pubspec.yaml` name:
  `balibado_advmobprog_longexam1`, as requested.

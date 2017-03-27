# GoEuroMini

This is a tiny version of the GoEuro Demo App.

It is a single view application that uses static json to display details of Travel options between two locations.

This App will work in offline mode by using the cached data.

The UI is simple and intuitive and gets the work done with ease.

Future Scope:
1. This App can be scaled to a multiple view application.
2. Tapping the table rows can take to a details page.
3. More test coverage.
4. The bottom bar can be a TabBar (like the original App) but with just 1 option right now, that would have looked worse.
5. No View-models have been created for this demo because all of the fields in the entity are being used.
6. The UI Components used can be easily reused in a different code-base.
7. The data manipulations can be completely moved out of the viewControllers into the interactor space by means of protocals for each activity. But that would also mean too much data flowing on long routes. Makes sense when the size and complexity of the App is bound to grow.

Cheers!

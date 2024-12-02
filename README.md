# RickAndMorty
RickAndMorty is a simple application that presents a list of Rick and Morty characters with the details of each

- Instructions for building and running the application:

1- You must have an internet connection and XCode Installed
2- Open the application from the "RickAndMorty.xcodeproj" and run the project
3- You can find the Unit Tests in "RMCharactersVMTests" file
4- You can find the UITests in the "RickAndMortyUITests" file

- Assumptions made during the test:

1- I have noticed in the list of characters that some have different colors, So i assumed that each color represents a status

- Challenges encountered:

1- The main challenge that took time is the flickering of images when scrolling up and down fast in the list of characters.
The cell dequeueing was causing the view to show the reused image from a fraction of a second.
Tried multiple solutions including changing the variable in the SwiftUI View to environment object and doing the changes to that variable, but didn't work.

It was fixed by adding a unique id to the outer stack, so the view gets reloaded when the cell is dequeued.

Areas of improvement:

1- Create a generuc network manager to handle network calls usinf Swift Concurrency and return the corresponding model.
2- Move the Network call to a separate service and make it conform to a protocol so we can inject it to the View Model and mock it for testing
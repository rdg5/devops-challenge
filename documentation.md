# Bird app

Awesome application that gives us birds. 
For Data Flow refer to the following sketch: 

![birdApisOriginalSketch](./assets/birdApisOriginal.svg)

## Running the app

### v0
In its original version the app can be ran with the command `go run main.go` in both of the api folders.

### v1
The app can now be run with docker, you can find the two Dockerfiles in the api folders. 
The recommended way would be creating a separate network for the two containers, e.g.: `docker network create --driver bridge bird` and run the two containers using that network `docker run --name birdapi --network bird birdapi` and `docker run --name birdimageapi --network bird birdimageapi`. 
Should you want to test it in your browser, don't forget to expose the necessary ports using `-p 4201:4201` and `-p 4200:4200`.

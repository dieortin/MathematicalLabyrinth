# Mathematical Labyrinth

![Screenshot](https://user-images.githubusercontent.com/6683694/33585553-27b3aef8-d965-11e7-8da8-ff1d3aafa875.png)

## Description

This project consists of a game in which the player must solve mathematical problems in order to advance through a labyrinth
and get to the treasure hidden in it. However, the labyrinth chambers are stored on a separate file which can be modified 
freely to create a new game.

## How to use
Detailed instructions are only provided for Linux/macOS systems, as I don't have a Windows machine myself and personally
discourage using it.

#### 1. Installing the Dart SDK
Building and running the game must be performed using [Pub](https://www.dartlang.org/tools/pub), 
which comes as part of the Dart SDK. You can check detailed instructions on how to install the
Dart SDK in every major OS [here](https://www.dartlang.org/install#automated-installation-and-updates).

#### 2. Cloning the repository
Open a terminal inside the directory where you want to clone the repository, type the following
command and hit Enter: 
```
$ git clone https://github.com/dieortin/MathematicalLabyrinth.git
```
This will result on a new folder containing the source code for Mathematical Labyrinth being created in the directory
where the command was run.

#### 3. Building Mathematical Labyrinth
Still inside the terminal from last step, run the following commands 
```
$ cd MathematicalLabyrinth
$ pub get && pub build
```
to enter the folder, download the required dependencies and build the game.

A new subfolder called _build_ will appear. Inside it you can find another subfolder called _web_, which contains
the built game.

#### 4. Running Mathematical Labyrinth
For testing the game, you can run `$ pub serve`, which spawns a web server locally (usually in the URL localhost:8080) You can
connect to that server using your web browser and typing the URL in the direction bar.

For serving the game in a production server, you can just upload the _web_ folder found inside the _build_ subdirectory
wherever you want.

## Modifying the game
### Editing the labyrinth


# Mathematical Labyrinth
[![Build Status](https://travis-ci.org/dieortin/MathematicalLabyrinth.svg?branch=master)](https://travis-ci.org/dieortin/MathematicalLabyrinth)

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
The chambers and connections of the labyrinth are defined in a file named
labyrinth.json, which is found at the ./web directory.

Each chamber is a new object contained inside the global object of the JSON file. The name of the object is important, as it's used when linking chambers.

You can see an example of a chamber object below:

```
"1S": {
    "text": "La puerta se abre rechinando sobre sus goznes. Tras recorrer 1 km de túnel hacia el N, encuentras una puerta cerrada con un laberinto pintado sobre ella. En 2 minutos el monstruo te alcanzará. Te encuentras con tres cajas una caja de color rosa, una caja de color verde y otra de color azul. La llave que abre la puerta del laberinto está en una de ellas. Cada caja tiene un mensaje escrito en el exterior: CAJA ROSA: La llave está en esta caja CAJA VERDE: La llave no está en esta caja CAJA AZUL: “La llave no está en la caja rosa. A lo sumo, uno de los tres mensajes es verdadero. Sólo puedes abrir una caja. ¿Cuál abrirás? ",
    "choices": [
      {
        "text": "Caja rosa",
        "link": "repetir1S"
      },
      {
        "text": "Caja azul",
        "link": "repetir1S"
      },
      {
        "text": "Caja verde",
        "link": "salida"
      }
    ],
    "time": {
      "seconds": "120",
      "link": "tiempo1"
    }
  }
```

The fields found on the above example are the following:
* text: The text describing each chamber, the question to solve etc.
* choices: An array of objects, each one containing the following fields:
	* text: The text describing each choice
	* link: The name of the chamber where the choice leads
* time: An optional object defining the time limit for choosing an answer, containing the following fields:
	* seconds: The time limit in seconds
	* link: The name of the chamber where the player will be taken if time expires

Chamber objects can also have an aditional field:
* repeating: If its value is "true", the chamber is marked as one where the player is sent when he chooses a wrong option. Chambers marked as "repeating" should only have one object in the "choices" field, with the link being the chamber where the player chose the wrong answer. A time penalty will be applied when loading the link (30 seconds by default, which can be changed in the source file mathematical_labyrinth.dart)

Creating your own labyrinth.json file or editing the default one you can create your own labyrinth.

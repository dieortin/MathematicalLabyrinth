// MathematicalLabyrinth is a web-based educational adventure game
// Copyright (C) 2017  Diego Ortín Fernández <dieortin@gmail.com>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:convert';
import 'dart:async';
import 'package:core_elements/core_animation.dart';

/**
 * The element that contains the labyrinth game itself.
 */
@CustomTag('mathematical-labyrinth')
class MathematicalLabyrinth extends PolymerElement {
  /// Declaring the map that will contain the labyrinth nodes when we load it from the JSON file
  //Map labyrinth = {};

  Map labyrinth = {};

  /// Define the first node of the labyrinth, the one which will be loaded first
  String entryPoint = 'start';

  /// Define the time penalty in seconds that the player will suffer when he chooses a wrong answer
  int wrongAnswerPenalty = 30;

  /// Define the variable that will store the fadeIn animation when the document loads
  CoreAnimation activeNodeContainerFadeIn = new CoreAnimation();

  /// Observable variables that represent the text, choices and timer of our html file respectively. Changing their
  /// value also changes that of their corresponding section in the html file
  @observable
  String historyText = '';
  @observable
  List choices = [];
  @observable
  int timerLabel;

  /// Observable variable that changes the class of the timer label from 'hidden' to 'shown' to make the timer appear
  /// or disappear
  @observable
  String timerLabelClass = 'shown';

  /// Stopwatch and timer to calculate the remaining time in which the player has to solve the problem
  Stopwatch timerStopwatch = new Stopwatch();
  Timer secondCounter;

  /// Integer variable that holds the value of the remaining time for the last question while the user is in a 'wrong'
  /// node, or gets set to null if the user comes from another question (so he got the last one right) to preserve the
  /// independence of timing of each question
  int remainingTime;

  /// This function, triggered when the player clicks on a choice from the list, retrieves the coordinates
  /// where that choice sends the player and calls loadLabyrinthNode() with them
  void handleChoice(Event event, Object detail, LIElement sender) {
    String coordinates = sender.attributes['link'];
    loadLabyrinthNode(coordinates);
    window.scrollTo(0, 0);
  }

  /// This function replaces the text and choices in our html file with the ones from the node that matches
  /// the provided coordinates, if it exists, and throws an exception if no node matches the coordinates.
  /// Coordinates must be provided in the format 'ND', where N= the number of the node and D= the direction
  /// the player is going to through the node.
  void loadLabyrinthNode(String nodeCoordinates) {
    /// Debugging log, use if needed
    //window.console.log('Loading node ' + nodeCoordinates);

    Map node;
    try {
      /// Set the current node to the one with the provided coordinates
      node = labyrinth[nodeCoordinates];

      /// Check if there's a node with the provided coordinates
      if (node == null) {
        throw new Exception('No node exists for those coordinates!');
      } else {
        /// Change the 'text' part of our html file to the new node's text
        historyText = node['text'];

        /// Change the list of choices of our html file to the new node's choices
        choices = node['choices'];

        /// If the node is a 'wrong' node (one that tells you to repeat the problem
        /// again) store the remaining time from the question in the 'remainingTime'
        /// variable, minus the penalization from a wrong choice
        if (node.containsKey('repeating') && node['repeating'] == 'true') {
          remainingTime = timerLabel - wrongAnswerPenalty;

          /// If the remaining time is less than 0, set it to 0 to avoid showing a negative counter
          if (remainingTime <= 0) {
            remainingTime = 0;
          }
        }

        /// If the node has a time limit to solve the problem
        if (node.containsKey('time')) {

          /// Reset the stopwatch just in case there's a previous one running
          timerStopwatch.reset();

          /// If the timer is already set, cancel it
          if (secondCounter != null) {
            secondCounter.cancel();
          }

          /// If there's no remaining time set, set the timer label to the maximum
          /// amount of time the user can have to complete the task, and if there's a
          /// remaining time, set the timer label to it and reset the 'remainingTime'
          /// variable so that if the next node is a 'good' one (a question or
          /// something else that doesn't tell you to repeat the problem) its timer
          /// doesn't start with the remaining time from last problem
          if (remainingTime == null) {
            timerLabel = int.parse(node['time']['seconds']);
          } else {
            timerLabel = remainingTime;
            remainingTime = null;
          }

          /// Store the maximum amount of time the user has for usage later on
          int fullTimer = timerLabel;

          /// Show the timer label to the user
          timerLabelClass = 'shown';

          /// Start the stopwatch just in case it's not already on
          timerStopwatch.start();

          /// Set a loop that will check the stopwatch every 1 second
          Duration oneSecond = new Duration(seconds: 1);
          secondCounter = new Timer.periodic(oneSecond, (Timer _) {

            /// Calculate the remaning time based on the maximum time and the elapsed time from the stopwatch,
            /// and set it to the timer label
            timerLabel = fullTimer - timerStopwatch.elapsed.inSeconds;

            /// Check if the time is already over
            if (timerLabel <= 0) {

              /// Hide and stop the stopwatch just in case the node doesn't exist and the user gets stuck,
              /// to prevent him seeing a negative count
              timerLabelClass = 'hidden';
              timerStopwatch.stop();
              timerStopwatch.reset();
              secondCounter.cancel();

              /// Load the node to which the player should be sent if he doesn't complete the task in time
              loadLabyrinthNode(node['time']['link']);
            }
          });
        } else {
          /// Hide the timer label
          timerLabelClass = 'hidden';
        }

        /// Play the fadeIn animation so that the new text and choices appear nicely
        activeNodeContainerFadeIn.play();
        //activeNodeContainerFadeIn.play();

        /// Debugging log, use if needed
        //window.console.log('Node loaded succesfully!');
      }
    } on Exception {
      /// Debugging logs, use if needed
      //window.console.log('No node exists for coordinates: ' + nodeCoordinates);
      //window.alert('No node exists for coordinates: ' + nodeCoordinates);
    }
  }

  /// Constructor used to create instance of MathematicalLabyrinth.
  MathematicalLabyrinth.created() : super.created() {}

  /// Called when mathematical-labyrinth has been fully prepared (Shadow DOM created,
  /// property observers set up, event listeners attached).
  @override
  ready() {

    /// Set the element with id 'targetId' as target of the animation with id 'animationId',
    /// and return the animation so that it can be assigned to a global variable to make
    /// its play() method available to other parts of the code
    CoreAnimation attachAnimationToTarget(String animationId, String targetId) {
      CoreAnimation animation = this.$[animationId];
      HtmlElement target = this.$[targetId];
      animation.target = target;
      return animation;
    }

    /// Get the JSON file with the labyrinth nodes and decode it into a Map
    HttpRequest.getString('labyrinth.json').then((labyrinthJson) {
      labyrinth = JSON.decode(labyrinthJson);

      /// Start the labyrinth by forcing the load of the first node
      loadLabyrinthNode(entryPoint);
      activeNodeContainerFadeIn = attachAnimationToTarget(
          'activeNodeContainerFadeIn', 'activeNodeContainer');
      activeNodeContainerFadeIn.play();
    });
  }

/*
	 * Optional lifecycle methods - uncomment if needed.
	 *


	/// Called when an instance of mathematical-labyrinth is inserted into the DOM.
	attached() {
		super.attached();
	}


	/// Called when an instance of mathematical-labyrinth is removed from the DOM.
	detached() {
		super.detached();
	}

	/// Called when an attribute (such as  a class) of an instance of
	/// mathematical-labyrinth is added, changed, or removed.
	attributeChanged(String name, String oldValue, String newValue) {
	}*/

/*

  void testAllNodes() {
    window.console.log('///////// TESTING ALL NODES /////////');
    labyrinth.forEach((key, value) {
      if (value['choices'] != null) {
        for (var choice in value['choices']) {
          try {
            if (labyrinth[choice['link']] == null) {
              throw new Exception('Link ${choice['link']} (present in node ${key}) is broken!');
            }
          } catch (err) {
            window.console.log(err);
          }
        }
      }
    });
  }*/
}

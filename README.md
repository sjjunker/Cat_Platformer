# Overview

I've always been interested in building a game, so I was excited to get started using Apple's SpriteKit to try to build a simple platformer game. I'm not familiar with a lot of game mechanics, so this small application was quite a struggle for me. For each thing I learned, I found there were multiple new things I didn't understand yet. I still have a long way to go before I can build a game worthy of other people to play. However, given the amount of time I spent on this project, I'm happy with what I did accomplish.

This game is a single screen platformer game where the player plays as a cat. A playful tune plays in the background on a loop, while the player uses the "wasd" keys to move around the screen. There are some green fish on the screen for the player to collect for points, and a single "rat" enemy that takes away health points if the player does not attack (using the space bar) when they encounter it.

There is a lot to say about what the game lacks (see FutureWork), but my main purpose was to learn something new about programming. Some of the things I learned include how to animate with texture atlases and SKActions, how to apply basic physics to sprite nodes, how to deal with user input for movement and other interactions, using collision detection, and the importance of not forgetting to set the zPosition of your nodes. All in all, I definitely met my purpose to try something I've never done before and learn a lot from it. 

[Software Demo Video](https://youtu.be/dO_66kaHFEw)

# Development Environment

* xCode with Swift
* Apple SpriteKit and GamePlayKit Frameworks
* Ezgif for cutting spritesheets
* OpenGameArt for Tiles and Sprites


# Useful Websites

* [OpenGameArt](https://opengameart.org)
* [Ezgif](https://ezgif.com/split)
* [Sprite Animation with SpriteKit](https://www.createwithswift.com/sprite-animation-with-spritekit/)
* [SpriteKit Tutorial for Beginners](https://www.kodeco.com/71-spritekit-tutorial-for-beginners)
* [Swift Resources - Apple Developer](https://developer.apple.com/swift/resources/)
* [SpriteKit | Apple Developer Documentation](https://developer.apple.com/documentation/spritekit)


# Future Work

* Make a GameOver or YouWin screen.
* Loop through sprite animations without restarting before the animation ends.
* Fix how health points count down, so you don't die so fast.
* Add soundeffects for jumping, running/walking, and attacking. Maybe also add some meows and squeaks ...
* Keep the cat from flying!!!
* Implement health point decrement for falling off screen, and restart the player's position on the ground nearby.


# Credits

* Sneaky Adventure by Kevin MacLeod | https://incompetech.com/
Music promoted by https://www.chosic.com/free-music/all/
Creative Commons CC BY 3.0
https://creativecommons.org/licenses/by/3.0/
 

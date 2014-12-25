Game of life (HsQML)
====================================

After reading the book "Programming in Haskell" by Graham Huttom, I wanted to  go back to the game of life example and implement own version of it with a graphical user interface. I did quick search of Haskell GUI libraries and found out that there exists Haskell bindings for Qt Quick. I was familiar with Qt but I didn't have any experience with QML so I decided that now is the perfect time to try it out.

![Game of life running](http://tommiseppanen.github.io/screenshots/screenshot2.png)

##Requirements
- GHC 7.4 or later
- Qt 5.3.0 SDK or later
- HsQML

##Controls
- use Start/Stop button to start and stop simulation
- use Reset to reset simulation to initial state
- use mouse left click to change individual cell states

##Links
- [Conway's Game of Life](http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
- [HsQML](http://www.gekkou.co.uk/software/hsqml/)

# BoardGame-RxSwift

This project is about testing and exploring RxSwift using MVVM architecture with Input/Output for ViewModel.

## MVVM

**MVVM** (Model View ViewModel) is among most popular architecture in iOS community. MVVM allows an easy separation of concerns and a better testability.

### Input/Output

Following the concept of input/output for ViewModel inspired by BlaBlaCar and Kickstarter, ViewModel is a blackbox. You manage the input (user interactions or events) and output (representing view state).
It will help us to write easily tests. We just need to check the outputs by varying the inputs.

## API

This project uses an open API [boardgameatlas.com](https://www.boardgameatlas.com/)

## Scenes

Our application contains 2 scenes.

### GamesList

The first scene is a list view with board games from networking request.
Each cell displays name and thumbnail image of a board game.

### GameDetail

The second scene is the detail of board game when clicking in a cell of first scene. Reuse the same ViewModel that games list.

## Tests

The chosen architecture permit to test easily the ViewModel part.


## Lessons learned

MVVM allows an easy separation of concerns. Writing unit test with input/output ViewModel is easy.
We have a clear view of what is done with the stream of observable.

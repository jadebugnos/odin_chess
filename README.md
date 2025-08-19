# Project: Chess (Ruby CLI)

This is my final capstone project for **The Odin Project** Ruby course. It’s a command-line chess game written in Ruby, implemented using object-oriented programming principles. 

## Project Goals

Build a complete chess game that runs in the command line and shows what I've learned about Ruby, OOP, and good coding practices.

### Objectives

- [x] Two human players can play against each other in the terminal
- [x] Prevent players from making illegal moves
- [x] Detect and declare **check** and **checkmate**
- [x] Allow saving and loading the game (serialization)
- [x] Write Rspec tests for important parts of the program
- [x] keep code modular with clean class and method design

### Extra Features (Stretch Goals)

- [ ] Add a basic AI opponent
- [x] Use Unicode chess characters to display the board

## How to Run

1. **Clone this repository**  
   You can use HTTPS (recommended for most users):  
   ```bash
   git clone https://github.com/jadebugnos/odin_chess.git
   ```
   or SSH (if you have an SSH key set up):
   ```bash
   git clone git@github.com:jadebugnos/odin_chess.git
   ```

2. **Navigate into the project directory**
   ```bash
   cd odin_chess
   ```

3. **Install Ruby**  
   This project requires Ruby 3.3.5.  
   - If you're using rbenv, simply run:  
     ```bash
     rbenv install
     ```  
     *(It will read the `.ruby-version` file and install the correct version.)*
   - If rbenv is not installed, follow the [Official rbenv Installation Guide](https://github.com/rbenv/rbenv#installation) to set it up, then run the command above.  
   - Otherwise, install Ruby 3.3.5 using your preferred method.

4. **Install dependencies**  
   - First, ensure you have Bundler installed:
     ```bash
     gem install bundler
     ```
   - Then install the required gems:
     ```bash
     bundler install
     ```

5. **Run the Game**
   ```bash
   ruby main.rb
   ```
## How to play
### Game Introduction
When you start the game and saved games exist, you’ll first be asked if you want to load one:  
- Type `y` to view and load a saved game.  
- Type `n` to start a brand new game.  

If no saved games are found, the game will automatically start a new one and display the game intro.  

After that, the game will prompt both players to enter their names and choose their colors.  
The White player always moves first.

### How to Make a Move

Moves are entered using **two-step input** with chessboard coordinates (files `a–h` and ranks `1–8`):

1. **Select the piece**  
   - Type the square of the piece you want to move, then press Enter.  
   - Example:  
     ```text
     a2
2. **Select the destination**  
   - Type the square you want the piece to move to, then press Enter.  
   - Example:  
     ```text
     a4
➡️ Together, that move is: `a2 → a4`, entered as two separate inputs.

---

### Special Commands
At any input step, you can also type:  
- `save` — save your current game and exit.  
- `exit` — quit the game immediately (progress will be lost if not saved).  

---

### Rules Reminder
- Input must match valid chess coordinates (`a1` through `h8`).  
- Illegal moves (e.g., moving a rook diagonally) will be rejected, and you’ll be asked to try again.  
- White always moves first, followed by alternating turns.  

### How to Restart

After a game ends (checkmate), you’ll be asked if you want to play again:  
- Type `y` to restart the game.  
- Type `n` to quit.

If you choose to restart:  
1. The board will reset with all pieces in their starting positions.  
2. You’ll be asked if you want to keep the **same players** (names and colors):  
   - Type `y` to use the same players.  
   - Type `n` to enter new player names and choose colors again.  
3. A fresh game begins.

This allows you to quickly start a rematch without retyping player info unless you want to.  

## Features

- **Two-player local play (hotseat)**  
  Both players take turns entering moves on the same terminal.

- **Full move validation**  
  Each piece follows its legal movement rules. Illegal moves are rejected with a helpful warning.

- **Check and checkmate detection**  
  The game automatically notifies players when a king is in check, and ends the game when checkmate occurs.

- **Turn management**  
  White always moves first, followed by alternating turns between players.

- **Save and load games**  
  Players can save the current game at any point and resume later using YAML serialization.

- **Game restart system**  
  After a match ends, players can immediately start a new game, either keeping the same names/colors or entering new ones.

- **Interactive setup**  
  On a fresh game, players are prompted for their names and to choose their colors (White or Black).

- **Command shortcuts**  
  At any input step, players can type:
  - `save` — save and exit the game  
  - `exit` — quit immediately without saving

- **Text-based interface**  
  Runs entirely in the terminal with a clear ASCII chessboard display.

## Future Features

Planned improvements and extensions to enhance gameplay:

- **Smart AI opponent**  
  Add a single-player mode with a computer opponent powered by the **Minimax algorithm with alpha-beta pruning** for efficient decision-making.

- **Advanced chess rules**  
  Implement missing special moves and conditions:
  - Pawn promotion  
  - En passant  
  - Castling  

- **Web-based user experience**  
  Develop a browser-based interface for a more interactive and visually appealing player experience, moving beyond the terminal.

## What I’ve Learned

This project was a great capstone for applying what I’ve learned in The Odin Project’s Ruby course.  
Some key takeaways:  

- **Object-Oriented Design**  
  Designing a complex system like chess required breaking down the game into smaller classes and modules (`Board`, `Pieces`, `Game`, `Serializable`, etc.) and making them work together.  

- **Game State Management**  
  Learned how to handle turn order, restart logic, and tracking piece positions across the entire game.  

- **Serialization with YAML**  
  Implemented saving and loading of game state, and understood how to persist objects and restore them later.  

- **Input Validation**  
  Gained experience writing validation logic to ensure only legal chess moves are accepted, and how to provide meaningful feedback for invalid input.  

- **Separation of Concerns**  
  Saw the value of separating responsibilities (e.g., move validation, checkmate detection, and messages are in their own modules).  

- **User Interaction in the Terminal**  
  Learned how to design clear text-based menus and commands (`save`, `exit`) for a smoother terminal experience.

- **Testing and Quality Assurance**  
  Testing was a huge eye-opener. Writing tests helped me catch bugs, think about edge cases, and refactor with confidence. I realized that good tests don’t just prevent mistakes—they make you a better programmer.

- **Reflection**
  The hardest part was getting move validation and check/checkmate logic right, but figuring it out was incredibly satisfying. This project reinforced that planning carefully, keeping your code focused, testing as you go, and paying attention to code quality are all key to building something that actually works.

Overall, I’ve deepened my understanding of Ruby, problem-solving, and how to structure a larger project from scratch.  


## Tech Stack

### Language & Runtime
- Ruby
- rbenv (Ruby version manager)

### Development Tools
- Git & GitHub (version control and hosting)
- VS Code (code editor)
- Pry-byebug (debugging)
- Rubocop (code linting)
- Bundler (gem dependency management)

### Testing
- RSpec

### Serialization
- YAML (used for saving/loading game state)

## Status
Finished but still open for future improvements

## Acknowledgments
A big thank you to **The Odin Project** curriculum for providing the guidance, structure, and motivation that made this project possible. The step-by-step approach and hands-on projects really helped me grow as a developer and gain the confidence to tackle something as complex as building a complete chess game.
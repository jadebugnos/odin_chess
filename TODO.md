# TODO

## Game Flow

### Game Preparations
- [ ] Create a `prepare_game` method to handle setup before starting the game loop
  - [x] Print intro message
  - [x] Set up initial board with all pieces
  - [ ] Ask for player names and assign them to `BlackPlayer` and `WhitePlayer`
  - [ ] Ask each player to choose their color (black or white)

## Player move validation 
- [ ] allow players to choose if they want coordinate system or Algebraic Notation to move pieces
- [ ] implement Notation based movement
- [ ] implement Notation to index based conversion feature for Board manipulation
    
## Legal Moves Validation
### Pawn Movement & Rules

#### Phase 1: Basic Movement
- [x] Create `Pawn` class that inherits from `Piece`
- [x] Define `@legal_moves_white` and `@legal_moves_black`
- [x] Implement `legal_move?` using delta comparison
- [x] Allow 1-step forward movement
- [x] Allow 2-step forward movement **only from starting row**

#### Phase 2: Capturing
- [ ] Allow diagonal movement **only if capturing**
- [ ] Prevent capturing own pieces
- [ ] Disallow diagonal movement if target square is empty

#### Phase 3: Edge Cases
- [ ] Prevent moving forward into an occupied square
- [ ] Prevent all moves that go out of bounds (0..7)
- [ ] Disallow backward or sideways movement

#### Phase 4: Special Moves (Optional for now)
- [ ] Add promotion when reaching the last rank
- [ ] Add en passant logic (optional, can do later)

# TODO

## Game Flow
### Game Preparations
[ ] create a prepare_game method to setup game before running the game loop. 
    - [X] print intro
    - [X] setup board pieces initial positions
    - [ ] ask and assign names to Player's children objects(black/white)
    - [ ] ask and assign colors to players (black or white)
    
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
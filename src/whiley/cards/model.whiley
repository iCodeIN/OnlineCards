package cards

import uint from std::integer
import js::core with string
import cards::cards with Card

/**
 * User waiting outside room, choosing either to enter an existing
 * room or create a new room.
 */
public uint WAITING = 0
/**
 * User has selected to enter an existing room.  We are loading assets
 * related to that room.
 */
public uint ENTERING = 1
/**
 * User has decided to create a new room.  We are loading assets
 * related to that.
 */
public uint CREATING = 2

/**
 * User is in a given room and is either waiting to sit, or is seated
 *  and playing. 
 */ 
final uint PLAYING = 3

/**
 * Represents the current state of the client.
 */ 
public type State is {
    // Current status of user
    uint state,
    // Current room information
    null|Room room
}
// // Ensure state within bounds
// where state <= 3

/**
 * Provides information about the current game.
 */
public type Room is {
    // Name of this room
    string name,
    // Player's seat
    int seat,
    // Information about all players
    (Player|null)[] players,
    // Players hand
    Card[] hand
}
// Always exactly four playing positions.
where |players| == 4

/**
 * Provides information about a given player in the game.
 */
public type Player is {
    // Player's screen name
    string name,
    // Tricks won
    uint tricks
}

/**
 * Initialise client state
 */
public function init() -> State:
    return { state: WAITING, room: null}

/**
 * Attempting to enter room
 */
public function entering_room(State state) -> State:
    state.state = ENTERING
    return state

/**
 * Attempting to create room
 */
public function creating_room(State state) -> State:
    state.state = CREATING
    return state

/**
 * Room status update received
 */
public function update(State state) -> State:
    state.state = PLAYING
    return state

package cards

import js::core with string

public type State is {
    string status
}

/**
 * Initialise client state
 */
public function init() -> State:
    return { status: "Hello" }
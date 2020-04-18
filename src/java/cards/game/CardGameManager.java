package cards.game;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

/**
 * A manager for a given number of card games.
 * 
 * @author David J. Pearce
 *
 */
public class CardGameManager {
	private final ConcurrentHashMap<String, CardGame> games = new ConcurrentHashMap<>();

	/**
	 * Get the list of available card games.
	 * 
	 * @return
	 */
	public List<String> getCardGameNames() {
		ArrayList<String> names = new ArrayList<>(games.keySet());
		Collections.sort(names);
		return names;
	}

	/**
	 * Add a new card game if no game with the same name already exists.
	 * 
	 * @param room
	 * @param game
	 */
	public boolean putCardGame(String room, CardGame game) {
		CardGame response = games.putIfAbsent(room,game);
		return response == game;
	}
	
	/**
	 * Get card game for the given room name. If no such game exists, create one.
	 * 
	 * @param room
	 * @return
	 */
	public CardGame getCardGame(String room) {
		return games.get(room);
	}

	/**
	 * Completely end a game by removing it from this manager.
	 * 
	 * @param room
	 */
	public void endCardGame(String room) {
		games.remove(room);
	}
}

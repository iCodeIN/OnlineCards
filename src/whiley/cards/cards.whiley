package cards

// Suit of Hearts
public final int TWO_HEARTS = 0
public final int THREE_HEARTS = 1
public final int FOUR_HEARTS = 2
public final int FIVE_HEARTS = 3
public final int SIX_HEARTS = 4
public final int SEVEN_HEARTS = 5
public final int EIGHT_HEARTS = 6
public final int NINE_HEARTS = 7
public final int TEN_HEARTS = 8
public final int JACK_HEARTS = 9
public final int QUEEN_HEARTS = 10
public final int KING_HEARTS = 11
public final int ACE_HEARTS = 12
// Suit of Clubs
public final int TWO_CLUBS = 13
public final int THREE_CLUBS = 14
public final int FOUR_CLUBS = 15
public final int FIVE_CLUBS = 16
public final int SIX_CLUBS = 17
public final int SEVEN_CLUBS = 18
public final int EIGHT_CLUBS = 19
public final int NINE_CLUBS = 20
public final int TEN_CLUBS = 21
public final int JACK_CLUBS = 22
public final int QUEEN_CLUBS = 23
public final int KING_CLUBS = 24
public final int ACE_CLUBS = 25
// Suit of Diamonds
public final int TWO_DIAMONDS = 26
public final int THREE_DIAMONDS = 27
public final int FOUR_DIAMONDS = 28
public final int FIVE_DIAMONDS = 29
public final int SIX_DIAMONDS = 30
public final int SEVEN_DIAMONDS = 31
public final int EIGHT_DIAMONDS = 32
public final int NINE_DIAMONDS = 33
public final int TEN_DIAMONDS = 34
public final int JACK_DIAMONDS = 35
public final int QUEEN_DIAMONDS = 36
public final int KING_DIAMONDS = 37
public final int ACE_DIAMONDS = 38
// Suit of Spades
public final int TWO_SPADES = 39
public final int THREE_SPADES = 40
public final int FOUR_SPADES = 41
public final int FIVE_SPADES = 42
public final int SIX_SPADES = 43
public final int SEVEN_SPADES = 44
public final int EIGHT_SPADES = 45
public final int NINE_SPADES = 46
public final int TEN_SPADES = 47
public final int JACK_SPADES = 48
public final int QUEEN_SPADES = 49
public final int KING_SPADES = 50
public final int ACE_SPADES = 51
// Jokers
public final int JOKER_RED = 52
public final int JOKER_BLACK = 53

public type Card is (int x)
// Card had valid index
where x >= TWO_HEARTS && x <= JOKER_BLACK

public type Deck is(Card[] cards)
// Have zero, one or two jokers
where |cards| >= 52 || |cards| <= 54
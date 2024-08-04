extends Container

var suits = ["hearts","clubs","spades","diamonds"];
var ranks = [
	{ "name": "2", "value": 2 },
	{ "name": "3", "value": 3 },
	{ "name": "4", "value": 4 },
	{ "name": "5", "value": 5 },
	{ "name": "6", "value": 6 },
	{ "name": "7", "value": 7 },
	{ "name": "8", "value": 8 },
	{ "name": "9", "value": 9 },
	{ "name": "10", "value": 10 },
	{ "name": "J", "value": 10 },
	{ "name": "Q", "value": 10 },
	{ "name": "K", "value": 10 },
	{ "name": "A", "value": 11 }
];

@export var held = false;

@export_category("card-data")
@export var rank = "2";
@export var suit = "heart";
@export var score = 2;

var selected = false;

func _on_ready():
	ranks.shuffle();
	suits.shuffle();
	
	var newRank = ranks[0];
	var newSuit = suits[0];
	
	suit = newSuit;
	rank = newRank.name;
	score = newRank.value;
	setCardDisplay();

func _on_gui_input(event):
	if (event is InputEventMouseButton && event.button_index == 1):
		if(!held):
			var copy = getCard();
			print(copy);
			Game.dragCard(copy);
			showGhost(true);
	if (event is InputEventMouseButton && event.button_index == 0):
		print("let go of mouse");
		if(held):
			queue_free();

func _process(delta):
	if(held):
		var height_offset = $CardFront.texture.get_size().y / 2;
		var width_offset = $CardFront.texture.get_size().x / 2;
		
		var mousePos = get_global_mouse_position();
		var newPos = Vector2(
			mousePos.x - width_offset, 
			mousePos.y - width_offset
		);
		self.global_position = newPos;

func _on_mouse_entered():
	$Anim.play("select");


func _on_mouse_exited():
	$Anim.play("deselect");


func setCard(newCard):
	suit = newCard.suit;
	rank = newCard.rank;
	score = newCard.score;
	setCardDisplay();

func setDrag(drag):
	held = drag;
	
func getCard():
	return { 
		"suit": suit, 
		"rank": rank, 
		"score": score 
	};

func setCardDisplay():
	$CardFront/Rank.text = rank;
	$CardFront/Suit.text = suit;

func showGhost(show):
	$CardFront.visible = !show;
	$GhostFront.visible = show;

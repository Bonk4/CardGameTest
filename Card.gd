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
@export var ghost = false;
var onBoard = false;
var hoverField = false;
var faceUp = true;

@export_category("card-data")
@export var rank = "2";
@export var suit = "heart";
@export var score = 2;

func _on_ready():
	ranks.shuffle();
	suits.shuffle();
	
	var newRank = ranks[0];
	var newSuit = suits[0];
	
	suit = newSuit;
	rank = newRank.name;
	score = newRank.value;
	
	setCardDisplay();
	$Body/Anim.play("spawn");

func _process(delta):
	if(held):
		var height_offset = $Body/CardFront.texture.get_size().y / 2;
		var width_offset = $Body/CardFront.texture.get_size().x / 2;
		
		var mouse = get_global_mouse_position()
		var towardsMouse = global_position.angle_to(mouse) * -1
		rotation = lerp_angle(rotation, towardsMouse, 10 * delta)
		
		var newPos = Vector2(
			mouse.x - width_offset,
			mouse.y - width_offset
		);
		global_position = lerp(global_position, newPos, 15 * delta);

func _on_gui_input(event):
	if (event is InputEventMouseButton && event.pressed):
		if(!held && !onBoard):
			held = true;
			Game.holdCard(self);
	if (event is InputEventMouseButton && !event.pressed):
		Game.tryTakeTurn(self);
		$Body/Anim.play("idle");
		held = false;

func _on_mouse_entered():
	if(!onBoard):
		$Body/Anim.play("select");

func _on_mouse_exited():
	if(!onBoard):
		$Body/Anim.play("deselect");

func setCard(newCard):
	suit = newCard.suit;
	rank = newCard.rank;
	score = newCard.score;
	setCardDisplay();
	
func getCard():
	return {
		"suit": suit,
		"rank": rank,
		"score": score
	};

func setCardDisplay():
	var displayFormat = "[center]{cardRank}{suitCode}[/center]";
	$Body/CardFront/Rank.text = displayFormat.format(
		{"cardRank": rank, "suitCode": getCode(suit)}
	);
	
func getFrame(suit):
	match suit:
		"clubs":
			return 0;
		"hearts":
			return 1;
		"diamonds":
			return 2;
		"spades":
			return 3;
	
func getCode(suit):
	match suit:
		"clubs":
			return "\u2667";
		"hearts":
			return "\u2662";
		"diamonds":
			return "\u2663";
		"spades":
			return "\u2664";

func hoverPlay():
	$Body/Anim.play("hoverPlay");
	
func unhover():
	$Body/Anim.play("idle");
	
func flip():
	if(faceUp):
		faceUp = false
		$Body/Anim.play("flipDown")
	else:
		faceUp = true
		$Body/Anim.play("flipUp")

func setFaceDown():
	faceUp = false
	$Body/CardFront/Rank.visible = false
	$Body/CardFront/CardBack.visible = true

func setFaceUp():
	faceUp = true
	$Body/CardFront/Rank.visible = true
	$Body/CardFront/CardBack.visible = false
	
func despawn():
	$Body/Anim.play("despawn");

func _on_anim_animation_finished(anim_name):
	if (anim_name == "flipUp"):
		Game.signalCardRevealed()
	if (anim_name == "despawn"):
		self.queue_free()

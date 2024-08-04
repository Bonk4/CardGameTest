extends Node2D

var card = load("res://CardBase.tscn");
var selectedCard: Node = null;

@export var HAND_SIZE = 3;

# draw card
func _on_button_pressed():
	var handCount = $HandRef/Hand.get_child_count(false);
	if(handCount < HAND_SIZE):
		var newCard = card.instantiate();
		$HandRef/Hand.add_child(newCard);


func _on_ready():
	var ref = get_tree().get_root().get_node("./Board");
	Game.loadBoard(ref);
	pass # Replace with function body.

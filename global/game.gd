extends Node

var cardTemplate = load("res://CardBase.tscn");
var board: Node;
var trash: Node;
var field: Node;

var trashSelected: bool = false;
var fieldSelected: bool = false;
var cardHeld: bool = false;

func load(boardRef: Node, trashRef: Node, fieldRef: Node):
	board = boardRef;
	trash = trashRef;
	field = fieldRef;

func removeGhosts():
	for card in get_tree().get_nodes_in_group("CardsInPlay"):
		card.showGhost(false);

func refreshHands():
	board.refreshHands();

func checkDestination(node: Node):
	print("fieldSelected: ", fieldSelected);
	var cardsInField = field.get_child_count();
	if(trashSelected):
		node.queue_free();
	else: 
		if (fieldSelected):
			if (cardsInField == 0):
				node.reparent(field);
				board.refreshHands();
		
	board.refreshHands();
	
	trashSelected = false;
	fieldSelected = false;

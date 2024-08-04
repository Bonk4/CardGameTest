extends Node

var cardTemplate = load("res://CardBase.tscn");
var board;
var trashSelected: bool = false;
var fieldSelected: bool = false;

func loadBoard(boardRef):
	board = boardRef;

func dragCard(cardData):
	var dragCard = cardTemplate.instantiate();
	dragCard.setCard(cardData);
	dragCard.setDrag(true);
	board.add_child(dragCard);

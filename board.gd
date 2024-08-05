extends Node2D

var cardTemplate = load("res://CardBase.tscn")
var selectedCard: Node = null

@export var hand_size = 3

func _on_ready():
	var boardRef = get_tree().get_root().get_node("./Board")
	var trashRef = get_tree().get_root().get_node("./Board/TrashRef/Body/Trash")
	var fieldRef = get_tree().get_root().get_node("./Board/FieldRef/Field")
	var playerScoreRef = get_tree().get_root().get_node("./Board/PlayerScore/Display")
	var cpuScoreRef = get_tree().get_root().get_node("./Board/CpuScore/Display")
	var resultScoreRef = get_tree().get_root().get_node("./Board/ResultDisplay")
	
	Game.load(boardRef, trashRef, fieldRef, playerScoreRef, cpuScoreRef, resultScoreRef)

func refreshHands():
	for field in get_tree().get_nodes_in_group("Fields"):
		field.queue_sort()

# field colliders
func _on_field_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.get_groups().any(isCard):
		Game.hoverField()

func _on_field_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area == null || area.get_groups().any(isCard):
		Game.unhover()

func isCard(group):
	return group == "CardsInPlay"

# draw card
func drawPlayerCard():
	var handCount = $HandRef/Hand.get_child_count(false)
	if(handCount < hand_size):
		var newCard = cardTemplate.instantiate()
		$HandRef/Hand.add_child(newCard)

func addCpuCard():
	var card = cardTemplate.instantiate()
	card.setFaceDown()
	card.onBoard = true
	$CpuFieldRef/Field.add_child(card)

func revealCpuCards():
	var cpuCards = getCpuCards()
	for card in cpuCards:
		if(!card.faceUp):
			card.flip()

func removeCardsFromPlay():
	var cards = getAllCards()
	for card in cards:
		card.queue_free()

func getAllCards():
	var cards = [];
	cards.append_array(getCpuCards())
	cards.append_array(getPlayerCards())
	return cards
	
func getCpuCards():
	return $CpuFieldRef/Field.get_children()

func getPlayerCards():
	return $FieldRef/Field.get_children()

func showResult():
	$ResultDisplay/AnimationPlayer.play("showResult")

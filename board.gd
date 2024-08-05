extends Node2D

var card = load("res://CardBase.tscn")
var selectedCard: Node = null

@export var HAND_SIZE = 3

# draw card
func _on_button_pressed():
	var handCount = $HandRef/Hand.get_child_count(false)
	if(handCount < HAND_SIZE):
		var newCard = card.instantiate()
		$HandRef/Hand.add_child(newCard)

func _on_ready():
	var boardRef = get_tree().get_root().get_node("./Board")
	var trashRef = get_tree().get_root().get_node("./Board/TrashRef/Body/Trash")
	var fieldRef = get_tree().get_root().get_node("./Board/FieldRef/Field")
	
	Game.load(boardRef, trashRef, fieldRef);

func refreshHands():
	for field in get_tree().get_nodes_in_group("Fields"):
		field.queue_sort()

# trash colliders
func _on_body_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("collided")
	print(area)
	if area.get_groups().any(isCard):
		Game.trashSelected = true

func _on_body_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area == null:
		Game.trashSelected = false
# field colliders
func _on_field_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("collided")
	print(area)
	if area.get_groups().any(isCard):
		Game.fieldSelected = true
		print("isCard on: Field")

func _on_field_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area == null:
		Game.fieldSelected = false

func isCard(group):
	return group == "CardsInPlay"

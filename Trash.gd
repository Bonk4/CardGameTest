extends ColorRect


func _on_mouse_entered():
	Game.trashSelected = true;


func _on_mouse_exited():
	Game.trashSelected = false;

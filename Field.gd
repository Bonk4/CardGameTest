extends ColorRect




func _on_mouse_entered():
	Game.fieldSelected = true;


func _on_mouse_exited():
	Game.fieldSelected = false;

extends TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _gui_input(event):
	if (event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT):
		GameStats.Restart()
		get_tree().change_scene("res://Main.tscn")
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
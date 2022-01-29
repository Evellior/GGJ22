extends TextureRect

#Janky as all hell
var Builder

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Builder = self.get_parent().get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _gui_input(event):
	if (event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT):
		Builder.setBuildSupplyBeacon()

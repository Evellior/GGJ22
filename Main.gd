extends Node

export(PackedScene) var Goblin_scene
var Direction = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Spawn_timeout():
	var SpawnPoint = ""
	
	if (Direction == 0):
		SpawnPoint = get_node("BottomSpawn/PathFollow2D")
	
	if (Direction == 1):
		SpawnPoint = get_node("LeftSpawn/PathFollow2D")
	
	if (Direction == 2):
		SpawnPoint = get_node("RightSpawn/PathFollow2D")
	
	if (Direction == 3):
		SpawnPoint = get_node("TopSpawn/PathFollow2D")
	
	SpawnPoint.offset = randi()
	
	var Gobo = Goblin_scene.instance()
	add_child(Gobo)
	
	Gobo.position = SpawnPoint.position


func _on_SwapDirection_timeout():
	Direction = randi() % 4

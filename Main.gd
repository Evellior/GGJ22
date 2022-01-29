extends Node

export(PackedScene) var Goblin_scene

export(PackedScene) var Building_Collection

var Direction = 0
var buildings = PoolVector2Array()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func closestBuilding(myLocation):
	var rtn = Vector2()
	var dist = float()
	if (buildings.size() > 0):
		rtn = buildings[0]
		dist = rtn.distance_to(myLocation)
		for i in range(1,buildings.size()):
			if (buildings[i].distance_to(myLocation) < dist):
				rtn = buildings[i]
				dist = rtn.distance_to(myLocation)
	else: rtn = Vector2(myLocation)
	return rtn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func isBuildingHere(location):
	if (buildings.size() > 0):
		for i in buildings.size():
			if (buildings[i].x == location.x && buildings[i].y == location.y):
				return true
	return false

func placeBuilding(location):
	#set location to grid
	var offset = 64.0/2
	location.x -= fmod(location.x, 64.0) - offset - 2
	location.y -= fmod(location.y, 64.0) - offset + 17
	#check is inside build area
	if (location.x > 64 && location.x < 13*64 && location.y > 64 && location.y < 13*64):
		if (!isBuildingHere(location)):
			var newBuilding = Building_Collection.instance()
			newBuilding.position = location
			newBuilding.z_index = location.y
			add_child(newBuilding)
			buildings.push_back(newBuilding.position)
	pass

func _input(event):
	# print(event.as_text())
	if event is InputEventMouseButton:
		if event.is_pressed():
			placeBuilding(event.position)
	pass

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

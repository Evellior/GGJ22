extends Node

export(PackedScene) var Goblin_scene

export(PackedScene) var Building_Collection

var Direction = 0
var buildings = PoolVector2Array()

var tempdelta = 0.0
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
	GameStats.AddPollution(3)
	
	var Time = OS.get_time()
	
	var RandomSeed = Time.second + (Time.minute * 60) + (Time.hour * 60 * 60)
	
	seed(RandomSeed)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!GameStats.IsInWave()):
		if (get_node("Spawn").is_stopped()):
			get_node("Spawn").start()
			_on_SwapDirection_timeout()
	else:
		tempdelta += delta
		if (tempdelta > 2.0):
			GameStats.GoblinKilled()
			tempdelta = 0

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
	var GoblinSprite = ""
	
	var WaveTimer = get_node("Spawn")
	WaveTimer.stop()
	
	var GoblinsToSpawn = GameStats.StartWave()
	
	for i in GoblinsToSpawn:
		var Gobo = Goblin_scene.instance()
		add_child(Gobo)
		
		GoblinSprite = Gobo.get_node("GoblinSprite")
		var Facings = GoblinSprite.frames.get_animation_names()
		GoblinSprite.animation = Facings[Direction]
		
		if (Direction == 3):
			SpawnPoint = get_node("BottomSpawn/PathFollow2D")
		
		if (Direction == 2):
			SpawnPoint = get_node("LeftSpawn/PathFollow2D")
		
		if (Direction == 1):
			SpawnPoint = get_node("RightSpawn/PathFollow2D")
		
		if (Direction == 0):
			SpawnPoint = get_node("TopSpawn/PathFollow2D")
		
		SpawnPoint.offset = randi()
		
		Gobo.position = SpawnPoint.position


func _on_SwapDirection_timeout():
	var DownArrow = get_node("DownArrow")
	var LeftArrow = get_node("LeftArrow")
	var RightArrow = get_node("RightArrow")
	var UpArrow = get_node("UpArrow")
	
	Direction = randi() % 4
	
	DownArrow.visible = false
	RightArrow.visible = false
	LeftArrow.visible = false
	UpArrow.visible = false
	
	if (Direction == 3):
		UpArrow.visible = true
	
	if (Direction == 2):
		RightArrow.visible = true
	
	if (Direction == 1):
		LeftArrow.visible = true
	
	if (Direction == 0):
		DownArrow.visible = true

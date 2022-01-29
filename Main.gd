extends Node

export(PackedScene) var Goblin_scene

export(PackedScene) var Thumper_scene

export(PackedScene) var SolarRail_scene

export(PackedScene) var SupplyBeacon_scene

export(PackedScene) var Core_scene

var wait = 0
var Direction = 0
var buildings = PoolVector2Array()
var nextBuild = ""
var Goblins = Array()
var tempdelta = 0.0
var BuildPhase = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var thumperButton = Button.new()
	thumperButton.text = "Build Thumper"
	add_child(thumperButton)
	placeCore()
	
	GameStats.AddPollution(6)
	
	var Time = OS.get_time()
	
	var RandomSeed = Time.second + (Time.minute * 60) + (Time.hour * 60 * 60)
	
	seed(RandomSeed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!GameStats.IsInWave()):
		if (get_node("Spawn").is_stopped()):
			get_node("Spawn").start()
			_on_SwapDirection_timeout()
		else:
			var TheLabel = get_node("Menu/Label")
			TheLabel.text = String(int(get_node("Spawn").time_left))
	else:
		tempdelta += delta
		if (tempdelta > 5.0):
			var damage = 0
			for goblin in Goblins:
				damage = (randi() % 9) + 1
				if( is_instance_valid(goblin)):
					goblin.DealDammage(10)
					if(!goblin.IsAlive()):
						GameStats.GoblinKilled()
			tempdelta = 0
	
	var GoblinsToRemove = Array()
	
	for i in Goblins.size():
		#if (Gobo.RecheckDirection()):
		if (is_instance_valid(Goblins[i])):
			if (Goblins[i].IsAlive()):
				Goblins[i].CheckDirection(closestBuilding(Goblins[i].position))
			else:
				GoblinsToRemove.push_back(i)
	
	var RemoveIndex = 0
	
	for i in GoblinsToRemove.size():
		RemoveIndex = GoblinsToRemove[i]
		
		Goblins[RemoveIndex].queue_free()
		
	GoblinsToRemove.clear()

func _input(event):
	# print(event.as_text())
	if event is InputEventMouseButton:
		if event.is_pressed():
			match nextBuild:
				"Thumper":
					if(placeThumper(event.position)): nextBuild = ""
				"SolarRail":
					if(placeSolarRail(event.position)): nextBuild = ""
				"SupplyBeacon":
					if(placeSupplyBeacon(event.position)): nextBuild = ""
				"":
					print("Nothing to build")

func _on_Spawn_timeout():
	var SpawnPoint = ""
	var GoblinSprite = ""
	
	BuildPhase = false
	
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
		
		Gobo.CheckDirection(closestBuilding(Gobo.position))
		
		Goblins.push_back(Gobo)


func _on_SwapDirection_timeout():
	var DownArrow = get_node("DownArrow")
	var LeftArrow = get_node("LeftArrow")
	var RightArrow = get_node("RightArrow")
	var UpArrow = get_node("UpArrow")
	
	Goblins.clear()
	
	Direction = randi() % 4
	
	BuildPhase = true
	
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

## Map Tracking
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

func getGridRoundedLocation(exact_location):
	var gridLocation = exact_location
	#set location to grid
	gridLocation.x -= fmod(gridLocation.x, 64.0) - 32
	gridLocation.y -= fmod(gridLocation.y, 64.0) - 32
	return gridLocation

func isBuildingHere(location):
	if (buildings.size() > 0):
		for i in buildings.size():
			if (buildings[i].x == location.x && buildings[i].y == location.y):
				return true
	return false

## Place buildings
func placeCore():
	var coreLocation = getGridRoundedLocation(Vector2(450,450))
	var newBuilding = Core_scene.instance()
	newBuilding.position = coreLocation
	#move to corner in middle of 2x2 block and offset
	newBuilding.position.x -= 32
	newBuilding.position.y -= 32
	newBuilding.z_index = coreLocation.y

	var topLeft = newBuilding.position
	topLeft.x -= 32
	topLeft.y -= 32
	var topRight = newBuilding.position
	topRight.x += 32
	topRight.y -= 32
	var bottomLeft = newBuilding.position
	bottomLeft.x -= 32
	bottomLeft.y += 32
	var bottomRight = newBuilding.position
	bottomRight.x += 32
	bottomRight.y += 32

	buildings.push_back(getGridRoundedLocation(topLeft))
	buildings.push_back(getGridRoundedLocation(topRight))
	buildings.push_back(getGridRoundedLocation(bottomLeft))
	buildings.push_back(getGridRoundedLocation(bottomRight))

	#offset for animation
	newBuilding.position.x += 2
	newBuilding.position.y -= 30
	add_child(newBuilding)

func placeThumper(location):
	#find closest grid location
	location = getGridRoundedLocation(location)
	
	#check is inside build area and other build allowed checks
	if (location.x > 64 && location.x < 13*64 && location.y > 64 && location.y < 13*64 && !isBuildingHere(location) && BuildPhase):
		#offset for individual sprite
		location.x += 2
		location.y -= 15
		var newBuilding = Thumper_scene.instance()
		newBuilding.position = location
		newBuilding.z_index = location.y
		add_child(newBuilding)
		buildings.push_back(getGridRoundedLocation(newBuilding.position))
		return true
	return false

func placeSolarRail(location):
	#find closest grid location
	location = getGridRoundedLocation(location)
	
	#check is inside build area and other build allowed checks
	if (location.x > 64 && location.x < 13*64 && location.y > 64 && location.y < 13*64 && !isBuildingHere(location) && BuildPhase):
		#offset for individual sprite
		location.x += 2
		location.y -= 15
		var newBuilding = SolarRail_scene.instance()
		newBuilding.position = location
		newBuilding.z_index = location.y
		add_child(newBuilding)
		buildings.push_back(getGridRoundedLocation(newBuilding.position))
		return true
	return false

func placeSupplyBeacon(location):
	#find closest grid location
	location = getGridRoundedLocation(location)
	
	#check is inside build area and other build allowed checks
	if (location.x > 64 && location.x < 13*64 && location.y > 64 && location.y < 13*64 && !isBuildingHere(location) && BuildPhase):
		#offset for individual sprite
		location.x += 2
		location.y -= 15
		var newBuilding = SupplyBeacon_scene.instance()
		newBuilding.position = location
		newBuilding.z_index = location.y
		add_child(newBuilding)
		buildings.push_back(getGridRoundedLocation(newBuilding.position))
		return true
	return false
## Menu

func setBuildThumper():
	nextBuild = "Thumper"

func setBuildSolarRail():
	nextBuild = "SolarRail"

func setBuildSupplyBeacon():
	nextBuild = "SupplyBeacon"

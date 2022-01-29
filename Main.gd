extends Node

export(PackedScene) var Goblin_scene
var Direction = 0

var tempdelta = 0.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


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

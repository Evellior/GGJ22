extends Node2D

signal hit_reg
signal rail_reg

export(int) var Speed = 10
export(float) var CheckFrequency = 1.0
export(int) var Health = 10

var GoingTo = Vector2(0,0)
var SinceLastCheck = 0.0
var GoingScale = Vector2(0,0)

var Bouncing = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.disabled = false
	pass

func DealDammage(Amount):
	Health -= Amount

func RecheckDirection():
	return (SinceLastCheck > CheckFrequency)

func CheckDirection(NewDirection):
	SinceLastCheck = 0.0
	if (GoingTo != NewDirection):
		GoingScale = NewDirection - position
		GoingScale = GoingScale.normalized()

func IsAlive():
	return Health > 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	SinceLastCheck += delta
	position += (GoingScale * Speed) * delta
	
	if (Bouncing != 0):
		var MyArea = get_node(".")
		var Areas = MyArea.get_overlapping_areas()
		var OtherLoc = Vector2(0,0)
		var BounceDirection = Vector2(0,0)
		var Me = position
		
		for area in Areas:
			OtherLoc = area.position
			BounceDirection += (Me - OtherLoc).normalized()
		
		position += (BounceDirection * (Speed * 1.2)) * delta
	
	z_index = position.y
	
	var Sprites = get_node("GoblinSprite")
	var Anim = Sprites.frames.get_animation_names()
	var Modded = GoingScale.angle()
	var QuaterTurn = PI / 2
	var HalfQuater = QuaterTurn / 2
	
	Modded += PI
	
	if (Modded < HalfQuater):
		Sprites.animation = Anim[1]
	elif (Modded < (HalfQuater + QuaterTurn)):
		Sprites.animation = Anim[3]
	elif(Modded < (HalfQuater + (QuaterTurn * 2))):
		Sprites.animation = Anim[2]
	elif(Modded < (HalfQuater + (QuaterTurn * 3))):
		Sprites.animation = Anim[0]
	else:
		Sprites.animation = Anim[1]


func _on_Goblin_area_entered(sender):
	if(sender.is_in_group("buildings")):
		Bouncing += 1


func _on_Goblin_area_exited(sender):
	if(sender.is_in_group("buildings")):
		Bouncing -= 1


func _on_hit_reg():
	DealDammage(5)
	pass # Replace with function body.


func _on_rail_reg():
	DealDammage(10)
	pass # Replace with function body.

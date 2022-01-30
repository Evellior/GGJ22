extends Node2D

export var Range : float = 70
export var Attack_Cooldown : float = 1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var fireConsumed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var AttackTimer = get_node("AttackTimer")
	AttackTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var AttackShape = get_node("Attack Area/AttackCollisionShape2D")
	if(!AttackShape.get("disabled") && !fireConsumed):
		var inRange = $"Attack Area".get_overlapping_areas()
		for i in inRange.size():
			var target = inRange[i]
			if(target.is_in_group("buildings")):
				AttackShape.set_deferred("disabled", true)
				fireConsumed = true
				target.emit_signal("reg_hit")
				break

# Attack Timer
func _on_AttackTimer_timeout():
	var AttackShape = get_node("Attack Area/AttackCollisionShape2D")
	AttackShape.set_deferred("disabled", false)
	fireConsumed = false


extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var fireConsumed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var AttackTimer = get_node("AttackTimer")
	AttackTimer.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(_delta):
	var AttackShape = get_node("Attack Area/AttackCollisionShape2D")
	if(!AttackShape.get("disabled") && !fireConsumed):
		var inRange = $"Attack Area".get_overlapping_areas()
		for i in inRange.size():
			var target = inRange[i]
			if(target.is_in_group("goblins")):
				AttackShape.set_deferred("disabled", true)
				fireConsumed = true
				target.emit_signal("rail_reg")
				break


func _on_AttackTimer_timeout():
	var AttackShape = get_node("Attack Area/AttackCollisionShape2D")
	AttackShape.set_deferred("disabled", false)
	fireConsumed = false
	pass # Replace with function body.

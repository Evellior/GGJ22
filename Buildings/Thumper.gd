extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var wait = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	var AttackTimer = get_node("AttackTimer")
	AttackTimer.start()
	pass # Replace with function body.

func _process(_delta):
	var AttackShape = get_node("Attack Area/AttackCollisionShape2D")
	if(!AttackShape.get("disabled")):
		if(wait > 0):
			wait -= 1
		else:
			AttackShape.set_deferred("disabled", true)
			wait = 10

func _on_Attack_Area_entered(sender):
	if(sender.is_in_group("goblins")): sender.emit_signal("hit_reg")
	pass # Replace with function body.

func _on_AttackTimer_timeout():
	#var AttackTimer = get_node("AttackTimer")
	#AttackTimer.stop()
	var AttackShape = get_node("Attack Area/AttackCollisionShape2D")
	AttackShape.set_deferred("disabled", false)
	pass # Replace with function body.

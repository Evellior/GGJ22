extends Node2D

signal reg_hit

export var Health : float = 100.0
export var Size : float = 64.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var s = Size/2
	$Boundary.shape.extents = Vector2(s,s)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func TakeDamage(ammount):
	Health -= ammount
	if(Health <= 0): Die()
	
func Die():
	print("A tower has collapsed!")
	self.get_parent().get_parent().RemoveBuilding(self.global_position)
	self.get_parent().queue_free()

func _on_reg_hit():
	TakeDamage(1)

extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var PollutionPercent = (GameStats.PollutionLevel / GameStats.PollutionMax) * 100
	var ReductionAmount = 1.0
	#if(PollutionPercent > 30):
	ReductionAmount = 1.0 - (PollutionPercent / 30)
	if(ReductionAmount < 0.0):
		ReductionAmount = 0.0
	if(ReductionAmount > 1.0):
		ReductionAmount = 1.0
	$Perfect.modulate.a = ReductionAmount
	$AllGood.modulate.a = ReductionAmount
	#if(PollutionPercent > 60):
	ReductionAmount = 1.0 - ((PollutionPercent - 30) / 30)
	if(ReductionAmount < 0.0):
		ReductionAmount = 0.0
	if(ReductionAmount > 1.0):
		ReductionAmount = 1.0
	$Alright.modulate.a = ReductionAmount
	$Caution.modulate.a = ReductionAmount
	#if(PollutionPercent > 90):
	ReductionAmount = 1.0 - ((PollutionPercent - 60) / 30)
	if(ReductionAmount < 0.0):
		ReductionAmount = 0.0
	if(ReductionAmount > 1.0):
		ReductionAmount = 1.0
	$Bad.modulate.a = ReductionAmount
	$Warning.modulate.a = ReductionAmount
	pass

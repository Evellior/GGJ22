extends Node

#varibles for changing the wave strength
var KilledGoblinsScale = 0.3
var PollutionScale = 0.4
var SurvivedScale = 0.2

var TotalGoblinsKilled = 0
var PollutionLevel = 1
var PollutionMax = 100
var WavesSurvived = 0

var PollutionPerWave = 0
var PollutionRegenBank = 100
var PollutionRegenRecovery = 10
var MaxRegen = 0.05

var GoblinsThisWave = 0
var GoblinsKilled = 0

var InWave = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func GoblinKilled():
	TotalGoblinsKilled += 1
	GoblinsKilled += 1

func AddPollution(Amount):
	PollutionPerWave += Amount

func GetPollution():
	return PollutionLevel

func StartWave():
	InWave = true
	GoblinsThisWave = 0
	
	GoblinsThisWave += (TotalGoblinsKilled * KilledGoblinsScale)
	GoblinsThisWave += (PollutionLevel * PollutionScale)
	GoblinsThisWave += (WavesSurvived * SurvivedScale)
	
	print(ceil(GoblinsThisWave))
	
	return ceil(GoblinsThisWave)

func EndWave():
	InWave = false
	WavesSurvived += 1
	GoblinsKilled = 0
	PollutionLevel += PollutionPerWave
	
	if(PollutionLevel > PollutionMax):
		PollutionLevel = PollutionMax
	
	var Max = PollutionRegenBank * MaxRegen
	
	if (Max > PollutionLevel):
		PollutionRegenBank = PollutionRegenBank - PollutionLevel
		PollutionLevel = 0
	else:
		PollutionRegenBank -= Max
		PollutionLevel -= Max
	
	PollutionRegenBank += PollutionRegenRecovery
	
	if(PollutionLevel < 0):
		PollutionLevel = 0
	
	if (PollutionRegenBank > 100):
		PollutionRegenBank = 100

func IsInWave():
	return InWave

func _process(_delta):
	if (InWave):
		if (GoblinsThisWave <= GoblinsKilled):
			EndWave()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

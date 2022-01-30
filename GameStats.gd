extends Node

#varibles for changing the wave strength
var KilledGoblinsScale = 0.0
var PollutionScale = 0.01
var SurvivedScale = 0.0

var TotalGoblinsKilled = 0
var PollutionLevel = 1
var PollutionMax = 100
var WavesSurvived = 0

var Gold = 5
var GoldPerWave = 2

var Score = 0

var PollutionPerWave = 0
var PollutionRegenBank = 100
var PollutionRegenRecovery = 15
var MaxRegen = 0.30

var GoblinsThisWave = 0
var GoblinsKilled = 0

var InWave = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Restart():
	Gold = 5
	GoldPerWave = 2
	Score = 0
	PollutionPerWave = 0
	TotalGoblinsKilled = 0
	PollutionLevel = 1
	WavesSurvived = 0

func GoblinKilled():
	TotalGoblinsKilled += 1
	GoblinsKilled += 1
	Score += 10

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
	
	#GoblinsThisWave = 
	
	print(ceil(GoblinsThisWave))
	
	return ceil(GoblinsThisWave)

func HaveEnough(Amount):
	return (Amount >= Gold)

func Spend(Amount):
	var Return = false
	if(HaveEnough(Amount)):
		Gold -= Amount
		Return = true
	return Return

func AddGoldGain(Amount):
	GoldPerWave += Amount

func EndWave():
	InWave = false
	WavesSurvived += 1
	GoblinsKilled = 0
	PollutionLevel += PollutionPerWave
	Gold += GoldPerWave
	Score += 1
	
	var Max = PollutionRegenBank * MaxRegen
	
	if(PollutionLevel < 0):
		PollutionLevel = 0
	
	PollutionRegenBank += PollutionRegenRecovery
	
	if (PollutionRegenBank > 100):
		PollutionRegenBank = 100
	
	if(PollutionLevel > PollutionMax):
		PollutionLevel = PollutionMax
	
	else:
		if (Max > PollutionLevel):
			PollutionRegenBank = PollutionRegenBank - PollutionLevel
			PollutionLevel = 0
		else:
			PollutionRegenBank -= Max
			PollutionLevel -= Max

func IsInWave():
	return InWave

func _process(_delta):
	if (InWave):
		if (GoblinsThisWave <= GoblinsKilled):
			EndWave()

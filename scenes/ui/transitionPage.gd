extends Control

onready var animPlayer = $AnimationPlayer
onready var missionText = $container/missionText
onready var scoreNeeded = $container/scoreNeeded
onready var scorePoints = $container/yourScorePoints
onready var goTo = ''
var ddb

func _ready():
	SaveLoad.save_data()
	animPlayer.play("inst")
	set_result()

func set_result():
	scorePoints.text = str(GVariables.depth, ' mts')
	if GVariables.depth > GVariables.highScore:
		GVariables.highScore = GVariables.depth 
	SaveLoad.save_data()

func _on_nextBtn_button_up():
	GSignals.inst_sounds('click')
	goTo = 'next'
	animPlayer.play("close")

func _on_homeBtn_button_up():
	GSignals.inst_sounds('click')
	goTo = 'home'
	animPlayer.play("close")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'close' and goTo == 'home':
		GVariables.skipStartPage = false
		ddb = get_tree().change_scene('res://scenes/main.tscn')
		GVariables.changeSpawnCount = 0
	if anim_name == 'close' and goTo == 'next':
		GVariables.skipStartPage = true
		GVariables.changeSpawnCount = 0
		ddb = get_tree().change_scene('res://scenes/main.tscn')

extends Control

onready var soundCheck = $container/soundCheck
onready var musicCheck = $container/musicCheck
onready var soundCheckPosOn  = $container/positionsContainer/soundOnPos
onready var soundCheckPosOff = $container/positionsContainer/soundOffPos
onready var musicCheckPosOn     = $container/positionsContainer/musicOnPos
onready var musicCheckPosOff    = $container/positionsContainer/musicOffPos
onready var settingsAnim =  $AnimationPlayer
var ddbb

func _ready():
	position_check_settings()
	settingsAnim.play("open")
	$container/Label2.text = str(GVariables.highScore, ' mts')

func position_check_settings():
	if GVariables.soundOnOff == true:
		soundCheck.position = soundCheckPosOn.position
	else:
		soundCheck.position = soundCheckPosOff.position
	if GVariables.musicOnOff == true:
		musicCheck.position = musicCheckPosOn.position
	else:
		musicCheck.position = musicCheckPosOff.position

func _on_soundOn_button_down():
	GSignals.inst_sounds('click')
	if soundCheck.position != soundCheckPosOn.position:
		soundCheck.position = soundCheckPosOn.position
		GVariables.soundOnOff = true

func _on_soundOff_button_down():
	GSignals.inst_sounds('click')
	if soundCheck.position != soundCheckPosOff.position:
		soundCheck.position = soundCheckPosOff.position
		GVariables.soundOnOff = false

func _on_musicOn_button_down():
	GSignals.inst_sounds('click')
	if musicCheck.position != musicCheckPosOn.position:
		musicCheck.position = musicCheckPosOn.position
		GVariables.musicOnOff = true

func _on_musicOff_button_down():
	GSignals.inst_sounds('click')
	if musicCheck.position != musicCheckPosOff.position:
		musicCheck.position = musicCheckPosOff.position
		GVariables.musicOnOff = false

func _on_quit_button_up():
	GSignals.inst_sounds('cancel')
	settingsAnim.play("close")
	SaveLoad.save_data()

func _on_credits_button_up():
	GSignals.inst_sounds('click')
	var c = load('res://scenes/ui/credits.tscn').instance()
	add_child(c)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'fadeIn':
		get_tree().change_scene('res://scenes/level/missionOne.tscn')
	if anim_name == 'close':
		self.queue_free()


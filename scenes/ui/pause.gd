extends Control

onready var animPlayer = $AnimationPlayer

func _ready():
	animPlayer.play("inst")

func _on_homeBtn_button_up():
	GSignals.inst_sounds('click')
	get_tree().paused = not get_tree().paused
	get_tree().change_scene('res://scenes/main.tscn')

func _on_exit2_button_up():
	GSignals.inst_sounds('cancel')
	animPlayer.play("close")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'close':
		get_tree().paused = not get_tree().paused
		self.queue_free()

extends Control

func _ready():
	$AnimationPlayer.play("insert")

func _on_Button_button_down():
	GSignals.inst_sounds('cancel')
	$AnimationPlayer.play("close")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'close':
		self.queue_free()

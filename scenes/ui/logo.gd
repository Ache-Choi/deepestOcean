extends Control

var dbdb

func _ready():
	$AnimationPlayer.play("fadeOutLogo")

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()
	dbdb = anim_name

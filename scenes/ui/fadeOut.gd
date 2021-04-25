extends Node2D

var fs

func _ready():
	$AnimationPlayer.play("fadeOut")

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()
	fs = anim_name

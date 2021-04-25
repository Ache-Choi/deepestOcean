extends Spatial

onready var animPlayer = $AnimationPlayer
onready var pointsText = $cont/Viewport/Label

func _ready():
	animPlayer.play("pointsAnim")

func set_amount(numb):
	pointsText.text = str('+ ',numb)

func set_multiply(numb):
	pointsText.text = str('x ',numb)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'pointsAnim':
		self.queue_free()

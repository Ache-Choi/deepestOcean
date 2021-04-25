extends Spatial

export (String) var selfNum

onready var animPlayer = $AnimationPlayer 
onready var mesh = $MeshInstance

onready var spawnPos = Vector3(rand_range(-7.2, 7.2),-50,0)

func _ready():
	randomize()
	mesh.scale = Vector3(.8,.8,.8)
	mesh.material_override.albedo_color = 'ffffff'
	set_material()
	set_position()
	animPlayer.play("animate")

func _physics_process(delta):
	if GVariables.gameOn:
		self.translation.y += GVariables.dropSpeed * delta

func set_material():
	var newMat = load('res://scenes/items/gem_material.tres').duplicate()
	newMat.albedo_texture = load('res://assets/images/gems/treasureBox.png')
	mesh.material_override = newMat

func set_position():
	self.translation = spawnPos

func got_it():
	GSignals.got_treasure_box()
	animPlayer.play("gotIt")

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()

extends Spatial

onready var mesh = $MeshInstance
onready var animPlayer = $AnimationPlayer
onready var spawnPosLeft = Vector3(rand_range(-6.7,-7.2),-50,0)
onready var spawnPosRight = Vector3(rand_range(6.9,7.3),-50,0)
onready var areaCol = $Area
onready var textureArr = ['res://assets/images/fishes/eel.png',
						  'res://assets/images/fishes/shark.png',
						  'res://assets/images/fishes/blowFish.png'
						]
var randFishNum 
onready var side = ''

var dbug

func _ready():
	mesh.translation = Vector3.ZERO
	areaCol.translation = Vector3.ZERO
	randomize()
	set_side()
	randFishNum = floor(rand_range(0,textureArr.size()))
	set_material(textureArr[randFishNum], side)
	if randFishNum == 1:
		if side == 'right':
			animPlayer.play("sharkRight")
		else:
			animPlayer.play("sharkLeft")
	if randFishNum == 2:
		if side == 'right':
			animPlayer.play("blowFishRight")
		else:
			animPlayer.play("blowFishLeft")
			
func set_side():
	var randSideNum = floor(rand_range(0,2))
	if randSideNum == 0:
		side = 'left'
	else:
		side = 'right'

func _physics_process(delta):
	if GVariables.gameOn:
		self.translation.y += GVariables.dropSpeed * delta

func set_material(texture,lr):
	var newMat = load('res://scenes/levels/obstacles/fishMat.tres').duplicate()
	newMat.albedo_texture = load(texture)
	mesh.material_override = newMat
	
	mesh.material_override.albedo_texture = load(textureArr[randFishNum])
	if randFishNum == 0:
		if lr == 'left':
			mesh.rotation_degrees.y = 180
			self.translation = spawnPosLeft
		else:
			mesh.rotation_degrees.y = 0
			self.translation = spawnPosRight
	elif randFishNum == 1 or randFishNum == 2:
		if lr == 'left':
			self.translation = spawnPosRight
		else:
			self.translation = spawnPosLeft

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'sharkLeft' or anim_name == 'sharkRight':
		self.queue_free()
	if anim_name == 'blowFishRight' or anim_name == 'blowFishLeft':
		self.queue_free()
		

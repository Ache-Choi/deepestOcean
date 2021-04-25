extends Spatial

onready var mesh = $MeshInstance
onready var spawnPosLeft = Vector3(rand_range(-6.5,-7),-50,0)
onready var spawnPosRight = Vector3(rand_range(6.7,7.1),-50,0)
onready var side = ''
var dbug

func _ready():
	randomize()
	var randNum = floor(rand_range(0,2))
	if randNum == 0:
		side = 'left'
	else:
		side = 'right'
	set_material()
	set_side(side)

func set_material():
	var newMat = load('res://scenes/levels/obstacles/cliffMat.tres').duplicate()
	mesh.material_override = newMat

func _physics_process(delta):
	if GVariables.gameOn:
		self.translation.y += GVariables.dropSpeed * delta

func set_side(lr):
	if lr == 'right':
		mesh.material_override.albedo_texture = load('res://assets/images/obstacles/cliff.png')
		self.translation = spawnPosLeft
	else:
		mesh.material_override.albedo_texture = load('res://assets/images/obstacles/cliff2.png')
		self.translation = spawnPosRight

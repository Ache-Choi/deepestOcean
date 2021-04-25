extends Spatial

export (String) var selfGemNum

onready var animPlayer = $AnimationPlayer 
onready var mesh = $container/MeshInstance
onready var textureArr = ['res://assets/images/gems/coin.png',
						  'res://assets/images/gems/blueGem.png',
						  'res://assets/images/gems/redGem.png',
						  'res://assets/images/gems/greenGem.png',
						  'res://assets/images/gems/oxygen.png'
						]
onready var gemNameArr = [ 'coin', 'blueGem', 'redGem', 'greenGem','oxygen']

onready var spawnPos = Vector3(rand_range(-7.2, 7.2),-50,0)

func _ready():
	set_material()
	set_position()
	animPlayer.play("animate")

func _physics_process(delta):
	if GVariables.gameOn:
		self.translation.y += GVariables.dropSpeed * delta

func set_material():
	var randNum = floor(rand_range(0,textureArr.size()))
	var newMat = load('res://scenes/items/gem_material.tres').duplicate()
	newMat.albedo_texture = load(textureArr[randNum])
	mesh.material_override = newMat
	selfGemNum = randNum

func set_position():
	self.translation = spawnPos

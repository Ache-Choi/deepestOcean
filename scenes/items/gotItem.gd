extends Spatial

export (String) var selfName

onready var textureArr = ['res://assets/images/gems/coin.png',
						  'res://assets/images/gems/blueGem.png',
						  'res://assets/images/gems/redGem.png',
						  'res://assets/images/gems/greenGem.png',
						  'res://assets/images/gems/oxygen.png'
						]
onready var gemNameArr = ['coin','blueGem', 'redGem', 'greenGem', 'oxygen']
onready var mesh = $MeshInstance
onready var tween = $Tween
onready var animPlayer = $AnimationPlayer

func _ready():
	animPlayer.play("fadeOut")

func set_item(num):
	var newMat = load('res://scenes/items/gem_material.tres').duplicate()
	newMat.albedo_texture = load(textureArr[num])
	mesh.material_override = newMat
	selfName = gemNameArr[num]

func tween_move(from, to):
	tween.interpolate_property(self, 'translation',from, to,.3,Tween.TRANS_QUAD)
	tween.start()

func _on_Tween_tween_completed(object, key):
	if self.selfName == 'blueGem' or self.selfName == 'redGem' or self.selfName == 'greenGem':
		GVariables.gems += 1
		GSignals.update_coins_gems()
	elif self.selfName == 'coin':
		GVariables.coins += 1
		GSignals.update_coins_gems()
	elif self.selfName == 'oxygen':
		GSignals.update_oxy_value(25)
	self.queue_free()

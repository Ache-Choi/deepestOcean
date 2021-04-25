extends Node

export (String) var soundName
export (int) var volu

onready var audioSt = $AudioStreamPlayer

onready var soundPlayerArr = [
						'res://assets/soundMusic/cancel.wav',
						'res://assets/soundMusic/click.wav',
						'res://assets/soundMusic/gotHit.wav',
						'res://assets/soundMusic/gotItem.wav',
						'res://assets/soundMusic/lowOnEnergy.wav',
						'res://assets/soundMusic/roboHiss.wav',
						'res://assets/soundMusic/roboHiss.wav',
						'res://assets/soundMusic/winApplause.wav',
						'res://assets/soundMusic/retro-coin.wav',
						'res://assets/soundMusic/click.wav'
]

onready var soundPlayerArrName = [
						'cancel',
						'click',
						'gotHit',
						'gotItem',
						'lowEnergy',
						'openHiss',
						'closeHiss',
						'applause',
						'gotCoin',
						'rolClick'
]

func _ready():
	self.set_player_audio(soundName)

func set_player_audio(soundNamee):
	var path
	for i in soundPlayerArrName.size():
		if soundNamee == soundPlayerArrName[i]:
			path = soundPlayerArr[i]

	audioSt.stream = load(path)

	if soundName == 'openHiss':
		audioSt.volume_db = -26
		audioSt.pitch_scale = .7
	elif soundName == 'closeHiss':
		audioSt.volume_db = -45
		audioSt.pitch_scale = .86
	elif soundName == 'cancel':
		audioSt.volume_db = 5
	elif soundName == 'gotHit':
		audioSt.volume_db = -5
	elif soundName == 'gotItem':
		audioSt.volume_db = -5
	elif soundName == 'lowEnergy':
		audioSt.volume_db = -12
	elif soundName == 'applause':
		audioSt.volume_db = -5
	elif soundName == 'gotCoin':
		audioSt.volume_db = -7
		audioSt.pitch_scale = .7
	elif soundName == 'rolClick':
		audioSt.volume_db = -2
		audioSt.pitch_scale = 2

	audioSt.play()

func _on_AudioStreamPlayer_finished():
	self.queue_free()

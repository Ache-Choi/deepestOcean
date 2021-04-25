extends Node

onready var nextScenePath = 'res://scenes/levels/enviroment.tscn'
onready var playerHP = 0
onready var score = 0
onready var highScore = 0
onready var playerPos = Vector3(0,0,0)
onready var gameOn = false
onready var coins = 0
onready var gems = 0
onready var dropSpeed = 8
onready var skipStartPage = false

onready var musicOnOff = true
onready var soundOnOff = true

onready var changeSpawnCount = 0
onready var prizeBoxCount = 50
onready var boxItemPlayerPicked = []
onready var itemChosenArr = []
onready var correctPicksArr = []
onready var boxItemPicked = ''

onready var depth = 0
onready var itemCountTemp = 0

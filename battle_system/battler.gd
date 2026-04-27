class_name Battler extends Node2D

@export_category("STATS")
@export var max_health: float
var health: float = 100
@export var max_energy: float
var energy: float = 100
@export var speed: float
@export var strength: float = 1.0
@export var defense: float = 1.0

@export_category("MOVES")
@export var move_array: Array[Move]
signal health_updated
var selected_move: Move
var selected_targets: Array[Battler]

var defending: bool

func _ready():
	pass

func select_move(index: int, targets: Array[Battler]):
	print("Battler Selected Move!")
	defending = false
	selected_move = move_array[index]
	selected_targets = targets

func play_animation(animation_name: StringName):
	if !%AnimatedSprite2D:
		return
	# play an animation for the battler here
	var sprite: AnimatedSprite2D  = %AnimatedSprite2D

	sprite.play(animation_name)
	await sprite.animation_finished
	print('Battler played animation')

func damage(value: float):
	if defending:
		health -= (value/defense) / 2
		print('Damaged battler by ', (value/defense) / 2)
	else:
		health -= value/defense
		print("Damaged battler by ", value/defense)
	health_updated.emit()
	print(name, " now has ", health, " hp")

func heal(value: float):
	health += value
	print("healed battler by ", value)
	health_updated.emit()

func defend():
	defending = true
	print('Battler started defending!')

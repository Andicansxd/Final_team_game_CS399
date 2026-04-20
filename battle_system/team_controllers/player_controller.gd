class_name PlayerController extends TeamController

signal battler_selected_move

@export var player_ui: Node2D

func _ready() -> void:
	player_ui.hero_moved.connect(_on_hero_moved)
	decide_moves()
func decide_moves():

	for battler in battler_array:
		await battler_selected_move
	
	moves_decided.emit(self)

func _on_hero_moved(move_index: int, battler_index: int, target_battler_array: Array[Battler]):
	print(battler_index, " has been called to move!")
	print(move_index, " has been called!")
	var battler: Battler = battler_array[battler_index]
	print(battler_array[battler_index].move_array)
	print(battler.move_array)
	battler.select_move(move_index, target_battler_array)
	battler_selected_move.emit()
	print("Battler move decided: ", battler_index)

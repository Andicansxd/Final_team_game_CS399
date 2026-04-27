class_name TurnResolver extends Node

signal turn_resolved

# this can only have two items
@export var teams_array: Array[TeamController] = [null,null]

var teams_dict: Dictionary[TeamController,bool]

func _ready():
	for team in teams_array:
		team.moves_decided.connect(_on_moves_decided)
		teams_dict[team] = false
	print("Connected TeamControllers!")
	BattleService.set_turn_resolver(self)

func get_opposite_team_array(team_controller: TeamController) -> Array[Battler]:
	# this is jank as heck
	var opposite_index = !bool(teams_array.find(team_controller))
	return teams_array[int(opposite_index)].battler_array

func clear_dict_bools():
	for team in teams_dict:
		teams_dict[team] = false

func _on_moves_decided(team_controller: TeamController):
	print(team_controller.name + " has decided it's moves")
	# changes the value of the team that finished its decision in the dictionary to true
	teams_dict[team_controller] = true

	# loops through the values in the dictionary
	for value in teams_dict.values():
		if !value:
			return
	
	resolve_turn()

func resolve_turn():
	print('Resolving turn...')
	var all_battlers: Array[Battler]
	for team_controller in teams_dict.keys():
		for battler in team_controller.battler_array:
			all_battlers.append(battler)
	
	# this (hopefully) sorts the array based on speed
	all_battlers.sort_custom(_sort_by_speed)

	for battler in all_battlers:
		print(battler.name, " is doing a move!")
		await battler.selected_move.resolve_move(battler, battler.selected_targets)
		
	clear_dict_bools()
	
	turn_resolved.emit()
	print("Turn resolved!")

func _sort_by_speed(x: Battler, y: Battler) -> bool:
	return x.speed * x.selected_move.speed_mult < y.speed * y.selected_move.speed_mult

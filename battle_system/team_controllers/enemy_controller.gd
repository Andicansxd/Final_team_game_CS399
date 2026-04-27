class_name EnemyController extends TeamController

func _ready() -> void:
	decide_moves()

func decide_moves():
	for enemy in battler_array:
		var move_i: int = randi_range(0, enemy.move_array.size() - 1)
		print("enemy decide moves ", move_i)
		var move := enemy.move_array[move_i]
		var team: Array[Battler]
		if move.same_team:
			team = BattleService.get_same_team_from_battler(enemy)
		else:
			team = BattleService.get_opposite_team_from_battler(enemy)
		
		if move.all_members:
			enemy.select_move(move_i, team)
		else:
			var target = team.pick_random()
			enemy.select_move(move_i, [target])
	moves_decided.emit(self)
			

func _on_turn_resolver_turn_resolved() -> void:
	print("help")
	decide_moves()

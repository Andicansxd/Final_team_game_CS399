extends Node

var turn_resolver

func set_turn_resolver(_turn_resolver: TurnResolver):
	turn_resolver = _turn_resolver

func get_same_team_from_battler(battler: Battler) -> Array[Battler]:
	var team_controller: TeamController
	for team in turn_resolver.teams_array:
		if battler in team.battler_array:
			team_controller = team
	return team_controller.battler_array

func get_opposite_team_from_battler(battler: Battler) -> Array[Battler]:
	# gonna try to get the opposite team from a single battler
	var team_controller: TeamController
	for team in turn_resolver.teams_array:
		if battler in team.battler_array:
			team_controller = team
	
	return turn_resolver.get_opposite_team_array(team_controller)

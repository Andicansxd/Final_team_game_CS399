extends Node2D

var all_battlers: Array[Battler] = []
@export var turn_resolver: Node
## Sends the info to the controller:
## index 0: attack, index 1: defend, index 2: run, index 3: skill 1, index 4: skill 2, index 5: skill 3, index 4: skill 4
## Array 0: hero 1, Array 1: hero 2, array 2: hero 3, array 3: enemy 1, and so forth
signal hero_moved(index: int, hero_num: int, targets: Array[Battler])
@onready var hero_ui_1 = %hero_ui_1
@onready var hero_ui_2 = %hero_ui_2
@onready var hero_ui_3 = %hero_ui_3
var move_index_stored = null
var hero_num_stored = null
var target = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turn_resolver.turn_resolved.connect(_on_turn_finished)
	call_deferred("retrieve_all_battlers")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func retrieve_all_battlers():
	await get_tree().create_timer(0.1).timeout
	#all_battlers.clear()
	var battler_nodes = get_tree().get_nodes_in_group("enemy_battlers")
	all_battlers.append(hero_ui_1.battler)
	all_battlers.append(hero_ui_2.battler)
	all_battlers.append(hero_ui_3.battler)
	for node in battler_nodes:
		if node is Battler:
			all_battlers.append(node)
	print("Successfully retrieved ", all_battlers.size(), " battlers!")
	if all_battlers.size() == 4:
		%target_button_enemy_2.queue_free()
		%target_button_enemy_3.queue_free()
	elif all_battlers.size() == 5:
		%target_button_enemy_3.queue_free()
func change_current_tab():
	if %TabContainer.current_tab == 1:
		if hero_ui_1.skill_menu_open:
			hero_ui_1.toggle_skill_menu()
	elif %TabContainer.current_tab == 2:
		if hero_ui_2.skill_menu_open:
			hero_ui_2.toggle_skill_menu()
	elif %TabContainer.current_tab == 3:
		if hero_ui_3.skill_menu_open:
			hero_ui_3.toggle_skill_menu()
	if %TabContainer.current_tab == %TabContainer.get_tab_count() - 1:
		%TabContainer.set_current_tab(0)
		%target_button_container.hide()
	else:
		if %target_button_container.hidden:
			%target_button_container.show()
		%TabContainer.set_current_tab(%TabContainer.current_tab + 1)
	if %TabContainer.get_current_tab_control().has_method("input_focus") && Input.get_connected_joypads().size() > 0:
		%TabContainer.get_current_tab_control().input_focus()
	if %TabContainer.get_current_tab_control().has_method("turn_update"):
		%TabContainer.get_current_tab_control().turn_update()
	move_index_stored = null
	hero_num_stored = null
	target = null
	

#temp function. to be replaced once the battle system gets implimented. will be replaced by code that forces a tab change at the end of a turn
func _on_button_pressed() -> void:
	change_current_tab()


func _on_hero_ui_1_hero_move(index: int, hero_num: int) -> void:
	move_index_stored = index
	hero_num_stored = hero_num
	target_selection()
	
func _on_hero_ui_2_1_hero_move(index: int, hero_num: int) -> void:
	move_index_stored = index
	hero_num_stored = hero_num
	target_selection()
func _on_hero_ui_3_1_hero_move(index: int, hero_num: int) -> void:
	move_index_stored = index
	hero_num_stored = hero_num
	target_selection()
func target_selection():
	var target_array: Array[Battler] = []
	if move_index_stored == null || hero_num_stored == null:
		print("no move selected or invalided hero number")
		return
	if all_battlers[hero_num_stored].move_array[move_index_stored].same_team == true:
		target_array = BattleService.get_same_team_from_battler(all_battlers[hero_num_stored])
		if all_battlers[hero_num_stored].move_array[move_index_stored].all_members == true:
			hero_moved.emit(move_index_stored, hero_num_stored, target_array)
			change_current_tab()
			return
	else: 
		target_array = BattleService.get_opposite_team_from_battler(all_battlers[hero_num_stored])
		if all_battlers[hero_num_stored].move_array[move_index_stored].all_members == true:
			hero_moved.emit(move_index_stored, hero_num_stored, target_array)
			change_current_tab()
			return
	if target == null:
		print("no target selected")
		return
	if target in target_array:
		#print(all_battlers[hero_num_stored].move_array)
		var argument_array: Array[Battler] = []
		argument_array.append(target)
		
		hero_moved.emit(move_index_stored, hero_num_stored, argument_array)
		change_current_tab()
	else: 
		print("invalid target")


func _on_target_button_hero_1_pressed() -> void:
	target = all_battlers[0]
	target_selection()

func _on_target_button_hero_2_pressed() -> void:
	target = all_battlers[1]
	target_selection()

func _on_target_button_hero_3_pressed() -> void:
	target = all_battlers[2]
	target_selection()

func _on_target_button_enemy_1_pressed() -> void:
	target = all_battlers[3]
	target_selection()

func _on_target_button_enemy_2_pressed() -> void:
	target = all_battlers[4]
	target_selection()

func _on_target_button_enemy_3_pressed() -> void:
	target = all_battlers[5]
	target_selection()
func _on_turn_finished():
	change_current_tab()

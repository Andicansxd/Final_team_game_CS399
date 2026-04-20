extends Control
## Choses the hero, The id is used for determining the output and elemnts of the UI
@export_enum("hero 1", "hero 2", "hero 3") var hero_id: int
## signal used to tell the tab container to change to a new tab
## links the characture for energy reasons
var battler: Node2D
## stores the starting position for the skill menu for the tweens to use
@onready var skill_home_x: float = %skill_menu.position.x
var active_skill_tween: Tween
## How offset the Tweens starting and ending locations are
var skill_tween_offset: int = 50
## How long the tweens take
var skill_tween_duration: float = 0.3
var skill_menu_open: bool = false
var energy: float = 100
var skill_1_required_energy: int = 100
var skill_2_required_energy: int = 50
var skill_3_required_energy: int = 25
var skill_4_required_energy: int = 1
## Sends the info to the controller: index 0: attack, index 1: defend, index 2: run, index 3: skill 1, index 4: skill 2, index 5: skill 3, index 4: skill 4
signal hero_move(index: int, hero_num: int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%skill_menu.modulate.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func setup_battler():
	if battler == null:
		return
	for i in range(battler.move_array.size()):
		var move_resource = battler.move_array[i]
		match i:
			2: 
				skill_1_required_energy = move_resource.energy_cost
				%skill_1_button.set_text(move_resource.move_name)
			3: 
				skill_2_required_energy = move_resource.energy_cost
				%skill_2_button.set_text(move_resource.move_name)
			4: 
				skill_3_required_energy = move_resource.energy_cost
				%skill_3_button.set_text(move_resource.move_name)
			5: 
				skill_4_required_energy = move_resource.energy_cost
				%skill_4_button.set_text(move_resource.move_name)
	%skill_1_button/energy_label.set_text(str(skill_1_required_energy))
	%skill_2_button/energy_label.set_text(str(skill_2_required_energy))
	%skill_3_button/energy_label.set_text(str(skill_3_required_energy))
	%skill_4_button/energy_label.set_text(str(skill_4_required_energy))
	turn_update()
func toggle_skill_menu():
	if skill_menu_open:
		toggle_skill_menu_anminations()
		skill_menu_open = false
		
	else:
		toggle_skill_menu_anminations()
		skill_menu_open = true
func toggle_skill_menu_anminations():
	if skill_menu_open:
		fly_out()
		if Input.get_connected_joypads().size() > 0:
			%skills_button.grab_focus()
	else:
		if Input.get_connected_joypads().size() > 0:
			%skill_1_button.grab_focus()
		fly_in()
func fly_in():
	if active_skill_tween and active_skill_tween.is_running():
		active_skill_tween.kill()
	active_skill_tween = create_tween()
	%skill_menu.position.x = skill_home_x + skill_tween_offset
	%skill_menu.modulate.a = 0.0
	active_skill_tween.set_trans(Tween.TRANS_QUART)
	active_skill_tween.set_ease(Tween.EASE_OUT)
	active_skill_tween.tween_property(%skill_menu, "position:x", skill_home_x, skill_tween_duration)
	active_skill_tween.parallel().tween_property(%skill_menu, "modulate:a", 1.0, skill_tween_duration)
func fly_out():
	if active_skill_tween and active_skill_tween.is_running():
		active_skill_tween.kill()
	active_skill_tween = create_tween()
	var final_position_x = skill_home_x + skill_tween_offset
	%skill_menu.modulate.a = 1.0
	active_skill_tween.set_trans(Tween.TRANS_QUART)
	active_skill_tween.set_ease(Tween.EASE_OUT)
	active_skill_tween.tween_property(%skill_menu, "position:x", final_position_x, skill_tween_duration)
	active_skill_tween.parallel().tween_property(%skill_menu, "modulate:a", 0.0, skill_tween_duration)
func input_focus():
	%attack_button.grab_focus()
func turn_update():
	energy = battler.energy
	if skill_1_required_energy > energy:
		%skill_1_button.disabled = true
	else:
		%skill_1_button.disabled = false
	if skill_2_required_energy > energy:
		%skill_2_button.disabled = true
	else:
		%skill_2_button.disabled = false
	if skill_3_required_energy > energy:
		%skill_3_button.disabled = true
	else:
		%skill_3_button.disabled = false
	if skill_4_required_energy > energy:
		%skill_4_button.disabled = true
	else:
		%skill_4_button.disabled = false
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("bottom_button") && %skill_menu.visible:
		toggle_skill_menu()

func _on_attack_button_pressed() -> void:
	hero_move.emit(0, hero_id)

func _on_defend_button_pressed() -> void:
	hero_move.emit(1, hero_id)

func _on_skills_button_pressed() -> void:
	toggle_skill_menu()

func _on_run_button_pressed() -> void:
	pass

func _on_skill_1_button_pressed() -> void:
	if not skill_menu_open:
		return
	if skill_1_required_energy > energy:
		return
	hero_move.emit(2, hero_id)


func _on_skill_2_button_pressed() -> void:
	if not skill_menu_open:
		return
	if skill_2_required_energy > energy:
		return
	hero_move.emit(3, hero_id)


func _on_skill_3_button_pressed() -> void:
	if not skill_menu_open:
		return
	if skill_3_required_energy > energy:
		return
	hero_move.emit(4, hero_id)


func _on_skill_4_button_pressed() -> void:
	if not skill_menu_open:
		return
	if skill_4_required_energy > energy:
		return
	hero_move.emit(5, hero_id)

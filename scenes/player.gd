extends CharacterBody2D

const SPEED = 300.0
var entered
var inShop

func get_input():
	var input_direction = Input.get_vector("KEY_A","KEY_D","KEY_W","KEY_S")
	velocity = input_direction * SPEED
	

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("KEY_E") && entered == true:
		get_tree().change_scene_to_file("res://scenes/Shop.tscn")
		inShop = true
	if Input.is_action_just_pressed("KEY_E") && entered == true && inShop == true:
		get_tree().change_scene_to_file("res://scenes/Main_Level.tscn")
		inShop = false
	get_input()
	move_and_slide()
	


func _on_door_area_body_entered(body: Node) -> void:
	entered = true
	
func _on_door_area_body_exited(body: Node2D) -> void:
	entered = false
	

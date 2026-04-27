extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("link_battler")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func link_battler():
	%fight_screen_ui.hero_ui_1.battler = %hero_infight_1/Battler
	%fight_screen_ui.hero_ui_2.battler = %hero_infight_2/Battler
	%fight_screen_ui.hero_ui_3.battler = %hero_infight_3/Battler
	%fight_screen_ui.hero_ui_1.setup_battler()
	%fight_screen_ui.hero_ui_2.setup_battler()
	%fight_screen_ui.hero_ui_3.setup_battler()

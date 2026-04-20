extends Menu

@export var MainMenu: TransitMenu

func _ready() -> void:
	trigger_if_default()

func _on_return_pressed() -> void:
	click_sound.play()
	release()
	MainMenu.summon()

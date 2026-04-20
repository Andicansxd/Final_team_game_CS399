extends Control
class_name Menu

##If true, menu will already be positioned within the viewport. Otherwise, menu will be positioned above the screen.
@export var default: bool
@export var click_sound: AudioStreamPlayer

var slide_duration: float = 1.5
var active: bool = false

func summon() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position:x", 0, slide_duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	await get_tree().create_timer(slide_duration).timeout
	active = true

func release() -> void:
	active = false
	var tween = create_tween()
	tween.tween_property(self, "position:x", (get_viewport_rect().size.x), slide_duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func activate_menu(menu: Menu) -> void:
	release()
	menu.summon()

func trigger_if_default() -> void:
	if !default:
		position.x = (get_viewport_rect().size.x)

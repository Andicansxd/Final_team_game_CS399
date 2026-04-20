extends Menu

@export var MainMenu: TransitMenu

var battle_music_index: int
var bg_music_index: int
var sfx_index: int

var cheats_enabled: bool = false

@onready var toggle_on_norm: CompressedTexture2D = load("res://assets/ToggleIconEnabled.png")
@onready var toggle_on_hov: CompressedTexture2D = load("res://assets/ToggleIconEnabledHover.png")
@onready var toggle_off_norm: CompressedTexture2D = load("res://assets/ToggleIconDisabled.png")
@onready var toggle_off_hov: CompressedTexture2D = load("res://assets/ToggleIconDisabledHover.png")
@onready var background_slider: HSlider = $Volume/BGMusic
@onready var battle_slider: HSlider = $Volume/BATMusic
@onready var SFX_slider: HSlider = $Volume/SFX
@onready var gamma_slider: HSlider = $Other/Gamma
@onready var cheats_button: TextureButton = $Other/Cheats

func _ready() -> void:
	trigger_if_default()
	
	set_process(false)
	battle_music_index = AudioServer.get_bus_index("Battle_Music")
	bg_music_index = AudioServer.get_bus_index("Background_Music")
	sfx_index = AudioServer.get_bus_index("SFX")
	
	background_slider.value = settings.bg_music_vol
	battle_slider.value = settings.bat_music_vol
	SFX_slider.value = settings.sfx_vol
	gamma_slider.value = settings.brightness

func _on_return_pressed() -> void:
	click_sound.play()
	release()
	MainMenu.summon()

func update_cheats_texture() -> void:
	if cheats_enabled:
		cheats_button.texture_normal = toggle_on_norm
		cheats_button.texture_hover = toggle_on_hov
	else:
		cheats_button.texture_normal = toggle_off_norm
		cheats_button.texture_hover = toggle_off_hov

func _on_bg_music_vol_changed(value: float) -> void:
	settings.bg_music_vol = value
	AudioServer.set_bus_volume_db(bg_music_index, linear_to_db(value))

func _on_battle_music_vol_changed(value: float) -> void:
	settings.bat_music_vol = value
	AudioServer.set_bus_volume_db(battle_music_index, linear_to_db(value))

func _on_sfx_vol_changed(value: float) -> void:
	settings.sfx_vol = value
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(value))

func _on_brightness_changed(value: float) -> void:
	settings.brightness = value
	get_owner().modulate = Color(value / 100.0, value / 100.0, value / 100.0, 1)
	print(value)

func _on_cheats_pressed() -> void:
	click_sound.play()
	cheats_enabled = !cheats_enabled
	update_cheats_texture()

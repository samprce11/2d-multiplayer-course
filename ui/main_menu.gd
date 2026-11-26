extends Control

var main_scene: PackedScene = preload("uid://btnxxhwfb26pw")

@onready var single_player_button: Button = $VBoxContainer/SinglePlayerButton
@onready var multiplayer_button: Button = $VBoxContainer/MultiplayerButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

@onready var multiplayer_menu_scene: PackedScene = load("uid://bp75k6wshig42")

func _ready() -> void:
	single_player_button.pressed.connect(_on_single_player_button_pressed)
	multiplayer_button.pressed.connect(_on_multiplayer_button)
	quit_button.pressed.connect(_on_quit_button)


func _on_single_player_button_pressed():
	get_tree().change_scene_to_packed(main_scene)

	
func _on_multiplayer_button():
	get_tree().change_scene_to_packed(multiplayer_menu_scene)
	
	
func _on_quit_button():
	get_tree().quit()

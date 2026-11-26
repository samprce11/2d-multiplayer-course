extends MarginContainer

@onready var display_name_text_edit: TextEdit = %DisplayNameTextEdit
@onready var port_text_edit: TextEdit = %PortTextEdit
@onready var host_button: Button = %HostButton
@onready var ip_address_text_edit: TextEdit = %IPAddressTextEdit
@onready var join_button: Button = %JoinButton
@onready var back_button: Button = %BackButton
@onready var main_menu_scene: PackedScene = load("uid://b16qrgnrdf21l")


var main_scene: PackedScene = preload("uid://btnxxhwfb26pw")


func _ready() -> void:
	host_button.pressed.connect(_on_host_pressed)
	join_button.pressed.connect(_on_join_pressed)
	back_button.pressed.connect(_on_back_pressed)
	
	display_name_text_edit.text_changed.connect(_on_text_changed)
	port_text_edit.text_changed.connect(_on_text_changed)
	ip_address_text_edit.text_changed.connect(_on_text_changed)
	
	display_name_text_edit.text = MultiplayerConfig.display_name
	port_text_edit.text = str(MultiplayerConfig.port)
	ip_address_text_edit.text = MultiplayerConfig.ip_address
	
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	validate()


func validate():
	var port := port_text_edit.text
	if port.is_valid_int():
		MultiplayerConfig.port = int(port)
		if MultiplayerConfig.port <= 0:
			MultiplayerConfig.port = -1
	else:
		MultiplayerConfig.port = -1
		
	var ip := ip_address_text_edit.text
	if ip.is_valid_ip_address():
		MultiplayerConfig.ip_address = ip
	else:
		MultiplayerConfig.ip_address = ""
	
	MultiplayerConfig.display_name = display_name_text_edit.text
	
	var is_valid_port := MultiplayerConfig.port > 0
	var is_valid_display_name := !MultiplayerConfig.display_name.is_empty()
	var is_valid_ip_address := !MultiplayerConfig.ip_address.is_empty()
	
	host_button.disabled = !is_valid_port || !is_valid_display_name
	join_button.disabled = !is_valid_port || !is_valid_display_name || !is_valid_ip_address
	

func _on_host_pressed() -> void:
	var server_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	server_peer.create_server(MultiplayerConfig.port)
	multiplayer.multiplayer_peer = server_peer
	get_tree().change_scene_to_packed(main_scene)
	
	
func _on_join_pressed() -> void:
	var client_peer: ENetMultiplayerPeer  = ENetMultiplayerPeer.new()
	client_peer.create_client(MultiplayerConfig.ip_address, MultiplayerConfig.port)
	multiplayer.multiplayer_peer = client_peer
	

func  _on_connected_to_server() -> void:
	get_tree().change_scene_to_packed(main_scene)


func _on_back_pressed():
	get_tree().change_scene_to_packed(main_menu_scene)


func _on_text_changed():
	validate()

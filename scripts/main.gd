extends Node

const MENU_SCENE := preload("res://scenes/menu.tscn")
const GAME_SCENE := preload("res://scenes/game.tscn")
const GAME_OVER_SCENE := preload("res://scenes/game_over.tscn")

var current_scene: Node


func _ready() -> void:
	_ensure_input_actions()
	show_menu()


func _ensure_input_actions() -> void:
	_register_key_action("p1_left", KEY_A)
	_register_key_action("p1_right", KEY_D)
	_register_key_action("p1_jump", KEY_W)
	_register_key_action("p1_shoot", KEY_S)

	_register_key_action("p2_left", KEY_LEFT)
	_register_key_action("p2_right", KEY_RIGHT)
	_register_key_action("p2_jump", KEY_UP)
	_register_key_action("p2_shoot", KEY_DOWN)

	_register_key_action("ui_cancel", KEY_ESCAPE)


func _register_key_action(action_name: String, keycode: Key) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)

	for event in InputMap.action_get_events(action_name):
		if event is InputEventKey and event.physical_keycode == keycode:
			return

	var key_event := InputEventKey.new()
	key_event.physical_keycode = keycode
	InputMap.action_add_event(action_name, key_event)


func _clear_current_scene() -> void:
	if is_instance_valid(current_scene):
		current_scene.queue_free()
	current_scene = null


func show_menu() -> void:
	_clear_current_scene()
	current_scene = MENU_SCENE.instantiate()
	add_child(current_scene)
	current_scene.start_requested.connect(start_game)
	current_scene.quit_requested.connect(_quit_game)


func start_game() -> void:
	_clear_current_scene()
	current_scene = GAME_SCENE.instantiate()
	add_child(current_scene)
	current_scene.game_over.connect(show_game_over)
	current_scene.return_to_menu.connect(show_menu)


func show_game_over(winner_color: String) -> void:
	_clear_current_scene()
	current_scene = GAME_OVER_SCENE.instantiate()
	add_child(current_scene)
	current_scene.set_winner(winner_color)
	current_scene.restart_requested.connect(start_game)
	current_scene.menu_requested.connect(show_menu)


func _quit_game() -> void:
	get_tree().quit()


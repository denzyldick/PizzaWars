extends Node2D

signal game_over(winner_color: String)
signal return_to_menu

const WORLD_SIZE := Vector2(600.0, 400.0)
const PLAYER_SCENE := preload("res://scenes/player.tscn")
const PROJECTILE_SCENE := preload("res://scenes/projectile.tscn")
const PLATFORM_SCENE := preload("res://scenes/platform.tscn")
const GAME_BG := preload("res://assets/images/gameBackground.png")
const HEART_TEXTURE := preload("res://assets/images/heart.png")

var _world_root: Node2D
var _hud_layer: CanvasLayer
var _background_layer: CanvasLayer
var _player_huds := {}
var _players := {}
var _game_finished := false


func _ready() -> void:
	_build_background()
	_build_world()
	_spawn_platforms()
	_spawn_players()
	_build_hud()
	_refresh_hud()


func _build_background() -> void:
	_background_layer = CanvasLayer.new()
	add_child(_background_layer)

	var background := TextureRect.new()
	background.texture = GAME_BG
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	background.stretch_mode = TextureRect.STRETCH_SCALE
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_background_layer.add_child(background)


func _build_world() -> void:
	_world_root = Node2D.new()
	add_child(_world_root)

	_hud_layer = CanvasLayer.new()
	add_child(_hud_layer)


func _spawn_platforms() -> void:
	var static_positions := [
		Vector2(1, 99),
		Vector2(100, 100),
		Vector2(211, 124),
		Vector2(373, 127),
		Vector2(559, 74),
		Vector2(312, 276),
	]

	for position in static_positions:
		_spawn_platform(position, false)

	for i in range(7):
		_spawn_platform(Vector2(i * 97.0, 360.0), false)

	_spawn_platform(Vector2(515, 224), true)
	_spawn_platform(Vector2(103, 337), true)


func _spawn_platform(position: Vector2, moving: bool) -> void:
	var platform := PLATFORM_SCENE.instantiate()
	platform.position = position
	platform.texture_path = "res://assets/images/platformDark.png" if moving else "res://assets/images/platform.png"
	platform.moving = moving
	platform.travel_distance = 40.0
	platform.speed = 60.0
	_world_root.add_child(platform)


func _spawn_players() -> void:
	_players.clear()
	_spawn_player("Red", "red", Vector2(100, 300), "p1_left", "p1_right", "p1_jump", "p1_shoot")
	_spawn_player("Green", "green", Vector2(460, 300), "p2_left", "p2_right", "p2_jump", "p2_shoot")


func _spawn_player(player_id: String, color_folder: String, position: Vector2, left_action: String, right_action: String, jump_action: String, shoot_action: String) -> void:
	var player := PLAYER_SCENE.instantiate()
	player.player_id = player_id
	player.color_folder = color_folder
	player.move_left_action = left_action
	player.move_right_action = right_action
	player.jump_action = jump_action
	player.shoot_action = shoot_action
	player.position = position
	player.shoot_requested.connect(_on_player_shoot_requested)
	player.lives_changed.connect(_on_player_lives_changed)
	player.died.connect(_on_player_died)
	_world_root.add_child(player)
	_players[player_id] = player


func _build_hud() -> void:
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_hud_layer.add_child(root)

	_player_huds["Red"] = _make_life_row(root, Vector2(10, 10), "Red")
	_player_huds["Green"] = _make_life_row(root, Vector2(380, 10), "Green")


func _make_life_row(parent: Control, position: Vector2, label_text: String) -> HBoxContainer:
	var box := HBoxContainer.new()
	box.position = position
	box.add_theme_constant_override("separation", 4)
	parent.add_child(box)

	var label := Label.new()
	label.text = label_text + ":"
	box.add_child(label)

	var hearts := HBoxContainer.new()
	hearts.add_theme_constant_override("separation", 2)
	box.add_child(hearts)

	for i in range(3):
		var heart := TextureRect.new()
		heart.texture = HEART_TEXTURE
		heart.custom_minimum_size = Vector2(20, 16)
		heart.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		heart.stretch_mode = TextureRect.STRETCH_SCALE
		hearts.add_child(heart)

	return hearts


func _refresh_hud() -> void:
	for player_id in _players.keys():
		var player = _players[player_id]
		var hearts: HBoxContainer = _player_huds[player_id]
		for i in range(hearts.get_child_count()):
			var heart = hearts.get_child(i)
			if heart is CanvasItem:
				heart.visible = i < player.lives


func _on_player_shoot_requested(player_id: String, muzzle_position: Vector2, facing: int) -> void:
	if _game_finished:
		return

	var projectile := PROJECTILE_SCENE.instantiate()
	projectile.position = muzzle_position
	projectile.direction = facing
	projectile.owner_id = player_id
	_world_root.add_child(projectile)


func _on_player_lives_changed(_player_id: String, _lives: int) -> void:
	_refresh_hud()


func _on_player_died(player_id: String) -> void:
	if _game_finished:
		return

	_refresh_hud()
	var winner_color := "Green" if player_id == "Red" else "Red"
	_game_finished = true
	game_over.emit(winner_color)

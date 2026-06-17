extends Node2D

signal game_over(winner_color: String)
signal return_to_menu

const PLAYER_SCENE := preload("res://scenes/player.tscn")
const PROJECTILE_SCENE := preload("res://scenes/projectile.tscn")
const PLATFORM_SCENE := preload("res://scenes/platform.tscn")
const GAME_BG := preload("res://assets/images/gameBackground.png")
const HEART_TEXTURE := preload("res://assets/images/heart.png")
const PIZZA_TEXTURE := preload("res://assets/images/pizzaslice-projectile.png")
const MUSIC := preload("res://assets/sounds/music.mp3")
const THROW_SOUND := preload("res://assets/sounds/throw.mp3")

var player_mode := "pvp"
var _world_root: Node2D
var _hud_layer: CanvasLayer
var _effects_layer: CanvasLayer
var _overlay_layer: CanvasLayer
var _player_huds := {}
var _players := {}
var _round_active := false
var _match_over := false
var _paused := false
var _music_player: AudioStreamPlayer
var _throw_player: AudioStreamPlayer
var _camera: Camera2D
var _shake_strength := 0.0

var _scores := {"Red": 0, "Green": 0}
var _current_round := 0
var _win_score := 3

var _countdown_label: Label
var _pause_overlay: ColorRect
var _round_result_label: Label


func _ready() -> void:
	_build_background()
	_build_world()
	_build_effects_layer()
	_build_overlay_layer()
	_spawn_platforms()
	_build_hud()
	call_deferred(&"_start_round")


func _build_background() -> void:
	var background := Sprite2D.new()
	background.texture = GAME_BG
	background.centered = false
	background.position = Vector2.ZERO
	add_child(background)


func _build_world() -> void:
	_world_root = Node2D.new()
	add_child(_world_root)

	_camera = Camera2D.new()
	_camera.position = Vector2(300.0, 200.0)
	_camera.limit_left = -20
	_camera.limit_top = -20
	_camera.limit_right = 620
	_camera.limit_bottom = 420
	add_child(_camera)

	_hud_layer = CanvasLayer.new()
	add_child(_hud_layer)

	_music_player = AudioStreamPlayer.new()
	_music_player.stream = MUSIC
	_music_player.autoplay = true
	_music_player.bus = &"Music"
	add_child(_music_player)

	_throw_player = AudioStreamPlayer.new()
	_throw_player.stream = THROW_SOUND
	_throw_player.bus = &"SFX"
	add_child(_throw_player)


func _build_effects_layer() -> void:
	_effects_layer = CanvasLayer.new()
	add_child(_effects_layer)


func _build_overlay_layer() -> void:
	_overlay_layer = CanvasLayer.new()
	add_child(_overlay_layer)

	_countdown_label = Label.new()
	_countdown_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_countdown_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_countdown_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_countdown_label.add_theme_font_size_override("font_size", 72)
	_countdown_label.add_theme_color_override("font_color", Color.WHITE)
	_countdown_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_countdown_label.add_theme_constant_override("outline_size", 4)
	_countdown_label.visible = false
	_overlay_layer.add_child(_countdown_label)

	_round_result_label = Label.new()
	_round_result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_round_result_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_round_result_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_round_result_label.add_theme_font_size_override("font_size", 36)
	_round_result_label.add_theme_color_override("font_color", Color.WHITE)
	_round_result_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_round_result_label.add_theme_constant_override("outline_size", 3)
	_round_result_label.visible = false
	_overlay_layer.add_child(_round_result_label)

	var pause_bg := ColorRect.new()
	pause_bg.color = Color(0.0, 0.0, 0.0, 0.6)
	pause_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	pause_bg.visible = false
	_overlay_layer.add_child(pause_bg)
	_pause_overlay = pause_bg

	var pause_label := Label.new()
	pause_label.text = "PAUSED\n\nPress ESC to resume"
	pause_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pause_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	pause_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	pause_label.add_theme_font_size_override("font_size", 48)
	pause_label.add_theme_color_override("font_color", Color.WHITE)
	pause_label.add_theme_color_override("font_outline_color", Color.BLACK)
	pause_label.add_theme_constant_override("outline_size", 3)
	pause_bg.add_child(pause_label)


func _spawn_platforms() -> void:
	var static_positions := [
		Vector2(55, 80),
		Vector2(180, 120),
		Vector2(320, 70),
		Vector2(440, 140),
		Vector2(30, 230),
		Vector2(190, 260),
		Vector2(370, 210),
		Vector2(520, 250),
		Vector2(310, 320),
	]

	for position in static_positions:
		_spawn_platform(position, false)

	for i in range(5):
		_spawn_platform(Vector2(50.0 + i * 120.0, 360.0), false)

	_spawn_platform(Vector2(150, 180), true)
	_spawn_platform(Vector2(430, 180), true)
	_spawn_platform(Vector2(300, 90), true)
	_spawn_platform(Vector2(530, 310), true)


func _spawn_platform(position: Vector2, moving: bool) -> void:
	var platform := PLATFORM_SCENE.instantiate()
	platform.position = position
	platform.texture_path = "res://assets/images/platformDark.png" if moving else "res://assets/images/platform.png"
	platform.moving = moving
	_world_root.add_child(platform)


func _start_round() -> void:
	_current_round += 1
	_round_active = false
	_match_over = false
	_clear_projectiles()

	for p in _players.values():
		p.queue_free()
	_players.clear()

	_spawn_fresh_players()
	_refresh_hud()
	_refresh_score_hud()

	_countdown_label.visible = true
	_countdown_label.add_theme_color_override("font_color", Color.WHITE)
	_round_result_label.visible = false

	var timer := Timer.new()
	timer.one_shot = true
	add_child(timer)

	var count = [3, 2, 1, 0]
	_countdown_step(count, timer)


func _countdown_step(count: Array, timer: Timer) -> void:
	if count.size() == 0:
		_countdown_label.visible = false
		_round_active = true
		for p in _players.values():
			p.frozen = false
		return

	var secs = count[0]
	if secs > 0:
		_countdown_label.text = str(secs)
	else:
		_countdown_label.text = "GO!"
		_countdown_label.add_theme_color_override("font_color", Color(1.0, 0.8, 0.0))

	count.remove_at(0)
	timer.start(0.8)
	await timer.timeout

	if secs == 0:
		_countdown_label.add_theme_color_override("font_color", Color.WHITE)

	_countdown_step(count, timer)


func _spawn_fresh_players() -> void:
	var p1 = _spawn_player("Red", "red", Vector2(100, 300), "p1_left", "p1_right", "p1_jump", "p1_shoot", false)
	var p2 = _spawn_player("Green", "green", Vector2(460, 300), "p2_left", "p2_right", "p2_jump", "p2_shoot", player_mode == "pve")
	for p in _players.values():
		p.frozen = true


func _spawn_player(player_id: String, color_folder: String, position: Vector2, left_action: String, right_action: String, jump_action: String, shoot_action: String, is_ai: bool) -> PlayerController:
	var player := PLAYER_SCENE.instantiate()
	player.player_id = player_id
	player.color_folder = color_folder
	player.move_left_action = left_action
	player.move_right_action = right_action
	player.jump_action = jump_action
	player.shoot_action = shoot_action
	player.is_ai = is_ai
	player.position = position
	player.shoot_requested.connect(_on_player_shoot_requested)
	player.lives_changed.connect(_on_player_lives_changed)
	player.died.connect(_on_player_died)
	_world_root.add_child(player)
	_players[player_id] = player
	return player


func _build_hud() -> void:
	_player_huds.clear()
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_hud_layer.add_child(root)

	_player_huds["Red"] = _make_life_row(root, Vector2(10, 10), "Red")
	_player_huds["Green"] = _make_life_row(root, Vector2(380, 10), "Green")

	var score_label := Label.new()
	score_label.name = "ScoreLabel"
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_label.position = Vector2(250, 10)
	score_label.custom_minimum_size = Vector2(100, 20)
	score_label.add_theme_font_size_override("font_size", 18)
	score_label.add_theme_color_override("font_color", Color.WHITE)
	score_label.add_theme_color_override("font_outline_color", Color.BLACK)
	score_label.add_theme_constant_override("outline_size", 2)
	root.add_child(score_label)


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
		if not (_player_huds.has(player_id)):
			continue
		var hearts: HBoxContainer = _player_huds[player_id]
		for i in range(hearts.get_child_count()):
			var heart = hearts.get_child(i)
			if heart is CanvasItem:
				heart.visible = i < player.lives


func _refresh_score_hud() -> void:
	var root = _hud_layer.get_child(0) if _hud_layer.get_child_count() > 0 else null
	if not root:
		return
	var label = root.get_node_or_null("ScoreLabel")
	if label:
		label.text = "R%d  %d - %d" % [_current_round, _scores["Red"], _scores["Green"]]


func _clear_projectiles() -> void:
	for c in _world_root.get_children():
		if c is PizzaProjectile:
			c.queue_free()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and _round_active and not _match_over:
		_toggle_pause()

	if _shake_strength > 0.0:
		_camera.offset = Vector2(
			randf_range(-_shake_strength, _shake_strength),
			randf_range(-_shake_strength, _shake_strength)
		)
		_shake_strength = maxf(0.0, _shake_strength - 4.0)
		if _shake_strength <= 0.0:
			_camera.offset = Vector2.ZERO


func _toggle_pause() -> void:
	_paused = not _paused
	get_tree().paused = _paused
	_pause_overlay.visible = _paused


func _on_player_shoot_requested(player_id: String, muzzle_position: Vector2, facing: int) -> void:
	if not _round_active or _match_over:
		return

	_throw_player.play()

	var projectile := PROJECTILE_SCENE.instantiate()
	projectile.position = muzzle_position
	projectile.direction = facing
	projectile.owner_id = player_id
	_world_root.add_child(projectile)


func _on_player_lives_changed(_player_id: String, _lives: int) -> void:
	_refresh_hud()


func _on_player_died(player_id: String) -> void:
	if _match_over or not _round_active:
		return

	_round_active = false
	_clear_projectiles()
	var winner := "Green" if player_id == "Red" else "Red"
	_scores[winner] += 1
	_refresh_score_hud()

	_spawn_hit_effect(_players[player_id].global_position if _players.has(player_id) else Vector2(300, 200))

	_shake_strength = 12.0

	if _scores[winner] >= _win_score:
		_match_over = true
		_show_match_result(winner)
	else:
		_show_round_result(winner)


func _show_round_result(winner: String) -> void:
	_round_result_label.text = "%s wins Round %d!\n%d - %d" % [winner, _current_round, _scores["Red"], _scores["Green"]]
	_round_result_label.visible = true

	var timer := Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start(2.0)
	await timer.timeout

	if not _match_over:
		_start_round()


func _show_match_result(winner: String) -> void:
	_round_result_label.text = "%s WINS THE MATCH!\nFinal Score: %d - %d" % [winner, _scores["Red"], _scores["Green"]]
	_round_result_label.visible = true

	var timer := Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start(3.0)
	await timer.timeout

	game_over.emit(winner)


func _spawn_hit_effect(position: Vector2) -> void:
	for i in range(6):
		var splat := Sprite2D.new()
		splat.texture = PIZZA_TEXTURE
		splat.scale = Vector2(0.5, 0.5)
		splat.position = position
		splat.rotation = randf_range(0.0, 6.28)
		splat.modulate = Color(1.0, 1.0, 1.0, 1.0)
		_effects_layer.add_child(splat)

		var vel := Vector2(randf_range(-150.0, 150.0), randf_range(-200.0, -50.0))
		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property(splat, "position", position + vel * Vector2(0.6, 0.3) * randf_range(0.5, 1.5), 0.5)
		tween.tween_property(splat, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
		tween.tween_property(splat, "scale", Vector2(0.2, 0.2), 0.5)
		tween.chain().tween_callback(splat.queue_free)

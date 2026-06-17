class_name PlayerController
extends CharacterBody2D

signal shoot_requested(player_id: String, muzzle_position: Vector2, facing: int)
signal lives_changed(player_id: String, lives: int)
signal died(player_id: String)

const WORLD_WIDTH := 600.0
const GRAVITY := 1200.0
const MOVE_SPEED := 170.0
const JUMP_VELOCITY := -600.0
const JUMP_SOUND := preload("res://assets/sounds/jump.mp3")
const HIT_SOUND := preload("res://assets/sounds/hit.mp3")

@export var player_id := "Red"
@export var color_folder := "red"
@export var move_left_action := "p1_left"
@export var move_right_action := "p1_right"
@export var jump_action := "p1_jump"
@export var shoot_action := "p1_shoot"
@export var is_ai := false

var lives := 3
var facing := 1
var frozen := false

var _anim_timer := 0.0
var _walk_frame := 0
var _idle_frame := 0
var _sprite: Sprite2D
var _collision_shape: CollisionShape2D
var _muzzle: Marker2D
var _jump_player: AudioStreamPlayer
var _hit_player: AudioStreamPlayer
var _textures: Dictionary = {}

var _ai_target: Node = null
var _ai_shoot_cooldown := 0.0
var _ai_jump_cooldown := 0.0
var _ai_direction := 0.0

func _ready() -> void:
	add_to_group("players")
	collision_layer = 1
	collision_mask = 3
	_build_nodes()
	_set_texture(_texture_path("idle", 0))
	_sprite.flip_h = false


func _build_nodes() -> void:
	_sprite = Sprite2D.new()
	_sprite.centered = true
	add_child(_sprite)

	_collision_shape = CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(38, 60)
	_collision_shape.shape = shape
	_collision_shape.position = Vector2(0, 20)
	add_child(_collision_shape)

	_muzzle = Marker2D.new()
	_muzzle.position = Vector2(18, -4)
	add_child(_muzzle)

	_jump_player = AudioStreamPlayer.new()
	_jump_player.stream = JUMP_SOUND
	_jump_player.bus = &"SFX"
	add_child(_jump_player)

	_hit_player = AudioStreamPlayer.new()
	_hit_player.stream = HIT_SOUND
	_hit_player.bus = &"SFX"
	add_child(_hit_player)


func _physics_process(delta: float) -> void:
	if frozen:
		velocity.x = move_toward(velocity.x, 0.0, MOVE_SPEED * delta * 4.0)
		velocity.y += GRAVITY * delta
		move_and_slide()
		return

	if is_ai:
		_ai_process(delta)
	else:
		_player_process(delta)

	move_and_slide()
	_wrap_screen()
	_update_animation(delta, _ai_direction if is_ai else Input.get_axis(move_left_action, move_right_action))


func _player_process(delta: float) -> void:
	var direction := Input.get_axis(move_left_action, move_right_action)
	if direction != 0.0:
		velocity.x = direction * MOVE_SPEED
		facing = 1 if direction > 0.0 else -1
	else:
		velocity.x = move_toward(velocity.x, 0.0, MOVE_SPEED * delta * 4.0)

	if not is_on_floor():
		velocity.y += GRAVITY * delta
	elif velocity.y > 0.0:
		velocity.y = 0.0

	if is_on_floor() and Input.is_action_just_pressed(jump_action):
		velocity.y = JUMP_VELOCITY
		_jump_player.play()

	if Input.is_action_just_pressed(shoot_action):
		shoot_requested.emit(player_id, _muzzle.global_position, facing)


func _ai_process(delta: float) -> void:
	_ai_shoot_cooldown -= delta
	_ai_jump_cooldown -= delta

	var target = _find_target()
	if not target:
		_ai_direction = 0.0
		velocity.x = move_toward(velocity.x, 0.0, MOVE_SPEED * delta * 4.0)
		if not is_on_floor():
			velocity.y += GRAVITY * delta
		elif velocity.y > 0.0:
			velocity.y = 0.0
		return

	var dx = target.global_position.x - global_position.x
	var dy = target.global_position.y - global_position.y
	_ai_direction = 1.0 if dx > 0 else -1.0
	facing = 1 if _ai_direction > 0 else -1

	velocity.x = _ai_direction * MOVE_SPEED

	if not is_on_floor():
		velocity.y += GRAVITY * delta
	elif velocity.y > 0.0:
		velocity.y = 0.0

	var edge_ahead := not _has_floor_ahead(_ai_direction)
	var enemy_below: bool = dy > 50.0
	if is_on_floor() and (edge_ahead or enemy_below) and _ai_jump_cooldown <= 0.0:
		velocity.y = JUMP_VELOCITY
		_jump_player.play()
		_ai_jump_cooldown = 1.5

	if absf(dx) < 400.0 and _ai_shoot_cooldown <= 0.0 and (sign(dx) == facing):
		shoot_requested.emit(player_id, _muzzle.global_position, facing)
		_ai_shoot_cooldown = 1.2 + randf() * 0.8


func _find_target() -> Node:
	if _ai_target and is_instance_valid(_ai_target) and _ai_target.has_method("take_hit"):
		return _ai_target
	for p in get_tree().get_nodes_in_group("players"):
		if p != self and p.has_method("take_hit"):
			_ai_target = p
			return _ai_target
	return null


func _has_floor_ahead(dir: float) -> bool:
	var space = get_world_2d().direct_space_state
	var from = global_position + Vector2(dir * 30.0, 5.0)
	var to = from + Vector2(0.0, 30.0)
	var query = PhysicsRayQueryParameters2D.create(from, to, 1)
	var result = space.intersect_ray(query)
	return not result.is_empty()


func _wrap_screen() -> void:
	if global_position.x < -32.0:
		global_position.x = WORLD_WIDTH + 32.0
	elif global_position.x > WORLD_WIDTH + 32.0:
		global_position.x = -32.0


func take_hit(amount: int = 1) -> void:
	if lives <= 0:
		return

	lives = maxi(0, lives - amount)
	lives_changed.emit(player_id, lives)
	_hit_player.play()

	if lives == 0:
		died.emit(player_id)


func _update_animation(delta: float, direction: float) -> void:
	_anim_timer += delta
	_sprite.flip_h = facing < 0

	if not is_on_floor():
		_set_texture(_texture_path("jumping"))
		return

	if absf(direction) > 0.01:
		if _anim_timer > 0.09:
			_anim_timer = 0.0
			_walk_frame = (_walk_frame + 1) % 6
		_set_texture(_texture_path("walking", _walk_frame))
	else:
		if _anim_timer > 0.35:
			_anim_timer = 0.0
			_idle_frame = (_idle_frame + 1) % 2
		_set_texture(_texture_path("idle", _idle_frame))


func _texture_path(kind: String, frame: int = 0) -> String:
	match kind:
		"idle":
			return "res://assets/images/%s/playerIdle%dR.png" % [color_folder, frame]
		"walking":
			return "res://assets/images/%s/playerWalking%dR.png" % [color_folder, frame]
		"jumping":
			return "res://assets/images/%s/playerJumpingR.png" % color_folder
		_:
			return "res://assets/images/%s/playerIdle0R.png" % color_folder


func _set_texture(path: String) -> void:
	if path in _textures:
		_sprite.texture = _textures[path]
		_sprite.scale = Vector2(2.0, 2.0)
		_sprite.position = Vector2.ZERO
		return

	var texture := load(path)
	if texture is Texture2D:
		_textures[path] = texture
		_sprite.texture = texture
		_sprite.scale = Vector2(2.0, 2.0)
		_sprite.position = Vector2.ZERO
		return

	var img := Image.new()
	var file_path := ProjectSettings.globalize_path(path)
	if img.load(file_path) == OK:
		var tex := ImageTexture.create_from_image(img)
		_textures[path] = tex
		_sprite.texture = tex
		_sprite.scale = Vector2(2.0, 2.0)
		_sprite.position = Vector2.ZERO

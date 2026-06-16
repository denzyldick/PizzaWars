class_name PlayerController
extends CharacterBody2D

signal shoot_requested(player_id: String, muzzle_position: Vector2, facing: int)
signal lives_changed(player_id: String, lives: int)
signal died(player_id: String)

const GRAVITY := 1200.0
const MOVE_SPEED := 170.0
const JUMP_VELOCITY := -420.0

@export var player_id := "Red"
@export var color_folder := "red"
@export var move_left_action := "p1_left"
@export var move_right_action := "p1_right"
@export var jump_action := "p1_jump"
@export var shoot_action := "p1_shoot"

var lives := 3
var facing := 1
var _anim_timer := 0.0
var _walk_frame := 0
var _idle_frame := 0
var _sprite: Sprite2D
var _collision_shape: CollisionShape2D
var _muzzle: Marker2D


func _ready() -> void:
	add_to_group("players")
	_build_nodes()
	_set_texture(_texture_path("idle", 0))
	_sprite.flip_h = false


func _build_nodes() -> void:
	_sprite = Sprite2D.new()
	_sprite.centered = true
	add_child(_sprite)

	_collision_shape = CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(28, 36)
	_collision_shape.shape = shape
	_collision_shape.position = Vector2.ZERO
	add_child(_collision_shape)

	_muzzle = Marker2D.new()
	_muzzle.position = Vector2(18, -4)
	add_child(_muzzle)


func _physics_process(delta: float) -> void:
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

	if Input.is_action_just_pressed(shoot_action):
		shoot_requested.emit(player_id, _muzzle.global_position, facing)

	move_and_slide()
	_update_animation(delta, direction)


func take_hit(amount: int = 1) -> void:
	if lives <= 0:
		return

	lives = maxi(0, lives - amount)
	lives_changed.emit(player_id, lives)

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
	var texture := load(path)
	if texture is Texture2D:
		_sprite.texture = texture
		_sprite.scale = Vector2(2.0, 2.0)
		_sprite.position = Vector2.ZERO

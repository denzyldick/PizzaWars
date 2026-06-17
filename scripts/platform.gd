class_name PizzaPlatform
extends CharacterBody2D

@export var texture_path := "res://assets/images/platform.png"
@export var moving := false
@export var speed := 100.0
@export var travel_distance := 64.0

var _start_position := Vector2.ZERO
var _sprite: Sprite2D
var _direction := 1.0


func _ready() -> void:
	_start_position = position
	_build_nodes()


func _build_nodes() -> void:
	_sprite = Sprite2D.new()
	_sprite.texture = load(texture_path)
	add_child(_sprite)

	var collision_shape := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(100, 40)
	collision_shape.shape = shape
	add_child(collision_shape)


func _physics_process(delta: float) -> void:
	if not moving:
		return

	var motion = Vector2(0.0, _direction * speed * delta)
	var collision = move_and_collide(motion)

	if collision:
		var body = collision.get_collider()
		if body is PlayerController and body.has_method(&"move_and_collide"):
			body.move_and_collide(collision.get_remainder())

	if absf(position.y - _start_position.y) >= travel_distance:
		_direction *= -1.0

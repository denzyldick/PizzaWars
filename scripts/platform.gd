class_name PizzaPlatform
extends AnimatableBody2D

@export var texture_path := "res://assets/images/platform.png"
@export var moving := false
@export var speed := 60.0
@export var travel_distance := 40.0
@export var direction := 1.0

var _start_position := Vector2.ZERO
var _sprite: Sprite2D


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

	position.y += direction * speed * delta
	if absf(position.y - _start_position.y) >= travel_distance:
		direction *= -1.0


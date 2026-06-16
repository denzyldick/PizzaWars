class_name PizzaProjectile
extends Area2D

const SPEED := 260.0
const LIFETIME := 3.0
const PROJECTILE_TEXTURE := preload("res://assets/images/pizzaslice-projectile.png")

@export var direction := 1
@export var owner_id := ""

var _elapsed := 0.0
var _sprite: Sprite2D


func _ready() -> void:
	_build_nodes()
	body_entered.connect(_on_body_entered)


func _build_nodes() -> void:
	_sprite = Sprite2D.new()
	_sprite.texture = PROJECTILE_TEXTURE
	_sprite.scale = Vector2(1.2, 1.2)
	add_child(_sprite)

	var collision_shape := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(26, 18)
	collision_shape.shape = shape
	add_child(collision_shape)


func _physics_process(delta: float) -> void:
	position.x += SPEED * direction * delta
	rotation += 3.0 * delta
	_elapsed += delta

	if _elapsed >= LIFETIME or position.x < -50.0 or position.x > 650.0:
		queue_free()


func _on_body_entered(body: Node) -> void:
	if body is PlayerController:
		var player := body as PlayerController
		if player.player_id == owner_id:
			return
		player.take_hit(1)
	queue_free()


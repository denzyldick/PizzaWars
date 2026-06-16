extends Control

signal restart_requested
signal menu_requested

const RED_WINS := preload("res://assets/images/redwins.png")
const GREEN_WINS := preload("res://assets/images/greenwins.png")

var _winner_color := "Red"
var _message_label: Label


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_ui()
	_refresh()


func set_winner(color: String) -> void:
	_winner_color = color
	if is_inside_tree():
		_refresh()


func _build_ui() -> void:
	var background := TextureRect.new()
	background.name = "Background"
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	background.stretch_mode = TextureRect.STRETCH_SCALE
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var column := VBoxContainer.new()
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 12)
	center.add_child(column)

	_message_label = Label.new()
	_message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_message_label.text = "Winner"
	column.add_child(_message_label)

	var restart := Button.new()
	restart.text = "Play Again"
	restart.custom_minimum_size = Vector2(220, 44)
	restart.pressed.connect(func() -> void: restart_requested.emit())
	column.add_child(restart)

	var menu := Button.new()
	menu.text = "Main Menu"
	menu.custom_minimum_size = Vector2(220, 44)
	menu.pressed.connect(func() -> void: menu_requested.emit())
	column.add_child(menu)


func _refresh() -> void:
	var background := get_node_or_null("Background") as TextureRect
	if background:
		background.texture = GREEN_WINS if _winner_color == "Green" else RED_WINS

	if _message_label:
		_message_label.text = _winner_color + " wins!"


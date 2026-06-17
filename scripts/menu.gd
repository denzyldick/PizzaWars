extends Control

signal start_requested(mode: String)
signal quit_requested

const MENU_BG := preload("res://assets/images/MenuBackground.png")
const LOGO := preload("res://assets/images/logo.png")
const INSTRUCTIONS_BUTTON := preload("res://assets/images/InstructionsButton.png")
const INSTRUCTION_SCREEN := preload("res://assets/images/instructionscreen.png")

var _instructions_panel: TextureRect


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_ui()


func _build_ui() -> void:
	var background := TextureRect.new()
	background.texture = MENU_BG
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	background.stretch_mode = TextureRect.STRETCH_SCALE
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var logo := TextureRect.new()
	logo.texture = LOGO
	logo.position = Vector2(170, 25)
	add_child(logo)

	var button_column := VBoxContainer.new()
	button_column.position = Vector2(160, 200)
	button_column.custom_minimum_size = Vector2(280, 200)
	button_column.add_theme_constant_override("separation", 10)
	add_child(button_column)

	var p1_button := Button.new()
	p1_button.text = "1 Player (vs AI)"
	p1_button.custom_minimum_size = Vector2(277, 40)
	p1_button.pressed.connect(func(): start_requested.emit("pve"))
	button_column.add_child(p1_button)

	var p2_button := Button.new()
	p2_button.text = "2 Players"
	p2_button.custom_minimum_size = Vector2(277, 40)
	p2_button.pressed.connect(func(): start_requested.emit("pvp"))
	button_column.add_child(p2_button)

	var instructions_button := TextureButton.new()
	instructions_button.texture_normal = INSTRUCTIONS_BUTTON
	instructions_button.stretch_mode = TextureButton.STRETCH_SCALE
	instructions_button.custom_minimum_size = Vector2(277, 89)
	instructions_button.pressed.connect(_toggle_instructions)
	button_column.add_child(instructions_button)

	var quit_button := Button.new()
	quit_button.text = "Quit"
	quit_button.custom_minimum_size = Vector2(277, 40)
	quit_button.pressed.connect(_on_quit_pressed)
	button_column.add_child(quit_button)

	_instructions_panel = TextureRect.new()
	_instructions_panel.texture = INSTRUCTION_SCREEN
	_instructions_panel.visible = false
	_instructions_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	_instructions_panel.stretch_mode = TextureRect.STRETCH_SCALE
	_instructions_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_instructions_panel)


func _on_quit_pressed() -> void:
	quit_requested.emit()


func _toggle_instructions() -> void:
	_instructions_panel.visible = not _instructions_panel.visible

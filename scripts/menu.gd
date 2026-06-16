extends Control

signal start_requested
signal quit_requested

const MENU_BG := preload("res://assets/images/MenuBackground.png")
const LOGO := preload("res://assets/images/logo.png")
const START_BUTTON := preload("res://assets/images/startButton.png")
const INSTRUCTIONS_BUTTON := preload("res://assets/images/InstructionsButton.png")

var _instructions_panel: PanelContainer


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
	button_column.position = Vector2(160, 210)
	button_column.custom_minimum_size = Vector2(280, 180)
	button_column.add_theme_constant_override("separation", 10)
	add_child(button_column)

	var start_button := TextureButton.new()
	start_button.texture_normal = START_BUTTON
	start_button.stretch_mode = TextureButton.STRETCH_SCALE
	start_button.custom_minimum_size = Vector2(277, 89)
	start_button.pressed.connect(_on_start_pressed)
	button_column.add_child(start_button)

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

	_instructions_panel = PanelContainer.new()
	_instructions_panel.visible = false
	_instructions_panel.position = Vector2(20, 20)
	_instructions_panel.custom_minimum_size = Vector2(560, 120)
	add_child(_instructions_panel)

	var instructions_margin := MarginContainer.new()
	instructions_margin.add_theme_constant_override("margin_left", 20)
	instructions_margin.add_theme_constant_override("margin_top", 18)
	instructions_margin.add_theme_constant_override("margin_right", 20)
	instructions_margin.add_theme_constant_override("margin_bottom", 18)
	_instructions_panel.add_child(instructions_margin)

	var instructions_label := Label.new()
	instructions_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	instructions_label.text = "Red: W/A/S/D. Green: Arrow keys. Jump, move, and throw pizza slices to knock out the other player."
	instructions_label.custom_minimum_size = Vector2(520, 80)
	instructions_margin.add_child(instructions_label)


func _on_start_pressed() -> void:
	start_requested.emit()


func _on_quit_pressed() -> void:
	quit_requested.emit()


func _toggle_instructions() -> void:
	_instructions_panel.visible = not _instructions_panel.visible

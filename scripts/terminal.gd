extends Node2D

@onready var label := %PlayerInput
var underscore_visible := true


func _ready() -> void:
	label.text = ""
	label.grab_focus()


func _on_player_input_text_submitted(new_text: String) -> void:
	label.text = ""
	%Text.text += "[color=green]> " + new_text + "[/color]" + "\n"


func _on_computer_in_computer() -> void:
	label.text = ""
	label.grab_focus()

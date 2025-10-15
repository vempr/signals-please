extends CanvasLayer

signal in_computer


func _ready() -> void:
	%Terminal.visible = false
	visible = false


func _on_hover_trigger_computer() -> void:
	visible = true
	%Zoom.play("in")


func _on_zoom_animation_finished(anim_name: StringName) -> void:
	if anim_name == "out":
		visible = false
	else:
		%Terminal.visible = true
		in_computer.emit()


func _on_game_exit_computer() -> void:
	%Terminal.visible = false
	%Zoom.play("out")

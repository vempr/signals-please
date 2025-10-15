extends CanvasLayer

signal in_computer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Terminal.visible = false
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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

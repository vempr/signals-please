extends Panel


func _ready() -> void:
	visible = false


func _process(_delta: float) -> void:
	align()


func _on_hover_display_message(message: String) -> void:
	align()
	%Message.text = message
	visible = true


func _on_hover_hide_message() -> void:
	visible = false


func align() -> void:
	position = get_global_mouse_position()
	position.y -= 100.0
	position.x -= size.x / 2.0

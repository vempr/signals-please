extends Node2D

@onready var TransitionScene := preload("res://scenes/transition_scene.tscn")
@onready var bg_container := %BGContainer
@onready var viewport_height := get_viewport_rect().size.y
@onready var offset_y = bg_container.size.y / 1.03 # looks nicer on bottom


func _process(delta: float) -> void:
	var mouse_y = get_global_mouse_position().y
	var clamped_center_y = clamp(mouse_y, offset_y, viewport_height - offset_y)
	bg_container.position.y = lerp(bg_container.position.y, clamped_center_y - offset_y, 10 * delta)


func _on_play_button_pressed() -> void:
	await Fade.fade_out(2.0).finished
	get_tree().change_scene_to_packed(TransitionScene)

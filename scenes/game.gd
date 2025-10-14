extends Node2D


func _ready() -> void:
	GAME_STATE.day_finished = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hover_progress() -> void:
	GAME_STATE.day += 1
	await Fade.fade_out().finished
	get_tree().change_scene_to_file("res://scenes/transition_scene.tscn")

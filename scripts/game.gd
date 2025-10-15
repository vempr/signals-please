extends Node2D

signal exit_computer

var can_exit_computer := false


func _ready() -> void:
	GAME_STATE.day_finished = false


func _process(_delta: float) -> void:
	if can_exit_computer && Input.is_action_just_pressed("unfocus"):
		can_exit_computer = false
		exit_computer.emit()


func _on_hover_progress() -> void:
	GAME_STATE.day += 1
	await Fade.fade_out().finished
	get_tree().change_scene_to_file("res://scenes/transition_scene.tscn")


func _on_computer_in_computer() -> void:
	can_exit_computer = true

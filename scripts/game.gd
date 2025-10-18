extends Node2D

signal exit_computer

var can_exit_computer := false


func _ready() -> void:
	GAME_STATE.day_finished = false


func _process(_delta: float) -> void:
	if can_exit_computer && Input.is_action_pressed("unfocus"):
		can_exit_computer = false
		exit_computer.emit()


func _on_hover_progress() -> void:
	await Fade.fade_out().finished
	GAME_STATE.day += 1
	
	if GAME_STATE.day <= GAME_STATE.FINAL_DAY:
		GAME_STATE.add_hunger()
	else:
		if GAME_STATE.lost_to == GAME_STATE.DEATH_REASON.ISOLATION:
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")
			Fade.fade_in(1.5)
			return
		else:
			get_tree().change_scene_to_file("res://scenes/game_win.tscn")
			Fade.fade_in(1.5)
			return
	
	if GAME_STATE.player.hunger > 100:
		GAME_STATE.lost_to = GAME_STATE.DEATH_REASON.HUNGER
	elif GAME_STATE.player.reputation < 10:
		GAME_STATE.lost_to = GAME_STATE.DEATH_REASON.REPUTATION
	
	print("lost to:")
	print(GAME_STATE.lost_to)
	
	get_tree().change_scene_to_file("res://scenes/transition_scene.tscn")


func _on_computer_in_computer() -> void:
	can_exit_computer = true

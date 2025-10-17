extends Node2D

var text_to_type := "Day " + str(GAME_STATE.day)
var i := 0
var show_cursor := true
var text_completed := false


func _ready() -> void:
	await Fade.fade_in(0.6).finished
	await get_tree().create_timer(0.3).timeout
	
	while i < text_to_type.length() && !text_completed:
		%Type.play()
		i += 1
		await get_tree().create_timer(randf() * 0.5).timeout


func _process(_delta: float) -> void:
	var text = ""
	
	if !text_completed:
		if i < text_to_type.length():
			text = text_to_type.substr(0, i)
		else:
			text = text_to_type
			text_completed = true
			delete_text()
	else:
		text = text_to_type.substr(0, i)

	
	if show_cursor:
		text += "_"
	%Message.text = text


func _on_cursor_blink_timer_timeout() -> void:
	show_cursor = !show_cursor


func delete_text() -> void:
	await get_tree().create_timer(1.5).timeout
	
	while i > 0:
		%Type.play()
		i -= 1
		await get_tree().create_timer(randf() * 0.5).timeout
		
	await get_tree().create_timer(0.5).timeout
	await Fade.fade_out(0.7).finished
	
	if GAME_STATE.lost_to != null:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	Fade.fade_in(1.5)

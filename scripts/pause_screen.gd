extends CanvasLayer

signal back_in_game


func _ready() -> void:
	%Control.modulate.a = 0.0
	visible = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		var tween = create_tween()
		
		if visible:
			back_in_game.emit()
			get_tree().paused = false
			tween.tween_property(%Control, "modulate:a", 0.0, 0.1)
			await tween.finished
			visible = false
		else:
			visible = true
			tween.tween_property(%Control, "modulate:a", 1.0, 0.1)
			await tween.finished
			get_tree().paused = true
		


func _on_continue_button_pressed() -> void:
	back_in_game.emit()
	get_tree().paused = false
	
	var tween = create_tween()
	tween.tween_property(%Control, "modulate:a", 0.0, 0.1)
	await tween.finished
	
	visible = false


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	await Fade.fade_out().finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	Fade.fade_in(0.3)


func _on_enable_instant_messages_button_button_down() -> void:
	%DisableInstantMessagesButton.disabled = false
	%EnableInstantMessagesButton.disabled = true
	GAME_STATE.INSTANT_MESSAGES = true


func _on_disable_instant_messages_button_button_down() -> void:
	%EnableInstantMessagesButton.disabled = false
	%DisableInstantMessagesButton.disabled = true
	GAME_STATE.INSTANT_MESSAGES = false

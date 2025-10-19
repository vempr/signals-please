extends Node2D

const sig_text := "> SIG: Good morning, commander. Ready for another day?"
@onready var timer := %Timer
@onready var label := %SIGLabel
@onready var bg_container := %BGContainer
@onready var viewport_height := get_viewport_rect().size.y
@onready var offset_y = bg_container.size.y / 1.03 # looks nicer on bottom


func _ready() -> void:
	%Message.modulate.a = 0.0
	%Message.visible = true
	%FinalState.modulate.a = 0.0
	%FinalState.visible = true
	%Title.modulate.a = 0.0
	%Title.visible = true
	
	var ending_text := "< ENDING: PLAYER WON ON DAY " + str(GAME_STATE.day)
	ending_text += " WITH " + str(GAME_STATE.player.hunger) + "% HUNGER"
	ending_text += " AND " + str(GAME_STATE.player.reputation) + "% REPUTATION."
	ending_text += " THERE WERE " + str(GAME_STATE.ration_remaining) + " DAYS OF RATION"
	ending_text += " AND " + str(GAME_STATE.people_remaining) + " PEOPLE REMAINING. >"
	%FinalState.text = ending_text
	
	label.text = ""
	for letter in sig_text:
		%Sig.stop()
		%Sig.play()
		label.text += letter
		
		if letter == ".":
			timer.start(1.0)
		elif [",", "-", ";", "?"].find(letter) > -1:
			timer.start(0.4)
		else:
			timer.start(0.1)
		await timer.timeout
	
	timer.start(1.0)
	await timer.timeout
	
	var tween = create_tween()
	tween.tween_property(%Message, "modulate:a", 1.0, 5.0)
	await tween.finished

	var button_tween = create_tween()
	%Buttons.modulate.a = 0.0
	%Buttons.visible = true
	button_tween.parallel().tween_property(%Buttons, "modulate:a", 1.0, 2.0)
	button_tween.parallel().tween_property(%FinalState, "modulate:a", 1.0, 2.0)
	button_tween.parallel().tween_property(%Title, "modulate:a", 1.0, 2.0)
	
	GAME_STATE.reset()


func _process(delta: float) -> void:
	var mouse_y = get_global_mouse_position().y
	var clamped_center_y = clamp(mouse_y, offset_y, viewport_height - offset_y)
	bg_container.position.y = lerp(bg_container.position.y, clamped_center_y - offset_y, 10 * delta)


func _on_replay_button_pressed() -> void:
	%InvalidInput.play()
	await Fade.fade_out().finished
	get_tree().change_scene_to_file("res://scenes/transition_scene.tscn")


func _on_main_menu_button_pressed() -> void:
	GAME_STATE.stop_music()
	%ValidInput.play()
	await Fade.fade_out().finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	Fade.fade_in(0.3)

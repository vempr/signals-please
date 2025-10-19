extends Node2D

const sig_text := "> SIG: Commander. What is your current situation? Please respond..."
@onready var timer := %Timer
@onready var label := %SIGLabel
@onready var bg_container := %BGContainer
@onready var viewport_height := get_viewport_rect().size.y
@onready var offset_y = bg_container.size.y / 1.03 # looks nicer on bottom
var DEBUG := false


func _ready() -> void:
	DEBUG = false
	if DEBUG:
		GAME_STATE.lost_to = GAME_STATE.DEATH_REASON.JUMPED
	
	label.text = ""
	for letter in sig_text:
		label.text += letter
		
		if letter == ".":
			timer.start(1.0)
		elif [",", "-", ";"].find(letter) > -1:
			timer.start(0.2)
		else:
			timer.start(0.1)
		await timer.timeout
	
	timer.start(1.0)
	await timer.timeout
	
	var tween = create_tween()
	
	match GAME_STATE.lost_to:
		GAME_STATE.DEATH_REASON.HUNGER:
			%HungerEnding.modulate.a = 0.0
			%HungerEnding.visible = true
			tween.tween_property(%HungerEnding, "modulate:a", 1.0, 5.0)
		GAME_STATE.DEATH_REASON.REPUTATION:
			%ReputationEnding.modulate.a = 0.0
			%ReputationEnding.visible = true
			tween.tween_property(%ReputationEnding, "modulate:a", 1.0, 5.0)
		GAME_STATE.DEATH_REASON.ISOLATION:
			%IsolationEnding.modulate.a = 0.0
			%IsolationEnding.visible = true
			tween.tween_property(%IsolationEnding, "modulate:a", 1.0, 5.0)
		GAME_STATE.DEATH_REASON.JUMPED:
			%JumpedEnding.modulate.a = 0.0
			%JumpedEnding.visible = true
			tween.tween_property(%JumpedEnding, "modulate:a", 1.0, 5.0)
	
	await tween.finished

	var button_tween = create_tween()
	%Buttons.modulate.a = 0.0
	%Buttons.visible = true
	button_tween.tween_property(%Buttons, "modulate:a", 1.0, 2.0)
	
	GAME_STATE.reset()


func _process(delta: float) -> void:
	var mouse_y = get_global_mouse_position().y
	var clamped_center_y = clamp(mouse_y, offset_y, viewport_height - offset_y)
	bg_container.position.y = lerp(bg_container.position.y, clamped_center_y - offset_y, 10 * delta)


func _on_replay_button_pressed() -> void:
	%ValidInput.play()
	await Fade.fade_out().finished
	get_tree().change_scene_to_file("res://scenes/transition_scene.tscn")


func _on_main_menu_button_pressed() -> void:
	GAME_STATE.stop_music()
	%InvalidInput.play()
	await Fade.fade_out().finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	Fade.fade_in(0.3)

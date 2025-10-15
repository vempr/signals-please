extends Node2D

signal display_message(message: String)
signal hide_message
signal progress
signal trigger_computer

var visible_message = null
var seen_window := false


func _ready() -> void:
	%FridgeLine.modulate.a = 0.2
	%WindowLine.modulate.a = 0.2
	%ComputerLine.modulate.a = 0.2
	%BedLine.modulate.a = 0.0


func cursor_point() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func cursor_normal() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func emit_hunger() -> void:
	display_message.emit("You are at " + str(snapped(GAME_STATE.player.hunger, 0.1) * 100) +  "% hunger. Do you wish to eat? (-10% hunger)")


func emit_full() -> void:
	display_message.emit("You are at 0% hunger. Save some for your people.")


func _on_fridge_hover_area_mouse_entered() -> void:
	if GAME_STATE.player.hunger > 0.0:
		cursor_point()
		emit_hunger()
	else:
		emit_full()
	
	if GAME_STATE.player.hunger > 0.0:
		%FridgeLine.modulate.a = 0.4
	else:
		%FridgeLine.modulate.a = 0.0


func _on_fridge_hover_area_mouse_exited() -> void:
	hide_message.emit()
	cursor_normal()
	
	if GAME_STATE.player.hunger > 0.0:
		%FridgeLine.modulate.a = 0.2
	else:
		%FridgeLine.modulate.a = 0.0



func _on_fridge_hover_area_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("click") && GAME_STATE.player.hunger > 0.0:
		%Eat.play()
		GAME_STATE.player.hunger -= C.DECREASE_AFTER_EATING
		
		if GAME_STATE.player.hunger <= 0.0:
			emit_full()
			cursor_normal()
			GAME_STATE.player.hunger = 0.0
			%FridgeLine.modulate.a = 0.0
		else:
			emit_hunger()


func _on_window_hover_area_mouse_entered() -> void:
	if !seen_window:
		%WindowLine.modulate.a = 0.0
		display_message.emit("The stars are bright tonight.")
		await get_tree().create_timer(2.0).timeout
		
		hide_message.emit()
		seen_window = true


func _on_computer_hover_area_mouse_entered() -> void:
	cursor_point()
	%ComputerLine.modulate.a = 0.4


func _on_computer_hover_area_mouse_exited() -> void:
	cursor_normal()
	%ComputerLine.modulate.a = 0.2


func _on_bed_hover_area_mouse_entered() -> void:
	if GAME_STATE.day_finished:
		display_message.emit("I can go to sleep now.")
		cursor_point()
		%BedLine.modulate.a = 0.4


func _on_bed_hover_area_mouse_exited() -> void:
	if GAME_STATE.day_finished:
		hide_message.emit()
		cursor_normal()
		%BedLine.modulate.a = 0.2


func _on_computer_hover_area_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("click") && GAME_STATE.day_finished == false:
		# GAME_STATE.day_finished = true
		# %BedLine.modulate.a = 0.2
		trigger_computer.emit()


func _on_bed_hover_area_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("click") && GAME_STATE.day_finished == true:
		progress.emit()
		process_mode = Node.PROCESS_MODE_DISABLED

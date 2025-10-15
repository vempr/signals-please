extends Node2D


@onready var label := %PlayerInput
@onready var timer := %TypingTimer
@onready var terminal_text := %Text
var underscore_visible := true
var booted := false
var can_submit := true


func _ready() -> void:
	label.text = ""
	label.grab_focus()


func _on_player_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	label.text = ""
	if !can_submit:
		return
	
	terminal_text.text += "[color=green]> " + new_text + "[/color]" + "\n"
	
	if !booted:
		if new_text.to_lower() != "boot":
			terminal_text.text += "[color=red]'" + new_text + "' is not a known command. Please try again.[/color]" + "\n"
			return
		
		can_submit = false
		booted = true
		
		var m = "
-- BOOT SEQUENCE --
CONNECTION: STABLE (" + str(snapped(randf() * 2 + 3, 0.01)) + "KB/S)
AUTHORIZED USER: [LEADER_ID_01]
STATUS: PROVISIONAL COMMAND ACTIVE
REPUTATION INDEX: " + str(GAME_STATE.player.reputation) + "% (TRUST: " + GAME_STATE.get_reputation_status() + ")
RATION DISTRIBUTION: " + str(GAME_STATE.player.ration_remaining) + " DAYS REMAINING
"
		await print_text(m, C.COLORS.blue)

		for message in C.MESSAGES.SIG.introduction:
			timer.start(0.5)
			await timer.timeout
			await print_text(message, C.COLORS.orange, 0.02, true)
		
		terminal_text.text += "\n"
		can_submit = true
		return


func print_text(text: String, color: String = "white", speed: float = 0.005, take_breaks: bool = false) -> bool:
	terminal_text.text += "[color=" + color + "]"
	
	for letter in text:
		terminal_text.text += letter
		
		if take_breaks && letter == ".":
			timer.start(0.3)
		elif take_breaks && letter == ",":
			timer.start(0.1)
		else:
			timer.start(speed)
		await timer.timeout

	terminal_text.text += "[/color]\n"
	return true


func wait(time: float = 0.5) -> void:
	timer.start(time)
	await timer.timeout


func _on_computer_in_computer() -> void:
	label.text = ""
	label.grab_focus()

extends Node2D

enum DIFFICULTY { EASY, MEDIUM, HARD }
const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

@onready var label := %PlayerInput
@onready var timer := %TypingTimer
@onready var terminal_text := %Text
var underscore_visible := true
var booted := false
var can_submit := true
var signal_is_incoming := false
var DEBUG := false
var current_signal = null
var difficulty


func _ready() -> void:
	label.text = ""
	label.grab_focus()
	DEBUG = true


func _on_player_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	label.text = ""
	if !can_submit:
		return
	
	terminal_text.text += "[color=green]> " + new_text + "[/color]" + "\n"
	
	if !booted:
		if new_text.strip_edges().to_lower() != "boot":
			terminal_text.text += "[color=red]'" + new_text + "' is not a known command. Please try again.[/color]" + "\n"
			return
		
		can_submit = false
		booted = true
		
		var m = "[b]
-- BOOT SEQUENCE --
CONNECTION: STABLE (" + str(snapped(randf() * 2 + 3, 0.01)) + "KB/S)
AUTHORIZED USER: [LEADER_ID_01]
STATUS: PROVISIONAL COMMAND ACTIVE
REPUTATION INDEX: " + str(GAME_STATE.player.reputation) + "% (TRUST: " + GAME_STATE.get_reputation_status() + ")
RATION DISTRIBUTION: " + str(GAME_STATE.player.ration_remaining) + " DAYS REMAINING
[/b]"
		await print_text(m, C.COLORS.blue)

		for message in C.MESSAGES.SIG.introduction:
			await wait()
			await print_text(message, C.COLORS.orange, 0.02, true)
		
		await wait(1.5)
		await print_text(C.MESSAGES.incoming_signal, C.COLORS.blue, 0.005, true)
		
		can_submit = true
		signal_is_incoming = true
		return
	
	
	if signal_is_incoming && new_text.strip_edges().to_lower() == "r":
		nl()
		can_submit = false
		signal_is_incoming = false
		
		generate_real_signal()
		await print_text(get_prepared_signal(), "white", 0.03, true)
		await wait(0.3)
		
		nl()
		for letter in ["a", "b", "c"]:
			var m = "[b]" + letter + "[/b]: " + current_signal.data[letter].decision
			await print_text(m, C.COLORS.blue)


func print_text(text: String, color: String = "white", speed: float = 0.005, take_breaks: bool = false) -> bool:
	terminal_text.text += "[color=" + color + "]"
	
	if DEBUG:
		terminal_text.text += text
		terminal_text.text += "[/color]\n"
		return true
		
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


func wait(time: float = 0.5) -> bool:
	timer.start(time)
	await timer.timeout
	return true


func _on_computer_in_computer() -> void:
	label.text = ""
	label.grab_focus()


func generate_real_signal() -> void:
	current_signal = {
		"data": C.MESSAGES.real[C.MESSAGE_TYPE.NEED_FOOD][0],
		"type": C.MESSAGE_TYPE.NEED_FOOD,
		"is_real": true,
	}

func nl() -> void:
	terminal_text.text += "\n"


func get_prepared_signal() -> String:
	var request
	match current_signal.type:
		C.MESSAGE_TYPE.NEED_FOOD:
			request = "[REQUEST: HUMANITARIAN ENTRY CLEARANCE]"
		C.MESSAGE_TYPE.PROVIDE_FOOD:
			request = "[REQUEST: TRADE ROUTE ESTABLISHMENT]"
		C.MESSAGE_TYPE.NEED_HELP:
			request = "[REQUEST: EMERGENCY RESPONSE AUTHORIZATION]"
		C.MESSAGE_TYPE.PROVIDE_HELP:
			request = "[REQUEST: COLLABORATION PROTOCOL ACCESS]"
		C.MESSAGE_TYPE.FOOD_SERVICE:
			request = "[REQUEST: LOGISTICAL DISTRIBUTION CONFIRMATION]"
	
	var d := randf()

	if d <= 0.33:
		difficulty = DIFFICULTY.EASY
	elif d <= 0.66:
		difficulty = DIFFICULTY.MEDIUM
	else:
		difficulty = DIFFICULTY.HARD
	
	var id := generate_id()
	var signal_integrity := generate_signal_integrity()
	
	return request + "
ID: " + id + "
SECURITY CLEARANCE: Pending
SIGNAL INTEGRITY: "+ signal_integrity +"
MESSAGE: " + current_signal.data.message_content


func generate_id() -> String:
	var id_prefix: String
	for i in randi_range(1, 4):
		id_prefix += ALPHABET[randi_range(0, ALPHABET.length() - 1)]
	
	var id_number := str(randi_range(1, 9999))
	var id_suffix: String
	for i in randi_range(1, 3):
		id_suffix += ALPHABET[randi_range(0, ALPHABET.length() - 1)]
	
	var parts = [id_prefix, id_number, id_suffix]
	
	match difficulty:
		DIFFICULTY.MEDIUM:
			var i = randi_range(0, 2)
			var part_to_corrupt = parts[i]
			part_to_corrupt[randi_range(1, part_to_corrupt.length())] = "_"
			parts[i] = part_to_corrupt
			
		DIFFICULTY.HARD:
			var corrupt_id_parts: Array[String] = []
			for i in range(randi_range(3, 5)):
				var corrupt_id_part := ""
				
				for j in range(randi_range(1, 4)):
					corrupt_id_part += "_"
				
				corrupt_id_parts.append(corrupt_id_part)
			
			return "-".join(corrupt_id_parts) + " (CORRUPT)"
	
	return "-".join(parts)


func generate_signal_integrity() -> String:
	var p := 0.0
	
	match difficulty:
		DIFFICULTY.EASY:
			p = snapped(randi_range(60, 99) + randf(), 0.1)
		DIFFICULTY.MEDIUM:
			p = snapped(randi_range(40, 70) + randf(), 0.1)
		DIFFICULTY.HARD:
			p = snapped(randi_range(0, 99) + randf(), 0.1)

	return str(p) + "%"

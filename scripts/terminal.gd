extends Node2D

enum DIFFICULTY { EASY, MEDIUM, HARD }
const MAX_TERMINAL_LINES := 50
const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const OPTIONS: Array[String] = ["a", "b", "c"]

@onready var label := %PlayerInput
@onready var timer := %TypingTimer
@onready var terminal_text := %Text
var underscore_visible := true
var booted := false
var can_submit := true
var incoming_signal_next := false
var respond_to_signal := false
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
		if !validate_input(new_text, ["boot"]):
			terminal_text.text += "[color=red]'" + new_text + "' is not a known command. Please try again.[/color]" + "\n"
			return
		
		can_submit = false
		booted = true
		
		var m = "[b]"
		m += "\n-- BOOT SEQUENCE --"
		m += "\nCONNECTION: STABLE (" + str(snapped(randf() * 2 + 3, 0.01)) + "KB/S)"
		m += "\nAUTHORIZED USER: [LEADER_ID_01]"
		m += "\nSTATUS: PROVISIONAL COMMAND ACTIVE"
		m += "\nREPUTATION INDEX: " + str(GAME_STATE.player.reputation) + "% (TRUST: " + GAME_STATE.get_reputation_status() + ")"
		m += "\nRATION DISTRIBUTION: " + str(GAME_STATE.ration_remaining) + " DAYS REMAINING"
		m += "\nPOPULATION: " + str(GAME_STATE.people_remaining) + " PEOPLE REMAINING"
		m += "\nN.A.L ALLIES ARRIVAL: " + str(GAME_STATE.FINAL_DAY - GAME_STATE.day) + " DAYS LEFT"
		m += "\n[/b]"
		await print_text(m, C.COLORS.blue)

		for message in C.MESSAGES.SIG.introduction:
			await wait()
			await print_text(message, C.COLORS.orange, 0.02, true)
		
		await wait(1.5)
		await print_text(C.MESSAGES.incoming_signal, C.COLORS.blue)
		
		can_submit = true
		incoming_signal_next = true
		return
	
	
	if incoming_signal_next:
		if !validate_input(new_text, ["r"]):
			terminal_text.text += "[color=red]'" + new_text + "' is not a known command. Please try again.[/color]" + "\n"
			return
			
		nl()
		can_submit = false
		incoming_signal_next = false
		respond_to_signal = true
		
		generate_real_signal()
		await print_text(get_prepared_signal(), "white", 0.03, true)
		await wait(0.3)
		
		if DEBUG:
			print_text(str(current_signal.is_real))
		
		nl()
		for letter in OPTIONS:
			var m = "[b]" + letter + "[/b]: " + current_signal.data[letter].decision
			await print_text(m, C.COLORS.blue)
		nl()
		
		can_submit = true
		return
	
	
	if respond_to_signal:
		var option = new_text.strip_edges().to_lower()
		if !validate_input(option, OPTIONS):
			terminal_text.text += "[color=red]'" + new_text + "' is not an option. Please try again.[/color]" + "\n"
			return
		
		can_submit = false
		respond_to_signal = false
		
		nl()
		for message in current_signal.data[option].reaction:
			await print_text(message, C.COLORS.blue, 0.005, true)
		nl()
		
		await ddd()
		nl()
		nl()
		await assess_and_display(option)
		nl()
		await ddd()
		await ddd()
		nl()
		await print_text(C.MESSAGES.incoming_signal, C.COLORS.blue)
		
		can_submit = true
		incoming_signal_next = true


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
		elif take_breaks && [",", "-", ";"].find(letter) > -1:
			timer.start(0.1)
		else:
			timer.start(speed)
		await timer.timeout

	terminal_text.text += "[/color]\n"
	return true


func validate_input(s: String, strings: Array[String]) -> bool:
	if strings.find(s.strip_edges().to_lower()) > -1:
		return true
	else:
		return false


func wait(time: float = 0.5) -> bool:
	timer.start(time)
	await timer.timeout
	return true


func _on_computer_in_computer() -> void:
	label.text = ""
	label.grab_focus()


func generate_real_signal() -> void:
	var types =  C.MESSAGE_TYPE.values()
	var rand_type = types[randi_range(0, types.size() - 1)]
	var is_real = randi_range(0, 1)
	
	if is_real:
		current_signal = {
			"data": C.MESSAGES.real[rand_type][randi_range(0, 1)],
			"type": rand_type,
			"is_real": true,
		}
	else:
		current_signal = {
			"data": C.MESSAGES.fake[rand_type][randi_range(0, 1)],
			"type": rand_type,
			"is_real": false,
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
	
	var full_signal := ""
	full_signal += request
	full_signal += "\nID: " + id
	full_signal += "\nSECURITY CLEARANCE: Pending"
	full_signal += "\nSIGNAL INTEGRITY: " + signal_integrity
	full_signal += "\nMESSAGE: " + current_signal.data.message_content

	return full_signal


func generate_id() -> String:
	var id_prefix := ""
	for i in randi_range(1, 4):
		id_prefix += ALPHABET[randi_range(0, ALPHABET.length() - 1)]
	
	var id_number := str(randi_range(1, 9999))
	
	var id_suffix := ""
	for i in randi_range(1, 3):
		id_suffix += ALPHABET[randi_range(0, ALPHABET.length() - 1)]
	
	var parts = [id_prefix, id_number, id_suffix]
	
	match difficulty:
		DIFFICULTY.MEDIUM:
			var i = randi_range(0, 2)
			var part_to_corrupt = parts[i]
			part_to_corrupt[randi_range(0, part_to_corrupt.length() - 1)] = "_"
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


func _on_memory_timer_timeout() -> void:
	var terminal_lines = terminal_text.text.split("\n")

	if terminal_lines.size() > MAX_TERMINAL_LINES:
		terminal_lines = terminal_lines.slice(terminal_lines.size() - MAX_TERMINAL_LINES, terminal_lines.size())
		terminal_text.text = "\n".join(terminal_lines)


func ddd() -> bool:
	terminal_text.text += "[color=00ff00]"
	
	for i in range(3):
		terminal_text.text += "."
		timer.start(0.6)
		await timer.timeout
	
	terminal_text.text += "[/color]"
	return true


func assess_and_display(opt: String) -> bool:
	if opt == "c":
		var reputation_deduction := randi_range(1, 2)
		GAME_STATE.player.reputation -= reputation_deduction
		await print_text("- "+ str(reputation_deduction) +"% REPUTATION", C.COLORS.orange, 0.01)
		return true
	
	if current_signal.is_real:
		match opt:
			"a":
				GAME_STATE.player.reputation += 1
				
				if current_signal.type != C.MESSAGE_TYPE.FOOD_SERVICE:
					GAME_STATE.people_remaining += 1
					await print_random_message(C.MESSAGES.real_success.person)
					
					await wait(0.3)
					await print_text("+ 1% REPUTATION", C.COLORS.orange, 0.01)
					await print_text("+ 1 POPULATION UNIT", C.COLORS.orange, 0.01)
				else:
					var ration_addition = snapped(randi_range(2, 3) + randf(), 0.1)
					GAME_STATE.ration_remaining += ration_addition
					await print_random_message(C.MESSAGES.real_success.food_service)
					
					await wait(0.3)
					await print_text("+ 1% REPUTATION", C.COLORS.orange, 0.01)
					await print_text("+ " + str(ration_addition) +" DAYS OF RATION", C.COLORS.orange, 0.01)
			"b":
				GAME_STATE.player.reputation -= 4
				
				if current_signal.type != C.MESSAGE_TYPE.FOOD_SERVICE:
					await print_random_message(C.MESSAGES.real_failed.person)
				else:
					await print_random_message(C.MESSAGES.real_failed.food_service)
				
				await wait(0.3)
				await print_text("- 4% REPUTATION", C.COLORS.orange, 0.01)
	else:
		match opt:
			"a":
				var punishment := randi_range(1, 2)
				var reputation_deduction: int
				var population_deduction := 0
				
				if punishment == 1:
					reputation_deduction = 5
					GAME_STATE.player.reputation -= reputation_deduction
				else:
					reputation_deduction = randi_range(2, 3)
					population_deduction = 1
					GAME_STATE.people_remaining -= population_deduction
				
				if current_signal.type != C.MESSAGE_TYPE.FOOD_SERVICE:
					await print_random_message(C.MESSAGES.fake_failed.person)
				else:
					await print_random_message(C.MESSAGES.fake_failed.food_service)
				
				await wait(0.3)
				await print_text("- "+ str(reputation_deduction) +"% REPUTATION", C.COLORS.orange, 0.01)
				if population_deduction > 0:
					await print_text("- 1 POPULATION UNIT", C.COLORS.orange, 0.01)
			"b":
				var reputation_addition := 1
				GAME_STATE.player.reputation += reputation_addition
				
				if current_signal.type != C.MESSAGE_TYPE.FOOD_SERVICE:
					await print_random_message(C.MESSAGES.fake_success.person)
				else:
					await print_random_message(C.MESSAGES.fake_success.food_service)
					
				await wait(0.3)
				await print_text("+ 1% REPUTATION", C.COLORS.orange, 0.01)

	return true


func print_random_message(s: Array) -> bool:
	await print_text(s[randi_range(0, s.size() - 1)], C.COLORS.orange, 0.005, true)
	return true

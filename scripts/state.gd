extends Node


var FINAL_DAY := 30
var day := 1
var day_finished := false
@onready var player = {
	"hunger": randi_range(1, 10) + 20,
	"reputation": randi_range(1, 10) + 40,
}
var ration_remaining: float = snapped(randi_range(5, 7) + randf(), 0.1)
var people_remaining := 15


func get_reputation_status() -> String:
	if player.reputation >= 60:
		return "TRUSTED"
	elif player.reputation >= 50:
		return "RESPECTED"
	elif player.reputation >= 40:
		return "NEUTRAL"
	elif player.reputation >= 30:
		return "UNSTEADY"
	elif player.reputation >= 20:
		return "DISTRUSTED"
	elif player.reputation >= 10:
		return "DESPISED"
	return "CONDEMNED"

extends Node


var day := 1
var day_finished := false
@onready var player = {
	"hunger": randi_range(1, 10) + 20,
	"reputation": randi_range(1, 10) + 40,
	"ration_remaining": randi_range(3, 5),
}


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

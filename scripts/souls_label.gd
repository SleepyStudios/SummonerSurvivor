extends Label

@onready var player: Player = $"../../Player"

func _process(_delta: float) -> void:
	text = "SOULS %s/%s" % [player.souls, player.max_soul_capacity]

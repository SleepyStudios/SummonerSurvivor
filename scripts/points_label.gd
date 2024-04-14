extends Label

@onready var player: Player = $"../../../Player"

func _process(_delta: float) -> void:
	text = "%s PTS" % [player.score]

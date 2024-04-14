extends Label

@onready var player: Player = $"../../Player"

func _process(_delta: float) -> void:
	text = "%s SOUL%s" % [player.souls, "S" if player.souls != 1 else ""]

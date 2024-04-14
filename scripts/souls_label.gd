extends Label

@onready var player: Player = $"../../../Player"

func _process(_delta: float) -> void:
	text = "%s SOUL%s" % [str(player.souls) if player.souls != 0 else "NO", "S" if player.souls != 1 else ""]

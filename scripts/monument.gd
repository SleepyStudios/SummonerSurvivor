extends StaticBody2D

@onready var label: Label = $"Label"
@onready var player: Player = $"../../Player"

const UPGRADE_TIERS = [3, 5, 10, 20, 40]
var current_upgrade_tier = 0

func _ready() -> void:
	label.visible = false

func _current_upgrade_requirement() -> int:
	return UPGRADE_TIERS[current_upgrade_tier]

func _update_label_text() -> void:
	var missing_souls = _current_upgrade_requirement() - player.souls
	var soul_text = "SOUL" if missing_souls == 1 else "SOULS"
	label.text = "[X] OFFER %s SOULS" % [_current_upgrade_requirement()] if _can_upgrade() else "NEED %s %s" % [missing_souls, soul_text]

func _can_upgrade() -> bool:
	return player.souls >= _current_upgrade_requirement()

func _on_interactable_area_body_entered(_body: Node2D) -> void:
	_update_label_text()
	label.visible = true

func _on_interactable_area_body_exited(_body: Node2D) -> void:
	label.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("upgrade") and _can_upgrade() and label.visible:
		label.text = "UPGRADED!"
		player.on_upgrade_soul_capacity(_current_upgrade_requirement())

		if current_upgrade_tier < UPGRADE_TIERS.size() - 1:
			current_upgrade_tier += 1

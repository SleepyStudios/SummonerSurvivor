extends StaticBody2D

@onready var label: Label = $Label
@onready var player: Player = $"../../Player"

const UPGRADE_TIERS = [5, 10, 25, 50]
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

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_update_label_text()
		label.visible = true

func _on_interactable_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("upgrade") and _can_upgrade() and label.visible:
		label.text = "HEALTH GRANTED"
		player.on_heal(_current_upgrade_requirement())
		$SFX.play()

		if current_upgrade_tier < UPGRADE_TIERS.size() - 1:
			current_upgrade_tier += 1

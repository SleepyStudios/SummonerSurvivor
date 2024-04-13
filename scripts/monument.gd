extends StaticBody2D

@onready var label: Label = $"Label"
var soul_key: String

func _ready() -> void:
	label.text = "OFFER %s SOULS" % [soul_key.to_upper()]
	label.visible = false

func _on_interactable_area_body_entered(_body: Node2D) -> void:
	label.visible = true

func _on_interactable_area_body_exited(_body: Node2D) -> void:
	label.visible = false

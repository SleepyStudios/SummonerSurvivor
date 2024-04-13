extends StaticBody2D

@onready var label: Label = $"Label"

func _ready() -> void:
	label.visible = false

func _on_interactable_area_body_entered(_body: Node2D) -> void:
	label.visible = true

func _on_interactable_area_body_exited(_body: Node2D) -> void:
	label.visible = false

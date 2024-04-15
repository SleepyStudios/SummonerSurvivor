class_name UI extends CanvasLayer

@onready var death_ui = $DeathUI
@onready var score_label: Label = $DeathUI/VBoxContainer/ScoreLabel
@onready var overlay = $Overlay
@onready var player: Player = $"../Player"

func _ready() -> void:
	death_ui.visible = false

func on_player_death():
	(overlay.find_child("AnimationPlayer") as AnimationPlayer).play_backwards()

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if player.dead:
		death_ui.visible = true
		score_label.text = "%s PTS" % [Score.get_final_score()]
		Engine.time_scale = 0

func _process(_delta: float) -> void:
	if player.dead and Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

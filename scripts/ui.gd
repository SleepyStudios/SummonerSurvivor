class_name UI extends CanvasLayer

@onready var death_ui = $DeathUI
@onready var souls_collected_label: Label = $DeathUI/VBoxContainer/SoulsCollectedLabel
@onready var offerings_made_label: Label = $DeathUI/VBoxContainer/OfferingsMadeLabel
@onready var enemies_score_label: Label = $DeathUI/VBoxContainer/EnemiesScoreLabel
@onready var time_bonus_label: Label = $DeathUI/VBoxContainer/TimeBonusLabel
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
		for child in death_ui.find_child("VBoxContainer").get_children():
			child.visible = false

		$DeathUI/AnimationPlayer.play("death_ui")

		souls_collected_label.text = "%s SOULS COLLECTED" % [Score.souls_collected]
		offerings_made_label.text = "%s OFFERINGS MADE" % [Score.soul_offerings]
		enemies_score_label.text = "+%s KILL BONUS" % [Score.enemy_score]
		time_bonus_label.text = "+%s TIME BONUS" % [Score.get_time_bonus()]
		score_label.text = "%s PTS" % [Score.get_final_score()]

func _process(_delta: float) -> void:
	if player.dead and Input.is_action_just_pressed("restart"):
		Score.reset()
		get_tree().reload_current_scene()

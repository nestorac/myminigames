extends Control

func _ready() -> void:
	var button := $VBox/BattleButton
	button.pressed.connect(_on_battle_pressed)

func _on_battle_pressed() -> void:
	get_tree().change_scene_to_file("res://games/minibattle/battle.tscn")

extends Node2D

var units: Array[Unit] = []
var player_units_left: int = 0
var ai_units_left: int = 0
var game_over: bool = false

@onready var status_label: Label = $UI/StatusLabel
@onready var restart_button: Button = $UI/RestartButton
@onready var back_button: Button = $UI/BackButton

func _ready() -> void:
	spawn_units()
	restart_button.pressed.connect(_on_restart)
	back_button.pressed.connect(_on_back)
	restart_button.visible = false

func spawn_units() -> void:
	# Player units (blue) on the left
	for i in range(3):
		var u := Unit.new()
		u.team = 0
		u.color = Color.BLUE
		u.position = Vector2(100, 200 + i * 150)
		add_child(u)
		units.append(u)
	# AI units (red) on the right
	for i in range(3):
		var u := Unit.new()
		u.team = 1
		u.color = Color.RED
		u.position = Vector2(600, 200 + i * 150)
		add_child(u)
		units.append(u)
	update_counts()

func update_counts() -> void:
	player_units_left = units.filter(func(u): return is_instance_valid(u) and u.team == 0 and not u.is_dead).size()
	ai_units_left = units.filter(func(u): return is_instance_valid(u) and u.team == 1 and not u.is_dead).size()

func _process(delta: float) -> void:
	if game_over:
		return
	for u in units:
		if is_instance_valid(u) and not u.is_dead:
			u.update_ai(delta, units)
	update_counts()
	if player_units_left == 0 or ai_units_left == 0:
		end_game()

func end_game() -> void:
	game_over = true
	if player_units_left > 0:
		status_label.text = "¡Victoria!"
	else:
		status_label.text = "Derrota"
	restart_button.visible = true

func _on_restart() -> void:
	get_tree().reload_current_scene()

func _on_back() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

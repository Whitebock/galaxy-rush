extends Control

var all_upgrades = {
	"full_health": func(): return SaveData.health < 10,
	"double_shot": func(): return true,
	"triple_shot": func(): return SaveData.upgrades.has("double_shot"),
	"quintuple_shot": func(): return SaveData.upgrades.has("triple_shot"),
	"faster_ship": func(): return true,
	"automatic_double_shot": func(): return SaveData.upgrades.has("double_shot"),
}

var group = ButtonGroup.new()
func _ready() -> void:
	%Progress.value = SaveData.level
	
	group.pressed.connect(func(_b): $Content/Layout/Next.disabled = false)
	
	var valid_upgrades = []
	for upgrade in all_upgrades:
		if SaveData.upgrades.has(upgrade): continue
		if all_upgrades[upgrade].call():
			valid_upgrades.append(upgrade)
			
	for i in 3:
		var upgrade = valid_upgrades.pick_random() if len(valid_upgrades) > 0 else null
		valid_upgrades.erase(upgrade)
		
		var to_add: Control
		if upgrade == null:
			to_add = Control.new()
		else:
			var button = Button.new()
			button.button_group = group
			button.toggle_mode = true
			button.text = upgrade.capitalize()
			button.autowrap_mode = TextServer.AUTOWRAP_WORD
			to_add = button
			
		to_add.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		%Upgrades.add_child(to_add)

func _on_next_pressed() -> void:
	var selected = group.get_pressed_button().text.to_snake_case()
	match selected:
		"full_health": 
			SaveData.health = Ship.MAX_HEALTH
		_:
			SaveData.upgrades.append(selected)
	get_tree().change_scene_to_file("res://game/game.tscn")

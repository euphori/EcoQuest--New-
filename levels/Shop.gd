extends Control


@onready var dmg_button = $GunUpgrade/Damage
@onready var hp_button = $HealthUpgrade/HP
@onready var repair_button = $Repair/Repair

var cost = {
	"damage" : 25, 
	"hp" : 15,
	"repair" : 30
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	global.connect("item_added", update_label)
	global.connect("pickup_item", update_label)
	$Scraps.text = str("Scraps: " , global.items["Scraps"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_label():
	$Scraps.text = str("Scraps: " , global.items["Scraps"])

func _on_damage_pressed():
	if global.items["Scraps"] >= cost.damage:
		global.items["Scraps"] -= cost.damage
		dmg_button.modulate = Color(0.451, 0.451, 0.451)
		dmg_button.disabled = true
		$GunUpgrade/Cost.text = "Upgrade Bought!"
		global.emit_signal("item_added")
	else:
		$Warning.visible = true
		await get_tree().create_timer(.5).timeout
		$Warning.visible = false

func _on_hp_pressed():
	if global.items["Scraps"] >= cost.hp:
		global.items["Scraps"] -= cost.hp
		hp_button.modulate = Color(0.451, 0.451, 0.451)
		hp_button.disabled = true
		$HealthUpgrade/Cost.text = "Upgrade Bought!"
		global.emit_signal("item_added")
	else:
		$Warning.visible = true
		await get_tree().create_timer(.5).timeout
		$Warning.visible = false

func _on_repair_pressed():
	if global.items["Scraps"] >= cost.repair:
		global.items["Scraps"] -= cost.repair
		repair_button.modulate = Color(0.451, 0.451, 0.451)
		repair_button.disabled = true
		$Repair/Cost.text = "Moped Repaired"
		global.emit_signal("item_added")
	else:
		$Warning.visible = true
		await get_tree().create_timer(.5).timeout
		$Warning.visible = false

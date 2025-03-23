extends Node2D

# Variabel Game
var points: int = 0
var total_click: int = 0
var shape_level: int = 1
var click_power_from_level: int = 1
var click_power_from_power_up: int = 0
var click_power_from_boost: int = 0

# Power Up
var power_up_level: int = 0

# Auto Click
var auto_click_points: int = 0
var auto_click_interval: float = 5.0

# Variabel untuk Level Auto Click
var auto_click_level: int = 0
var auto_click_multiplier: int = 0  # Jumlah klik per interval

# Boost Power
var boost_power_active: bool = false
var boost_power_duration: float = 10.0

# Referensi UI
@onready var points_label: Label = $UI/VBoxContainer/PointsLabel
@onready var total_click_label: Label = $UI/VBoxContainer/TotalClickLabel
@onready var click_power_label: Label = $UI/VBoxContainer/ClickPowerLabel
@onready var shape_sprite: Sprite2D = $UI/Shape/Shape2D 
@onready var upgrade_cost_label: Label = $UI/VBoxContainer/GridContainer/UpgradeCostLabel
@onready var power_up_cost_label: Label = $UI/VBoxContainer/GridContainer/PowerUpCostLabel
@onready var auto_click_cost_label: Label = $UI/VBoxContainer/GridContainer/AutoClickCostLabel
@onready var boost_cost_label: Label = $UI/VBoxContainer/GridContainer/BoostCostLabel
@onready var boost_button: Button = $UI/VBoxContainer/GridContainer/ActivateBoost
@onready var bounce_animation_player: AnimationPlayer = $UI/Shape/Shape2D/BounceAnimationPlayer

# Array path gambar shape
var shapes: Array = [
	"res://assets/point.png",    # Level 1
	"res://assets/line.png",     # Level 2
	"res://assets/Shape-1.png",  # Level 3
	"res://assets/Shape-2.png",  # Level 4
	"res://assets/Shape-3.png",
	"res://assets/Shape-4.png",
	"res://assets/Shape-5.png",
	"res://assets/Shape-6.png",
	"res://assets/Shape-7.png",
	"res://assets/Shape-8.png",
	"res://assets/Shape-9.png",
	"res://assets/Shape-10.png",
	"res://assets/Shape-11.png",
	"res://assets/Shape-12.png",
	"res://assets/Shape-13.png",
	"res://assets/Shape-14.png",
	"res://assets/Shape-15.png",
	"res://assets/Shape-16.png",
	"res://assets/Shape-17.png",
	"res://assets/Shape-18.png",
	"res://assets/Shape-19.png",
	"res://assets/Shape-20.png",
	"res://assets/Shape-21.png",
	"res://assets/Shape-22.png",
	"res://assets/Shape-23.png",
	"res://assets/Shape-24.png",
	"res://assets/Shape-25.png",
	"res://assets/Shape-26.png",
	"res://assets/Shape-27.png",
	"res://assets/Shape-28.png",
	"res://assets/Shape-29.png", # Level 29
	"res://assets/circle.png"    # Level 30
]

# Fungsi untuk mengupdate UI
func update_ui():
	points_label.text = "Points: %d" % points
	total_click_label.text = "Total Click: %d" % total_click
	click_power_label.text = "Click Power: %d" % (click_power_from_level + click_power_from_power_up + click_power_from_boost)
	upgrade_cost_label.text = "Upgrade Cost: %d" % calculate_upgrade_cost(shape_level)
	boost_cost_label.text = "Boost Cost: %d" % 200  # Biaya Boost
	
	# Update biaya Power Up
	var power_up_cost = 50 + (power_up_level * 10)
	power_up_cost_label.text = "Power Up Cost: %d" % power_up_cost

	# Update biaya Auto Click
	var auto_click_cost = 100 + (auto_click_level * 20)
	auto_click_cost_label.text = "Auto Click Cost: %d" % auto_click_cost
	
	# Hitung interval Auto Click
	var auto_click_interval = max(1, 10 - auto_click_level) if auto_click_level <= 10 else 1

	# Hitung klik per detik
	var clicks_per_second = float(auto_click_multiplier) / float(auto_click_interval)

	# Update detail klik tambahan
	var level_click_detail = "Level %d: %d Click" % [shape_level, click_power_from_level]
	var power_up_detail = "Power Up: +%d Click (Level %d)" % [click_power_from_power_up, power_up_level]
	var auto_click_detail = "Auto Click: %d Click / %d detik (Level %d) (%.2f Click/s)" % [
		auto_click_multiplier,  # Jumlah klik per interval
		auto_click_interval,    # Interval waktu
		auto_click_level,       # Level Auto Click
		clicks_per_second       # Klik per detik
	]
	var boost_detail = "Boost: +%d Click" % click_power_from_boost

	# Jika boost aktif, tambahkan durasi tersisa
	if boost_power_active:
		var boost_time_left = int($BoosterTimer.time_left)
		boost_detail += " (%d s remaining)" % boost_time_left

	# Gabungkan semua detail ke dalam satu label (atau tampilkan di label terpisah)
	var detail_label_text = "%s\n%s\n%s\n%s" % [level_click_detail, power_up_detail, auto_click_detail, boost_detail]
	$UI/VBoxContainer/DetailLabel.text = detail_label_text  # Pastikan ada label DetailLabel di UI Anda
	
# Nonaktifkan tombol Boost jika Boost sedang aktif
	boost_button.disabled = boost_power_active

# Fungsi utilitas
func calculate_upgrade_cost(level: int) -> int:
	return int(10 * pow(1.75, level - 1))

func calculate_click_power_from_level(level: int) -> int:
	return (level * (level + 1)) / 2

#CLICK SHAPE
func _on_shape_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.pressed:
		var total_click_power = click_power_from_level + click_power_from_power_up + click_power_from_boost
		points += total_click_power
		total_click += 1
		bounce_animation_player.play("bounce")  # Jalankan animasi bounce
		update_ui()

#UPGRADE LEVEL
func _on_upgrade_button_pressed():
	var upgrade_cost = calculate_upgrade_cost(shape_level)
	if points >= upgrade_cost:
		points -= upgrade_cost
		shape_level += 1
		click_power_from_level = calculate_click_power_from_level(shape_level)
		# Update gambar shape
		if shape_level <= shapes.size():
			var texture_path = shapes[shape_level - 1]  # Ambil path gambar dari array
			var texture = load(texture_path)  # Muat texture dari path
			if texture:
				$UI/Shape/Shape2D.texture = texture  # Set texture ke Sprite2D
			else:
				print("Gagal memuat texture dari path:", texture_path)
		else:
			print("Level shape melebihi jumlah gambar yang tersedia!")
		
		update_ui()
	else:
		print("Poin tidak cukup untuk upgrade!")

# POWER UP
func _on_power_up_button_pressed():
	var power_up_cost = 50 + (power_up_level * 10)  # Biaya Power Up berdasarkan level
	if points >= power_up_cost:
		points -= power_up_cost
		click_power_from_power_up += 1  # Kekuatan klik tetap +1 per level
		power_up_level += 1  # Tingkatkan level Power Up
		update_ui()
	else:
		print("Poin tidak cukup untuk membeli Power Up!")

# AUTO CLICK
func _on_auto_click_button_pressed():
	var auto_click_cost = 100 + (auto_click_level * 20)  # Biaya Auto Click berdasarkan level
	var auto_click_interval = max(1, 10 - auto_click_level)  # Interval Auto Click (minimum 1 detik)

	if points >= auto_click_cost:
		points -= auto_click_cost
		auto_click_level += 1  # Tingkatkan level Auto Click

		# Hitung jumlah klik per interval
		if auto_click_level <= 10:
			auto_click_multiplier = 1  # Sebelum level 10, 1 klik per interval
		else:
			auto_click_multiplier = 2 ** (auto_click_level - 10)  # Setelah level 10, jumlah klik meningkat eksponensial

		# Set interval Auto Click
		if auto_click_level <= 10:
			auto_click_interval = max(1, 10 - auto_click_level)  # Interval menurun hingga 1 detik di level 10
		else:
			auto_click_interval = 1  # Setelah level 10, interval tetap 1 detik

		$AutoClickTimer.wait_time = auto_click_interval  # Perbarui interval timer

		# Aktifkan timer Auto Click jika belum aktif
		if not $AutoClickTimer.is_stopped():
			$AutoClickTimer.start()

		update_ui()
	else:
		print("Poin tidak cukup untuk membeli Auto Click!")

# Fungsi saat Auto Click Timer timeout
func _on_auto_click_timer_timeout():
	if auto_click_multiplier > 0:
		points += auto_click_multiplier  # Tambahkan poin berdasarkan jumlah klik per interval
		update_ui()

# BOOST
func _on_activate_boost_pressed():
	var boost_cost = 200  # Biaya Boost
	if points >= boost_cost:
		points -= boost_cost
		click_power_from_boost = 500  # Kekuatan Boost
		boost_power_active = true
		boost_button.disabled = true  # Nonaktifkan tombol Boost
		$BoosterTimer.start()  # Mulai timer Boost
		update_ui()
	else: print("Poin tidak cukup untuk mengaktifkan Boost!")

# Fungsi saat Boost Timer timeout
func _on_booster_timer_timeout():
	boost_power_active = false
	click_power_from_boost = 0
	boost_button.disabled = false  # Aktifkan kembali tombol Boost
	update_ui()

extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var db = {"Schueler": {}, "Faecher": {}, "Klassen": {}}

# Called when the node enters the scene tree for the first time.
func _ready():
	$dropdown.add_item("Schüler")
	$dropdown.add_item("3G")

class Schueler:
	var vorname
	var nachname
	var klasse
	var faecher
	var geburtsdatum
	var id
	func _init(vorname, nachname, klasse, faecher, geburtsdatum, id):
		self.vorname = vorname
		self.nachname = nachname
		self.klasse = klasse
		self.klasse.add_schueler(self)
		self.faecher = faecher
		for i in self.faecher:
			i.add_schueler(self)
		self.geburtsdatum = geburtsdatum
		self.id = id

class Fach:
	var name
	var db
	func _init(name, schueler = [], staten = []):
		self.name = name
		self.db = []
		for i in schueler:
			self.db.append([i])
		for i in range(len(staten)):
			self.db[i].append(staten[i])
	
	func add_schueler(schueler, status = null):
		self.db.append([schueler, status])
		schueler.faecher.append(self)
	
	func del_schueler(schueler):
		for i in self.db:
			if i[0] == schueler:
				self.db.erase(i)
	
	func set_status(schueler, status):
		for i in range(len(self.db)):
			if self.db[i][0] == schueler:
				self.db[i][1] = status
	
	func hat_schueler(schueler):
		for i in self.db:
			if i[0] == schueler:
				return true
		return false

class Klasse:
	var name
	var schueler
	func _init(name, schueler = []):
		self.name = name
		self.schueler = schueler
	
	func add_schueler(schueler):
		self.schueler.append(schueler)

func read_new_csv(datei_name):
	# struktur:
	# id;vorname;nachname;klasse;geburtsdatum
	var file = File.new()
	file.open(datei_name, file.READ)
	while !file.eof_reached():
		var csv = file.get_csv_line(";")
		if !(csv[3] in db["Klassen"]):
			db["Klassen"][csv[3]] = Klasse.new(csv[3])
		db["Schueler"][csv[0]] = Schueler.new(csv[1], csv[2], db["Klassen"][csv[3]], [], csv[4], csv[0])

func read_res_csv(datei_name):
	# struktur:
	# id;fach;status
	var file = File.new()
	file.open(datei_name, file.READ)
	while !file.eof_reached():
		var csv = file.get_csv_line()
		if !(csv[1] in db["Faecher"]):
			db["Faecher"][csv[1]] = Fach.new(csv[1])
		if !db["Faecher"][csv[1]].has_schueler(db["Schueler"][csv[0]]):
			db["Faecher"][csv[1]].add_schueler(db["Schueler"][csv[0]], csv[2])
		else:
			db["Faecher"][csv[1]].set_status(db["Schueler"][csv[0]], csv[2])




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Suche_pressed():
	var ergebnisse = []
	for i in db["Schueler"]:
		ergebnisse.append(db["Schueler"][i])
	if $NameE.text != "":
		for i in ergebnisse:
			if i.nachname != $NameE.text:
				ergebnisse.erase(i)
	if $VornameE.text != "":
		for i in ergebnisse:
			if i.vorname != $VornameE.text:
				ergebnisse.erase(i)
	if $KlasseE.text != "":
		for i in ergebnisse:
			if i.klasse.name != $KlasseE.text:
				ergebnisse.erase(i)
	if $KursE.text != "":
		for i in ergebnisse:
			var kursnamen = []
			for j in i.faecher:
				kursnamen.append(j.name)
			if !$KursE.text in kursnamen:
				ergebnisse.erase(i)
	if len(ergebnisse) == 1:
		var s = ergebnisse[0]
		$NameE.text = s.nachname
		$VornameE.text = s.vorname
		$KlasseE.text = s.klasse.name
		$Id.text = s.id


func _on_CSV_pressed():
	print($CSV_name.text)
	if $dropdown.selected == 0:
		read_new_csv($CSV_name.text)
	else:
		read_res_csv($CSV_name.text)

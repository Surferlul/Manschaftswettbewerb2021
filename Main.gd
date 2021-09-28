extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var db = {"Schueler": [], "Faecher": {}, "Klassen": {}}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

class Schueler:
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
	func _init(name, schueler = [], staten = [], zeiten = []):
		self.name = name
		self.db = []
		for i in schueler:
			self.db.append([i])
		for i in range(len(staten)):
			self.db[i].append(staten[i])
		for i in range(len(zeiten)):
			self.db[i].append(zeiten[i])
	
	func add_schueler(schueler, status = null, zeit = null):
		self.db.append([schueler, status, zeit])
	
	func del_schueler(schueler):
		for i in self.db:
			if i[0] == schueler:
				self.db.erase(i)
	
	func set_status(schueler, status, zeit):
		for i in range(len(self.db)):
			if self.db[i][0] == schueler:
				self.db[i][1] = status
				self.db[i][2] = zeit

class Klasse:
	func _init(name, schueler = []):
		self.name = name
		self.schueler = schueler
	
	func add_schueler(schueler):
		self.schueler.append(schueler)

func read_new_csv(overwrite = false):
	db = {"Schueler": [], "Faecher": {}, "Klassen": {}}
	var file = File.new()
	file.open("~/test.csv", file.READ)
	while !file.eof_reached():
		var csv = file.get_csv_line()
		if !(csv[2] in db["Klassen"]):
			db["Klassen"][csv[2]] = Klasse.new(csv[2])
		db["Schueler"].append(Schueler.new(csv[1], csv[2], db["Klassen"][csv[3]], [], csv[4], csv[5]))

func read_res_csv():
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#hallo test

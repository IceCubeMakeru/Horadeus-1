extends Spatial

func _input(event):
	
	if event is InputEventMouseMotion:
		self.rotation_degrees.y -= event.relative.x



func _process(delta):
	
	
	if Input.ui_up():
		self.translate(Vector3(0,0,-.1))
		
	
	if Input.ui_down():
		self.translate(Vector3(0,0,.1))
		
	
	if Input.ui_left():
		self.translate(Vector3(-.1,0,0))
		
	
	if Input.ui_right():
		self.translate(Vector3(.1,0,0))
		

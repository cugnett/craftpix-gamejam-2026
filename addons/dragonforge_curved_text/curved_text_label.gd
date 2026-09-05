@icon("res://addons/dragonforge_curved_text/assets/textures/icons/curved_text_label.png")
@tool
class_name CurvedTextLabel extends Label

@export var path_2d: Path2D
@export_tool_button("Redraw Text") var _redraw_text = queue_redraw

var _path_2d: Path2D = Path2D.new()
var _line = TextLine.new()
var _text: String


func _ready() -> void:
	child_entered_tree.connect(_on_subnode_added)
	child_exiting_tree.connect(_on_subnode_removed)
	if OS.has_feature("editor_hint"):
		set_process(false)


func _process(_delta: float) -> void:
	if not text.is_empty():
		_text = text
	queue_redraw()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	if not path_2d:
		warnings.append("This node has no curve, so the text can cannot be displayed as a curve.\n Consider adding a Path2D as a child to define the curve.")
	elif path_2d.curve.point_count <= 1:
		warnings.append("A curve must be provided in the Path2D node for CurvedTextLabel to function. Please create at least two points for it!")
	return warnings


func _draw() -> void:
	if path_2d == null:
		return
	if path_2d.curve.point_count <= 1:
		return
	# Get the font, font size and color from the ThemeDB
	var font = ThemeDB.fallback_font
	var font_size = ThemeDB.fallback_font_size
	var font_color = Color.WHITE

	# If the label_settings is valid, then use the values from it
	if is_instance_valid(label_settings):
		font = label_settings.font
		font_size = label_settings.font_size
		font_color = label_settings.font_color

	# Clear the line and add the new string
	_line.clear()
	_line.add_string(_text, font, font_size)
	# Get the primary TextServer
	var ts = TextServerManager.get_primary_interface()
	# And get the glyph information from the line
	var glyphs = ts.shaped_text_get_glyphs(_line.get_rid())

	var offset = 0.0
	for glyph_data in glyphs:
		# Sample the curve with rotation at the offset
		var trans = path_2d.curve.sample_baked_with_rotation(offset)
		# set the draw matrix to that transform
		draw_set_transform_matrix(trans)
		# draw the glyph
		ts.font_draw_glyph(glyph_data["font_rid"], get_canvas_item(), font_size, Vector2.ZERO, glyph_data["index"], font_color, 2.0)
		# add the advance to the offset
		offset += glyph_data.get("advance", 0.0)


func _on_subnode_added(node: Node) -> void:
	if node is Path2D:
		_path_2d = node


func _on_subnode_removed(node: Node) -> void:
	if node == _path_2d:
		_path_2d = null

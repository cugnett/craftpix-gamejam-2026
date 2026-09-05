@icon("res://addons/dragonforge_curved_text/assets/textures/icons/curved_text.png")
@tool
## Creates curved text as a Node2D object. Note that if Label Settings is used
## to customize the font, the text will disappear until a font is assigned under
## Font. Changes to Shadow and Stacked Effects will not show as they are only
## supported by [Label] and [RichTextLabel] nodes. If you want this
## functionality, you will have to use a [CurvedTextLabel] node instead.
class_name CurvedText2D extends Path2D

@export var text: String:
	set(value):
		if text != value:
			text = value
			queue_redraw()
@export var label_settings: LabelSettings:
	set(value):
		if is_instance_valid(label_settings) and label_settings.changed.is_connected(queue_redraw):
			label_settings.changed.disconnect(queue_redraw)

		label_settings = value

		if is_instance_valid(label_settings):
			label_settings.changed.connect(queue_redraw)

var _line = TextLine.new()


func _ready() -> void:
	pass


func _draw() -> void:
	# Get the font, font size and color from the ThemeDB
	var font = ThemeDB.fallback_font
	var font_size = ThemeDB.fallback_font_size
	var font_color = Color.WHITE
	var outline_size = 0
	var outline_color = Color.WHITE

	# If the label_settings is valid, then use the values from it
	if is_instance_valid(label_settings):
		font = label_settings.font
		font_size = label_settings.font_size
		font_color = label_settings.font_color
		outline_size = label_settings.outline_size
		outline_color = label_settings.outline_color

	# Clear the line and add the new string
	_line.clear()
	var localized_text = tr(text)
	_line.add_string(localized_text, font, font_size)
	# Get the primary TextServer
	var text_server = TextServerManager.get_primary_interface()
	# And get the glyph information from the line
	var glyphs = text_server.shaped_text_get_glyphs(_line.get_rid())

	var offset = 0.0
	for glyph_data in glyphs:
		# Sample the curve with rotation at the offset
		var curve_transform = curve.sample_baked_with_rotation(offset)
		# set the draw matrix to that transform
		draw_set_transform_matrix(curve_transform)
		# draw the glyph
		text_server.font_draw_glyph(glyph_data["font_rid"], get_canvas_item(), font_size, Vector2.ZERO, glyph_data["index"], font_color)
		text_server.font_draw_glyph_outline(glyph_data["font_rid"], get_canvas_item(), font_size, outline_size, Vector2.ZERO, glyph_data["index"], outline_color)
		
		# add the advance to the offset
		offset += glyph_data.get("advance", 0.0)


func _on_locale_changed(_new_locale: String) -> void:
	queue_redraw()

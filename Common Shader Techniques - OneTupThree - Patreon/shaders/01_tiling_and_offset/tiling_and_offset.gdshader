shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,unshaded;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : 
		source_color,
		filter_linear_mipmap,
		repeat_enable;

uniform vec2 tiling = vec2(1.0, 1.0);
uniform vec2 offset;

void vertex() {
	UV = UV * tiling + offset * TIME;
}


void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	albedo_tex *= COLOR;
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	ALPHA *= albedo.a * albedo_tex.a;
}

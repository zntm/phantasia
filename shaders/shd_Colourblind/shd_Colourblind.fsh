varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform int type;

#define PROTANOPIA 0
#define DEUTERANOPIA 1
#define TRITANOPIA 2
#define ACHROMATOPSIA 3
#define PROTANOPALY 4
#define DEUTERANOMALY 5
#define TRITANOMALY 6
#define ACHROMATOMALY 7

void main()
{
	if (type == PROTANOPIA)
	{
		gl_FragColor = vec4(mat3(0.170556992, 0.170556991, -0.004517144, 0.829443014, 0.829443008, 0.004517144, 0.0, 0.0, 1.0) * texture2D(gm_BaseTexture, v_vTexcoord).rgb, 1.0);
	}
	else if (type == DEUTERANOPIA)
	{
		gl_FragColor = vec4(mat3(0.33066007, 0.33066007, -0.02785538, 0.66933993, 0.66933993, 0.02785538, 0.0, 0.0, 1.0) * texture2D(gm_BaseTexture, v_vTexcoord).rgb, 1.0);
	}
	else if (type == TRITANOPIA)
	{
		gl_FragColor = vec4(mat3(1.0, 0.0, 0.0, 0.1273989, 0.8739093, 0.8739093, -0.1273989, 0.1260907, 0.1260907) * texture2D(gm_BaseTexture, v_vTexcoord).rgb, 1.0);
	}
	else if (type == ACHROMATOPSIA)
	{
		gl_FragColor = vec4(texture2D(gm_BaseTexture, v_vTexcoord).rgb * mat3(0.2126, 0.7152, 0.0722, 0.2126, 0.7152, 0.0722, 0.2126, 0.7152, 0.0722), 1.0);
	}
	else if (type == PROTANOPALY)
	{
		gl_FragColor = vec4(mat3(0.817, 0.183, 0.0, 0.333, 0.667, 0.0, 0.0, 0.125, 0.875) * texture2D(gm_BaseTexture, v_vTexcoord).rgb, 1.0);
	}
	else if (type == DEUTERANOMALY)
	{
		gl_FragColor = vec4(mat3(0.8, 0.2, 0.0, 0.258, 0.742, 0.0, 0.0, 0.142, 0.858) * texture2D(gm_BaseTexture, v_vTexcoord).rgb, 1.0);
	}
	else if (type == TRITANOMALY)
	{
		gl_FragColor = vec4(mat3(0.967, 0.033, 0.0, 0.0, 0.733, 0.267, 0.0, 0.183, 0.817) * texture2D(gm_BaseTexture, v_vTexcoord).rgb, 1.0);
	}
	else // if (type == ACHROMATOMALY)
	{
		gl_FragColor = vec4(texture2D(gm_BaseTexture, v_vTexcoord).rgb * mat3(0.618, 0.32, 0.062, 0.163, 0.775, 0.062, 0.163, 0.32, 0.516), 1.0);
	}
}
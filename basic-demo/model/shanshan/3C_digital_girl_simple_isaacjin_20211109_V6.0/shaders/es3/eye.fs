#version 300 es
out highp vec4 out_fragColor; 
precision highp float;
uniform int albedousage;
uniform sampler2D albedo;
uniform int ramptexusage;
uniform sampler2D ramptex;
uniform float rampintensity;

uniform int matcapusage;
uniform sampler2D matcap;
uniform float matcapintensity;

uniform int shadowtexusage;
uniform sampler2D shadowtex;
uniform float shadowintensity;
uniform int isflip;
uniform int speculartexusage;
uniform sampler2D speculartex;

uniform int transmasktexusage;
uniform sampler2D transmasktex;
uniform float transmission;

uniform vec3 _CameraPos;

uniform mat4 _V;
uniform mat4 _MV;
in vec2 v_UV0;
in vec2 v_UV1;
in float rotate;

in vec3 v_wL;
in vec3 v_wN;
in vec3 v_wView;

vec2 MatCapUV(vec3 N, vec3 viewPos)
{
	vec3 viewNorm = (_V*vec4(N,0.0)).xyz;
	vec3 viewDir = normalize(viewPos);
	vec3 viewCross = cross(viewDir, viewNorm);
	viewNorm = vec3(-viewCross.y, viewCross.x, 0.0);
	vec2 matCapUV = viewNorm.xy * 0.5 + 0.5;
	return matCapUV;
}

void main()
{
	vec4 albedoColor = vec4(1.0);
	if(bool(albedousage)){
		albedoColor = texture(albedo,v_UV1);
	}
	float halfLambert = dot(v_wN,v_wL)*0.49+0.5;
	vec4 diff = vec4(1.0);
	if(bool(ramptexusage)){
		diff = texture(ramptex,vec2(halfLambert,0.5));
	}

	vec4 _spec = vec4(0.0);
	if(bool(matcapusage)){
		vec2 cap = MatCapUV(v_wN,v_wView);
		_spec = texture(matcap,cap)*2.0-vec4(1.0);
		_spec = max(vec4(0.0),_spec)*matcapintensity;
	}

	vec4 _spec1 = vec4(0.0);
    vec2 _spec_UV = v_UV1-vec2(0.5);
    float rot = -rotate*0.5;

    _spec_UV = vec2(_spec_UV.x*cos(rot)-_spec_UV.y*sin(rot),_spec_UV.x*sin(rot) + _spec_UV.y*cos(rot))+vec2(0.5);
	if(bool(speculartexusage)){
		_spec1 = texture(speculartex,_spec_UV);
	}
	vec4 transmask = vec4(0.0);
	if(bool(transmasktexusage)){
		transmask = texture(transmasktex,v_UV1)*transmission;
	}
    
    float fresnelMask = (1.0-length(v_UV1-0.5))*5.0-3.2;

	vec4 shadow = vec4(1.0);
	if(bool(shadowtexusage)){
		vec2 uv_shadow = vec2((1.0-float(isflip)*2.0)*v_UV1.x,v_UV1.y); 
		shadow = texture(shadowtex,uv_shadow);
	}

	float ndotv = dot(v_wN, v_wView)+0.41;
	float  fresnel = 1.0-ndotv*ndotv;
	fresnel = max(0.0,fresnel)*fresnelMask;
	vec4 maincol = mix(albedoColor*diff*rampintensity,albedoColor*2.0,transmask*transmission);
    out_fragColor = (maincol + _spec + _spec1 + fresnel)*shadow;
	out_fragColor.a = albedoColor.a;
}
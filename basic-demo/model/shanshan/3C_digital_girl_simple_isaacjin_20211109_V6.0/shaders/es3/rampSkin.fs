#version 300 es
out highp vec4 out_fragColor; 
precision highp float;
uniform int albedousage;
uniform sampler2D albedo;
uniform int ramptexusage;
uniform sampler2D ramptex;
uniform float rampintensity;
uniform int masktexusage;
uniform sampler2D masktex;
uniform int matcapusage;
uniform float matcapintensity;
uniform sampler2D matcap;
uniform int bumptexusage;
uniform sampler2D bumptex;
uniform float bumpscale;
uniform vec4 color;

in vec2 v_UV0;
in vec2 v_UV2;
in vec2 v_UV3;
in vec3 v_wT;
in vec3 v_wB;
in vec3 v_wN;
in vec3 v_wL;
in vec3 v_vN; 
in vec3 v_wView;  

in vec2 cap;
uniform mat4 _V;


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
	vec4 albedoColor = color;
	if(bool(albedousage)){
		albedoColor = texture(albedo,v_UV0)*color;
	}
	vec3 n = normalize(v_wN);
    if(bool(bumptexusage))
    {
        n = normalize(texture(bumptex, v_UV2).xyz *  2.0 - 1.0);
        n.xy *= bumpscale;
        mat3 v_wTBN = mat3(v_wT,v_wB,v_wN);
        n.z = sqrt(1.0-clamp(dot(n.xy, n.xy), 0.0, 1.0))*sign(n.z);
        n = normalize(v_wTBN * n);
    }
	float halfLambert = dot(n,v_wL)*0.49+0.5;
	vec4 diff = vec4(1.0,1.0,1.0,1.0);
	if(bool(ramptexusage)){
		diff = texture(ramptex,vec2(halfLambert,0.5));
	}

	float mask = 1.0;
	if(bool(masktexusage)){
		mask = texture(masktex,v_UV3).r;
	}
	
	vec4 _spec = vec4(0.0);
	if(bool(matcapusage)){
		vec2 cap = MatCapUV(n,v_wView);
		_spec = texture(matcap,cap)*2.0-1.0;
		_spec = max(vec4(0.0),_spec)*mask;
	}
    out_fragColor = albedoColor*diff*rampintensity+_spec*matcapintensity;
	out_fragColor.a= albedoColor.a;
}
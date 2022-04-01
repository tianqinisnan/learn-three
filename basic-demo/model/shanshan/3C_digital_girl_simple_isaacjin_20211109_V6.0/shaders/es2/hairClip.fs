precision highp float;
uniform int albedousage;
uniform sampler2D albedo;
uniform int ramptexusage;
uniform sampler2D ramptex;
uniform float rampintensity;
uniform int anisotexusage;
uniform sampler2D anisotex;

uniform int bumptexusage;
uniform sampler2D bumptex;
uniform float bumpscale;
uniform vec4 color;
uniform vec3 _CameraPos;

uniform vec4 specularcolor;
uniform vec4 specularcolor2;
uniform float primaryshift;
uniform float secondaryshift;
uniform float specularmultiplier;
uniform float specularmultiplier2;
uniform float cut;

varying vec2 v_UV0;
varying vec2 v_UV1;
varying vec2 v_UV2;
varying vec2 v_UV3;

varying vec3 v_wL;

varying vec3 v_wT;
varying vec3 v_wB;
varying vec3 v_wN;
varying vec3 v_wPos;
//获取头发高光
float StrandSpecular ( vec3 T, vec3 V, vec3 L, float exponent)
{
	vec3 H = normalize(L + V);
	float dotTH = dot(T, H);
	float sinTH = sqrt(1.0 - dotTH * dotTH);
	float dirAtten = smoothstep(-1.0, 0.0, dotTH);
	return dirAtten * pow(sinTH, exponent);
}
//沿着法线方向调整Tangent方向
vec3 ShiftTangent ( vec3 T, vec3 N, float shift)
{
	return normalize(T + shift * N);
}

void main()
{
	vec4 albedoColor = color;
	if(bool(albedousage)){
		albedoColor = texture2D(albedo,v_UV0)*color;
	}
	if(albedoColor.a<cut)
		discard;
    vec3 n = normalize(v_wN);
    if(bool(bumptexusage))
    {
        n = normalize(texture2D(bumptex, v_UV2).xyz *  2.0 - 1.0);
        n.xy *= bumpscale;
        mat3 v_wTBN = mat3(v_wT,v_wB,v_wN);
        n.z = sqrt(1.0-clamp(dot(n.xy, n.xy), 0.0, 1.0))*sign(n.z);
        n = normalize(v_wTBN * n);
    }
	float halfLambert = dot(n,v_wL)*0.49+0.5;
	vec4 diff = vec4(1.0,1.0,1.0,1.0);
	if(bool(ramptexusage)){
		diff = texture2D(ramptex,vec2(halfLambert,0.5));
	}
	float shiftval = 0.5;
	if(bool(anisotexusage)){
		shiftval = texture2D(anisotex, v_UV3).r;
	}
	//计算切线方向的偏移度
	vec3 t1 = ShiftTangent(v_wB, n, primaryshift + shiftval);
	vec3 t2 = ShiftTangent(v_wB, n, secondaryshift + shiftval);

	//计算高光强度
	vec3 wView = normalize(_CameraPos-v_wPos);
	vec3 spec1 = StrandSpecular(t1, wView, v_wL, specularmultiplier)* specularcolor.rgb;
	vec3 spec2 = StrandSpecular(t2, wView, v_wL, specularmultiplier2)* specularcolor2.rgb* specularcolor2.rgb;

	vec4 _spec =(vec4(spec1,0.0) + vec4(spec2,0.0))*halfLambert;
	gl_FragColor = albedoColor*diff*rampintensity+_spec;
	gl_FragColor.a = albedoColor.a;

}

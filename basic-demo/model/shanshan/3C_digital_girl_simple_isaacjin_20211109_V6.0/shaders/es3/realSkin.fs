#version 300 es
out highp vec4 out_fragColor; 
precision highp float;
uniform int albedousage;
uniform sampler2D albedo;
uniform int lookuptexusage;
uniform sampler2D lookuptex;
uniform int paramtexusage;
uniform sampler2D paramtex;
uniform int bumptexusage;
uniform sampler2D bumptex;
uniform float bumpscale;
uniform vec4 color;

uniform float roughness;
uniform float glossness;
uniform float scatter;

in vec2 v_UV;
in vec3 v_wT;
in vec3 v_wB;
in vec3 v_wN;
in vec3 v_wL;
in vec3 v_wView;  


float calSpecular(vec3 light,vec3 wView,vec3 wNormal,float r,float g){
	vec3 halfVec = normalize(wView+light);
	float nDotH = dot(halfVec,wNormal);
	// nDotH = clamp(nDotH,0.0,1.0)*0.99+0.005;
	// r = r*0.99+0.005;
	float PH=1.0;
	if(bool(lookuptexusage)){
		PH = pow( 2.0*texture(lookuptex,vec2(nDotH,r)).a, 10.0);				
	}
	float EdotH = dot(wView,halfVec);
	float exponential = pow(1.0 - EdotH, 5.0);
	float fresnelReflectance = exponential + 0.028 * (1.0 - exponential);  
	float frSpec = max( PH * fresnelReflectance / dot( halfVec, halfVec ), 0.0);  
	float _spec = dot(light,wNormal) * g * frSpec;
	return clamp(_spec,0.0,1.0);
}
void main()
{
	vec3 l1 = vec3(0.25,0.4,0.7);
	vec3 l2 = vec3(-0.5,0.1,0.1);
	vec3 l3 = normalize(vec3(-0.4,0.4,-0.7));
	vec4 lightColor1 = vec4(0.7,0.8,0.8,1.0);
	vec4 lightColor2 = vec4(0.3,0.3,0.2,1.0);
	vec4 lightColor3 = vec4(1.2,1.1,1.0,1.0);
	vec4 ambientColor = vec4(0.45,0.455,0.455,1.0);

	vec4 albedoColor = color;
	if(bool(albedousage)){
		albedoColor = texture(albedo,v_UV)*color;
	}
	vec3 n = normalize(v_wN);
    if(bool(bumptexusage))
    {
        n = normalize(texture(bumptex, v_UV).xyz *  2.0 - 1.0);
        n.xy *= bumpscale;
        mat3 v_wTBN = mat3(v_wT,v_wB,v_wN);
        n.z = sqrt(1.0-clamp(dot(n.xy, n.xy), 0.0, 1.0))*sign(n.z);
        n = normalize(v_wTBN * n);
    }
	vec4 param = vec4(1.0);
	if(bool(paramtexusage)){
		param = texture(paramtex,v_UV);
	}
	float g = glossness*param.r;
	float r =1.0- roughness*param.g;
	float s =1.0- scatter*param.b;
	float ao = param.a;
	
	float nDotL1 = dot(n,l1)*0.499+0.5;
	float nDotL2 = dot(n, l2)*0.499+0.5;
	float nDotL3 = dot(n, l3)*0.499+0.5;

	vec4 diff1 = vec4(1.0,1.0,1.0,1.0);
	vec4 diff2 = vec4(1.0,1.0,1.0,1.0);
	vec4 diff3 = vec4(1.0,1.0,1.0,1.0);	
	if(bool(lookuptexusage)){
		nDotL1 = clamp(nDotL1,0.0,1.0);
		nDotL2 = clamp(nDotL2,0.0,1.0);
		nDotL3 = clamp(nDotL3,0.0,1.0);	
		diff1 = texture(lookuptex,vec2(nDotL1,s));
		diff2 = texture(lookuptex,vec2(nDotL2,s));
		diff3 = texture(lookuptex,vec2(nDotL3,s));			
	}

	vec4 spec1 = calSpecular(l1,v_wView,n,r,g)*lightColor1;
	vec4 spec2 = calSpecular(l2,v_wView,n,r,g)*lightColor2;
	vec4 spec3 = calSpecular(l3,v_wView,n,r,g)*lightColor3;

	vec4 diff = diff1*lightColor1+diff2*lightColor2+diff3*lightColor3+ ambientColor;
	vec4 spec = spec1+spec2+spec3;
	vec4 col = (diff*albedoColor+spec)*ao;
	col = pow(col-vec4(0.1),vec4(0.6))- vec4(0.13,0.12,0.11,0.0);
	col = col*1.15;
	out_fragColor = col;
	out_fragColor.a= albedoColor.a;
}
#version 300 es
out highp vec4 out_fragColor;
precision highp float;
uniform vec4 lightcolor;
uniform vec3 lightdir;
uniform vec3 _CameraPos;
uniform vec4 ambientcolor;
uniform float ambientintensity;
uniform float externalstrength;
uniform vec4 color;
uniform int albedousage;
uniform sampler2D albedo;
uniform int aotexusage;
uniform sampler2D aotex;
uniform float metallic;
uniform int metallictexusage;
uniform sampler2D metallictex;
uniform float roughness;
uniform int envtexusage;
uniform samplerCube envtex;
uniform samplerCube envtex2;
uniform samplerCube envtex3;
uniform float envmix;
uniform int usearcubemap;
uniform float envintensity;
uniform float fresnelintensity;
uniform int albedoreplacetexusage;
uniform sampler2D albedoreplacetex;
uniform float _AlbedoReplaceTexRate;
uniform int emissivetexusage;
uniform sampler2D emissivetex;
uniform vec4 emissivecolor;
uniform float aointensity;
uniform vec3 consta;
uniform vec3 constb;
uniform vec3 constc;
uniform mat4 _M;
uniform mat4 _MIT;
in vec2 v_UV0;
in vec2 v_UV1;
in vec2 v_UV2;
in vec2 v_UV3;
in vec2 v_UV4;
in vec3 v_wPos;
in vec4 v_Col;
in vec3 v_wT;
in vec3 v_wB;
in vec3 v_wN;

void main()
{
    vec3 l = normalize(vec3(0.1,1.0,0.0));
    vec3 v = normalize(_CameraPos-v_wPos);
    vec3 n = normalize(v_wN);
    vec3 detailTex = vec3(1.0, 1.0, 1.0);
    if(bool(metallictexusage))
    {
     detailTex = texture(metallictex, v_UV1).xyz;
    }
    float m = metallic * detailTex.x;
    float r = roughness*detailTex.y;
    vec3 lColor = lightcolor.xyz;
    vec3 h =normalize(l+v);
    float a = r*r;
    float a2 = a*a;
    float nl = clamp(dot(n,l), 0.0, 1.0);
    float nl2 = dot(n,l)*0.5+0.5;
    float nv = clamp(dot(n,v), 0.0, 1.0);
    float nh = clamp(dot(n,h), 0.0, 1.0);
    float lh = clamp(dot(l,h), 0.0, 1.0);

    vec4 albedoColor = color;
    if(bool(albedousage)){
        albedoColor = color*texture(albedo,v_UV0);
    }
    vec4 _ColorSpaceDielectricSpec = vec4(0.16, 0.16, 0.16, 0.779);
    float  OneMinusReflectivity = _ColorSpaceDielectricSpec.a - m * _ColorSpaceDielectricSpec.a;
    vec3  diffColor = albedoColor.xyz *OneMinusReflectivity;

    vec3 diff = mix(ambientcolor.rgb,lightcolor.xyz*1.2,nl2)*diffColor;
    vec3 specColor = mix(_ColorSpaceDielectricSpec.rgb,albedoColor.xyz,m);
    float gv = nl * (a + nv * (1.0 - a));
    float gl = nv * (a + nl * (1.0 - a));
    float t = nh*nh*(a2-1.0)+1.0;
    float f = exp2((-5.55473*lh-6.98316)*lh);

    float D = 0.31831*a2/(t*t + 1e-6);
    float G = 0.5/(gv+gl + 1e-5);
    vec3 F = specColor +(1.0-specColor)*f;
    vec3 facet = D*F*G;
    facet = sqrt(facet);
    facet = clamp(facet,0.0,1.0);
    vec3 spec = nl*facet*lightcolor.xyz;
    float grazing = clamp(1.0 - r + 1.0 - OneMinusReflectivity,0.0,1.0);
    vec3 specular_Environment = mix(specColor,vec3(grazing),(1.0-nv)*(1.0-nv)*(1.0-nv)*nl2);
    vec3 nrv = normalize(reflect(-v, n));
   
    if(bool(usearcubemap)){
        vec3 worldray = normalize(vec4(nrv,0.0)*_M).xyz;
        vec3 wolrdpos = (vec4(v_wPos,1.0)*_MIT).xyz;
        vec3 enva = (consta - wolrdpos)/worldray;
        vec3 envb = (constb - wolrdpos)/worldray;
        vec3 envc = envb;
        if(worldray.x > 0.0){
            envc.x = enva.x;
        }
        if(worldray.y > 0.0){
            envc.y = enva.y;
        }
        if(worldray.z > 0.0){
            envc.z = enva.z;
        }
        float envf = min(envc.x,min(envc.y,envc.z));
        vec3 envd = wolrdpos+worldray*envf;
        vec3 enve = envd - constc;
        nrv = enve;
        nrv.z = -nrv.z;
    }
    
    vec3 env = vec3(0.5,0.5,0.5);
    if(bool(envtexusage))
    {
        ivec2 envSize = textureSize(envtex,0);
        float maxMIPLevelScalar = log2(float(envSize.y));
        maxMIPLevelScalar = max(8.0,maxMIPLevelScalar);
        float blinnShininess = 2.0/a-2.0;
        float desiredMIPLevel = maxMIPLevelScalar + 0.79248 - 0.5 * log2( blinnShininess*blinnShininess + 1.0 );
        float mipLevel = clamp( desiredMIPLevel, 0.0, maxMIPLevelScalar);
        
        env = textureLod(envtex, nrv,mipLevel).rgb;
        
        envSize = textureSize(envtex2,0);
        float diffLevel = maxMIPLevelScalar - log2(float(envSize.y));
        float mipLevel2 =max(mipLevel-diffLevel,0.0);
        vec3 env2 = textureLod(envtex2, nrv,mipLevel2).rgb;
        env = mix(env,env2,envmix);
        
        if(bool(usearcubemap)){
            env = pow(env,vec3(0.455));
        }
    
        envSize = textureSize(envtex3,0);
        diffLevel = maxMIPLevelScalar - log2(float(envSize.y));
        float mipLevel3 =max(mipLevel-diffLevel,0.0);
        vec3 env3 = textureLod(envtex3, nrv,mipLevel3).rgb;
        env = mix(env,env3,vec3(clamp(nrv.y+0.5,0.0,1.0)));
    }
    
    env = env*envintensity*specular_Environment;
    vec3 amb = ambientcolor.xyz*diffColor*0.3183;

    vec3 AO = v_Col.rgb;
    if(bool(aotexusage))
    {
        AO = mix(vec3(1.0),AO*texture(aotex, v_UV2).rgb,aointensity);
    }
    AO = pow( vec3(nv) + AO, vec3(exp2( - 16.0 * r - 1.0 ))) - 1.0 + AO;
    AO = clamp(AO,vec3(0.0),vec3(1.0));
    amb *= AO;
    diff *= AO;
    env *= AO;
    vec3 emis = vec3(0.0);
    if (bool(emissivetexusage)){
        emis = emissivecolor.rgb*texture(emissivetex,v_UV3).rgb;
    }
    out_fragColor.rgb = (diff + spec + env + amb+ emis)*ambientintensity*clamp(externalstrength,0.4,1.0);
    out_fragColor.a = albedoColor.a;
}

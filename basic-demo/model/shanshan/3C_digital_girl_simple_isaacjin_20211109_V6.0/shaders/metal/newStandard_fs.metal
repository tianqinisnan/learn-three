using namespace metal;
struct xlatMtlShaderInput {
  float2 v_UV0;
  float2 v_UV1;
  float2 v_UV2;
  float2 v_UV3;
  float3 v_wPos;
  float4 v_Col;
  float3 v_wN;
};
struct xlatMtlShaderOutput {
  float4 gl_FragColor;
};
struct xlatMtlShaderUniform {
  float4 lightcolor;
  float3 _CameraPos;
  float4 ambientcolor;
  float ambientintensity;
  float externalstrength;
  float4 color;
  int albedousage;
  int aotexusage;
  float metallic;
  int metallictexusage;
  float roughness;
  int envtexusage;
  float envmix;
  int usearcubemap;
  float envintensity;
  int emissivetexusage;
  float4 emissivecolor;
  float aointensity;
  float3 consta;
  float3 constb;
  float3 constc;
  float4x4 _M;
  float4x4 _MIT;
  int usemixarkitenv;
};
fragment xlatMtlShaderOutput newStandard_fs (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(1)]]
  ,   texture2d<float> albedo [[texture(0)]], sampler _mtlsmp_albedo [[sampler(0)]]
  ,   texture2d<float> aotex [[texture(1)]], sampler _mtlsmp_aotex [[sampler(1)]]
  ,   texture2d<float> metallictex [[texture(2)]], sampler _mtlsmp_metallictex [[sampler(2)]]
  ,   texturecube<float> envtex [[texture(3)]], sampler _mtlsmp_envtex [[sampler(3)]]
  ,   texturecube<float> envtex2 [[texture(4)]], sampler _mtlsmp_envtex2 [[sampler(4)]]
  ,   texturecube<float> envtex3 [[texture(5)]], sampler _mtlsmp_envtex3 [[sampler(5)]]
  ,   texture2d<float> emissivetex [[texture(6)]], sampler _mtlsmp_emissivetex [[sampler(6)]])
{
  xlatMtlShaderOutput _mtl_o;
  float3 emis_1;
  float3 AO_2;
  float3 amb_3;
  float3 env_4;
  float3 nrv_5;
  float3 diff_6;
  float4 albedoColor_7;
  float3 detailTex_8;
  float3 tmpvar_9;
  tmpvar_9 = normalize((_mtl_u._CameraPos - _mtl_i.v_wPos));
  float3 tmpvar_10;
  tmpvar_10 = normalize(_mtl_i.v_wN);
  detailTex_8 = float3(float3(1.0, 1.0, 1.0));
  if (bool(_mtl_u.metallictexusage)) {
    detailTex_8 = metallictex.sample(_mtlsmp_metallictex, (float2)(_mtl_i.v_UV1)).xyz;
  };
  float tmpvar_11;
  tmpvar_11 = ((float)(_mtl_u.metallic * (float)detailTex_8.x));
  float tmpvar_12;
  tmpvar_12 = ((float)(_mtl_u.roughness * (float)detailTex_8.y));
  float3 tmpvar_13;
  tmpvar_13 = normalize((float3(0.09950372, 0.9950371, 0.0) + tmpvar_9));
  float tmpvar_14;
  tmpvar_14 = (tmpvar_12 * tmpvar_12);
  float tmpvar_15;
  tmpvar_15 = (tmpvar_14 * tmpvar_14);
  float tmpvar_16;
  tmpvar_16 = clamp (dot (tmpvar_10, float3(0.09950372, 0.9950371, 0.0)), 0.0, 1.0);
  float tmpvar_17;
  tmpvar_17 = ((dot (tmpvar_10, float3(0.09950372, 0.9950371, 0.0)) * 0.5) + 0.5);
  float tmpvar_18;
  tmpvar_18 = clamp (dot (tmpvar_10, tmpvar_9), 0.0, 1.0);
  float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_10, tmpvar_13), 0.0, 1.0);
  float tmpvar_20;
  tmpvar_20 = clamp (dot (float3(0.09950372, 0.9950371, 0.0), tmpvar_13), 0.0, 1.0);
  float4 tmpvar_21;
  tmpvar_21 = float4(_mtl_u.color);
  albedoColor_7 = tmpvar_21;
  if (bool(_mtl_u.albedousage)) {
    albedoColor_7 = ((float4)(_mtl_u.color * (float4)albedo.sample(_mtlsmp_albedo, (float2)(_mtl_i.v_UV0))));
  };
  float tmpvar_22;
  tmpvar_22 = ((float)0.779 - (tmpvar_11 * (float)0.779));
  float3 tmpvar_23;
  tmpvar_23 = (albedoColor_7.xyz * tmpvar_22);
  float3 tmpvar_24;
  tmpvar_24 = mix (_mtl_u.ambientcolor.xyz, _mtl_u.lightcolor.xyz*1.2, tmpvar_17);
  float3 tmpvar_25;
  tmpvar_25 = ((float3)(tmpvar_24 * (float3)tmpvar_23));
  diff_6 = tmpvar_25;
  float3 tmpvar_26;
  tmpvar_26 = mix ((float3)float3(0.16, 0.16, 0.16), albedoColor_7.xyz, tmpvar_11);
  float tmpvar_27;
  tmpvar_27 = (((float)((tmpvar_19 * tmpvar_19) * (float)(tmpvar_15 - (float)1.0))) + (float)1.0);
  float tmpvar_28;
  tmpvar_28 = exp2(((
    (-5.55473 * tmpvar_20)
   - 6.98316) * tmpvar_20));
  float3 tmpvar_29;
  tmpvar_29 = ((float3)((float3)((float3)(tmpvar_16 * (float3)clamp (
    sqrt((((
      ((float)0.31831 * tmpvar_15)
     /
      ((tmpvar_27 * tmpvar_27) + (float)1e-06)
    ) * (tmpvar_26 +
      ((float3)((float3)((float)1.0 - tmpvar_26) * tmpvar_28))
    )) * ((float)0.5 / (
      (((float)(tmpvar_16 * (float)(tmpvar_14 + ((float)(tmpvar_18 * (float)
        ((float)1.0 - tmpvar_14)
      ))))) + ((float)(tmpvar_18 * (float)(tmpvar_14 + ((float)(tmpvar_16 * (float)
        ((float)1.0 - tmpvar_14)
      ))))))
     + (float)1e-05))))
  , (float)0.0, (float)1.0))) * _mtl_u.lightcolor.xyz));
  float3 tmpvar_30;
  float a_31;
  a_31 = (((
    (1.0 - tmpvar_18)
   *
    (1.0 - tmpvar_18)
  ) * (1.0 - tmpvar_18)) * tmpvar_17);
  tmpvar_30 = ((float3)mix ((float3)tmpvar_26, (float3)float3(clamp ((
    (((float)1.0 - tmpvar_12) + (float)1.0)
   - tmpvar_22), (float)0.0, (float)1.0)), a_31));
  float3 I_32;
  I_32 = -(tmpvar_9);
  float3 tmpvar_33;
  tmpvar_33 = normalize((I_32 - (2.0 *
    (dot (tmpvar_10, I_32) * tmpvar_10)
  )));
  nrv_5 = tmpvar_33;
  if (bool(_mtl_u.usearcubemap)) {
    float3 envc_34;
    float4 tmpvar_35;
    tmpvar_35.w = 0.0;
    tmpvar_35.xyz = tmpvar_33;
    float4 tmpvar_36;
    tmpvar_36 = normalize((tmpvar_35 * _mtl_u._M));
    float4 tmpvar_37;
    tmpvar_37.w = 1.0;
    tmpvar_37.xyz = _mtl_i.v_wPos;
    float3 tmpvar_38;
    tmpvar_38 = (tmpvar_37 * _mtl_u._MIT).xyz;
    float3 tmpvar_39;
    tmpvar_39 = ((_mtl_u.consta - tmpvar_38) / tmpvar_36.xyz);
    envc_34 = ((_mtl_u.constb - tmpvar_38) / tmpvar_36.xyz);
    if ((tmpvar_36.x > 0.0)) {
      envc_34.x = tmpvar_39.x;
    };
    if ((tmpvar_36.y > 0.0)) {
      envc_34.y = tmpvar_39.y;
    };
    if ((tmpvar_36.z > 0.0)) {
      envc_34.z = tmpvar_39.z;
    };
    float3 tmpvar_40;
    tmpvar_40 = ((tmpvar_38 + (tmpvar_36.xyz *
      min (envc_34.x, min (envc_34.y, envc_34.z))
    )) - _mtl_u.constc);
    nrv_5.xy = tmpvar_40.xy;
    nrv_5.z = -(tmpvar_40.z);
  };
    
    float envLevel = float(envtex.get_num_mip_levels());
    float maxMipLevel = max(envLevel,8.0);
    float blinnShininess = 2.0/tmpvar_14-2.0;
    float desiredMipLevel = maxMipLevel+ 0.79248 - 0.5 * log2 (blinnShininess*blinnShininess+1.0);
    float mipLevel = clamp(desiredMipLevel,0.0,maxMipLevel);

    env_4 = float3(float3(0.5, 0.5, 0.5));
    if (bool(_mtl_u.envtexusage)) {
        float diffLevel = maxMipLevel - envLevel;
        float roughLevel = max(mipLevel - diffLevel,0.0);
        env_4 = envtex.sample(_mtlsmp_envtex, (float3)(nrv_5),level(roughLevel)).xyz;
          
        diffLevel = maxMipLevel - float(envtex2.get_num_mip_levels());
        roughLevel = max(mipLevel - diffLevel,0.0);
        float3 env2Col = envtex2.sample(_mtlsmp_envtex2, (float3)(nrv_5),level(roughLevel)).xyz;
        env_4 = mix(env_4,env2Col,_mtl_u.envmix);
        if (bool(_mtl_u.usearcubemap)) {
            env_4 = pow (env_4, (float3)float3(0.455, 0.455, 0.455));
        };
        diffLevel = maxMipLevel - float(envtex3.get_num_mip_levels());
        roughLevel = max(mipLevel - diffLevel,0.0);
        float3 env3_4 = envtex3.sample(_mtlsmp_envtex3, (float3)(tmpvar_33),level(roughLevel)).xyz;
        if(bool(_mtl_u.usemixarkitenv)){
            env_4 = mix(env_4,env3_4,clamp(nrv_5.y+0.5,0.0,1.0));
        }else{
          env_4 = env3_4;
        }
    };
    
  env_4 = (((float3)((float3)env_4 * _mtl_u.envintensity)) * tmpvar_30);
  float3 tmpvar_42;
  tmpvar_42 = (((float3)(_mtl_u.ambientcolor.xyz * (float3)tmpvar_23)) * (float)0.3183);
  amb_3 = tmpvar_42;
  float3 tmpvar_43;
  tmpvar_43 = float3(_mtl_i.v_Col.xyz);
  AO_2 = tmpvar_43;
  if (bool(_mtl_u.aotexusage)) {
    AO_2 = ((float3)mix (float3(1.0, 1.0, 1.0), (float3)(tmpvar_43 * aotex.sample(_mtlsmp_aotex, (float2)(_mtl_i.v_UV2)).xyz), _mtl_u.aointensity));
  };
  AO_2 = ((pow (
    ((float3)(float3(tmpvar_18) + (float3)AO_2))
  , float3(
    exp2((((float)-16.0 * tmpvar_12) - (float)1.0))
  )) - (float)1.0) + AO_2);
  float3 tmpvar_44;
  tmpvar_44 = clamp (AO_2, (float3)float3(0.0, 0.0, 0.0), (float3)float3(1.0, 1.0, 1.0));
  AO_2 = tmpvar_44;
  amb_3 = (tmpvar_42 * tmpvar_44);
  diff_6 = (tmpvar_25 * tmpvar_44);
  env_4 = (env_4 * tmpvar_44);
  emis_1 = float3(float3(0.0, 0.0, 0.0));
  if (bool(_mtl_u.emissivetexusage)) {
    emis_1 = ((float3)(_mtl_u.emissivecolor.xyz * (float3)emissivetex.sample(_mtlsmp_emissivetex, (float2)(_mtl_i.v_UV3)).xyz));
  };
  float tmpvar_45;
  tmpvar_45 = clamp (_mtl_u.externalstrength, 0.4, 1.0);
  _mtl_o.gl_FragColor.xyz = float3(((float3)((float3)((float3)((float3)(
    (diff_6 + tmpvar_29)
   +
    ((env_4 + amb_3) + emis_1)
  ) * _mtl_u.ambientintensity)) * tmpvar_45)));
  _mtl_o.gl_FragColor.w = float(albedoColor_7.w);
  return _mtl_o;
}

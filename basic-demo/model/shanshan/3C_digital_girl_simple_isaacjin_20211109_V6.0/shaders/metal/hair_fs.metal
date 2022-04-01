using namespace metal;
struct xlatMtlShaderInput {
  float2 v_UV0;
  float2 v_UV2;
  float2 v_UV3;
  float3 v_wL;
  float3 v_wT;
  float3 v_wB;
  float3 v_wN;
  float3 v_wPos;
};
struct xlatMtlShaderOutput {
  float4 gl_FragColor;
};
struct xlatMtlShaderUniform {
  int albedousage;
  int ramptexusage;
  float rampintensity;
  int anisotexusage;
  int bumptexusage;
  float bumpscale;
  float4 color;
  float3 _CameraPos;
  float4 specularcolor;
  float4 specularcolor2;
  float primaryshift;
  float secondaryshift;
  float specularmultiplier;
  float specularmultiplier2;
};
fragment xlatMtlShaderOutput hair_fs (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(1)]]
  ,   texture2d<float> albedo [[texture(0)]], sampler _mtlsmp_albedo [[sampler(0)]]
  ,   texture2d<float> ramptex [[texture(1)]], sampler _mtlsmp_ramptex [[sampler(1)]]
  ,   texture2d<float> anisotex [[texture(2)]], sampler _mtlsmp_anisotex [[sampler(2)]]
  ,   texture2d<float> bumptex [[texture(3)]], sampler _mtlsmp_bumptex [[sampler(3)]])
{
  xlatMtlShaderOutput _mtl_o;
  float shiftval_1;
  float4 diff_2;
  float3 n_3;
  float4 albedoColor_4;
  float4 tmpvar_5;
  tmpvar_5 = float4(_mtl_u.color);
  albedoColor_4 = tmpvar_5;
  if (bool(_mtl_u.albedousage)) {
    albedoColor_4 = ((float4)((float4)albedo.sample(_mtlsmp_albedo, (float2)(_mtl_i.v_UV0)) * _mtl_u.color));
  };
  float3 tmpvar_6;
  tmpvar_6 = float3(normalize(_mtl_i.v_wN));
  n_3 = tmpvar_6;
  if (bool(_mtl_u.bumptexusage)) {
    float3 tmpvar_7;
    tmpvar_7 = normalize(((bumptex.sample(_mtlsmp_bumptex, (float2)(_mtl_i.v_UV2)).xyz * (float)2.0) - (float)1.0));
    n_3.z = tmpvar_7.z;
    n_3.xy = ((float2)((float2)tmpvar_7.xy * _mtl_u.bumpscale));
    float3x3 tmpvar_8;
    tmpvar_8[0] = _mtl_i.v_wT;
    tmpvar_8[1] = _mtl_i.v_wB;
    tmpvar_8[2] = _mtl_i.v_wN;
    n_3.z = (sqrt(((float)1.0 - 
      clamp (dot (n_3.xy, n_3.xy), (float)0.0, (float)1.0)
    )) * sign(tmpvar_7.z));
    n_3 = normalize(((float3)(tmpvar_8 * (float3)n_3)));
  };
  float tmpvar_9;
  tmpvar_9 = ((((float)dot ((float3)n_3, _mtl_i.v_wL)) * (float)0.49) + (float)0.5);
  diff_2 = float4(float4(1.0, 1.0, 1.0, 1.0));
  if (bool(_mtl_u.ramptexusage)) {
    float2 tmpvar_10;
    tmpvar_10.y = float(0.5);
    tmpvar_10.x = tmpvar_9;
    diff_2 = ramptex.sample(_mtlsmp_ramptex, (float2)(tmpvar_10));
  };
  shiftval_1 = float(0.5);
  if (bool(_mtl_u.anisotexusage)) {
    shiftval_1 = anisotex.sample(_mtlsmp_anisotex, (float2)(_mtl_i.v_UV3)).x;
  };
  float3 tmpvar_11;
  tmpvar_11 = normalize((_mtl_u._CameraPos - _mtl_i.v_wPos));
  float3 tmpvar_12;
  tmpvar_12 = normalize((_mtl_i.v_wL + tmpvar_11));
  float tmpvar_13;
  tmpvar_13 = ((float)dot ((float3)normalize(((float3)(_mtl_i.v_wB + (float3)
    (((float)(_mtl_u.primaryshift + (float)shiftval_1)) * n_3)
  ))), tmpvar_12));
  float tmpvar_14;
  tmpvar_14 = clamp ((tmpvar_13 - (float)-1.0), (float)0.0, (float)1.0);
  float3 tmpvar_15;
  tmpvar_15 = normalize((_mtl_i.v_wL + tmpvar_11));
  float tmpvar_16;
  tmpvar_16 = ((float)dot ((float3)normalize(((float3)(_mtl_i.v_wB + (float3)
    (((float)(_mtl_u.secondaryshift + (float)shiftval_1)) * n_3)
  ))), tmpvar_15));
  float tmpvar_17;
  tmpvar_17 = clamp ((tmpvar_16 - (float)-1.0), (float)0.0, (float)1.0);
  float4 tmpvar_18;
  tmpvar_18.w = float(0.0);
  tmpvar_18.xyz = ((float3)((float)((tmpvar_14 * 
    (tmpvar_14 * ((float)3.0 - ((float)2.0 * tmpvar_14)))
  ) * ((float)pow ((float)
    sqrt(((float)1.0 - (tmpvar_13 * tmpvar_13)))
  , _mtl_u.specularmultiplier))) * _mtl_u.specularcolor.xyz));
  float4 tmpvar_19;
  tmpvar_19.w = float(0.0);
  tmpvar_19.xyz = ((float3)((float3)((float3)((float)(
    (tmpvar_17 * (tmpvar_17 * ((float)3.0 - ((float)2.0 * tmpvar_17))))
   * 
    ((float)pow ((float)sqrt(((float)1.0 - (tmpvar_16 * tmpvar_16))), _mtl_u.specularmultiplier2))
  ) * _mtl_u.specularcolor2.xyz)) * _mtl_u.specularcolor2.xyz));
  float4 tmpvar_20;
  tmpvar_20 = ((tmpvar_18 + tmpvar_19) * tmpvar_9);
  _mtl_o.gl_FragColor.xyz = float3((((float4)((float4)(albedoColor_4 * diff_2) * _mtl_u.rampintensity)) + tmpvar_20).xyz);
  _mtl_o.gl_FragColor.w = float(albedoColor_4.w);
  return _mtl_o;
}
#pragma once

#ifndef REARCHIVING_Input_SimpleToonShaderRemake_INCLUDED
#define REARCHIVING_Input_SimpleToonShaderRemake_INCLUDED

// ------------------------------------------------------------
// Shader Input
// ------------------------------------------------------------
struct appdata {
    float4 vertex: POSITION;
    float3 normal : NORMAL;
    float4 tangent : TANGENT;
    float2 uv: TEXCOORD0;
};

struct v2f {
    float4 positionCS: SV_POSITION;
    float2 uv: TEXCOORD0;
    float4 worldPosWithFog : TEXCOORD1;
    float3 worldNormalDir : TEXCOORD2;
};

// ------------------------------------------------------------
// Global Variables
// ------------------------------------------------------------
struct SimpleToonObjectData {
    float3 worldPos;
    float3 worldNormalDir;
    float3 worldViewDir;
};

struct SimpleToonSurfaceData {
    float3 light_albedo;
    float3 dark_albedo;
    float alpha; // for now, just use light albedo's alpha
    float occlusion;
};


// ------------------------------------------------------------
// Sampler and Texture
// ------------------------------------------------------------
TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);
TEXTURE2D(_MainTexDark);
SAMPLER(sampler_MainTexDark);
TEXTURE2D(_BumpMap);
SAMPLER(sampler_BumpMap);


// ------------------------------------------------------------
// Properties
// ------------------------------------------------------------
CBUFFER_START(UnityPerMaterial)

float4 _MainTex_ST;
half4 _MainColor;
half4 _ReceiveShadowMappingColor;// MainColorDark
half _ReceiveShadowMappingAmount;
half _ReceiveShadowMappingOffset;
half _CelShadowMidPoint;
half _CelShadowWidth;

half _BumpMapStrength;


half _OutlineWidth;
half4 _OutlineColor;

half _IsFace;

CBUFFER_END

#endif

#pragma once

#ifndef REARCHIVING_Input_SimpleToonShaderRemake_INCLUDED
#define REARCHIVING_Input_SimpleToonShaderRemake_INCLUDED

// ------------------------------------------------------------
// Shader Input
// ------------------------------------------------------------
struct appdata {
    float4 vertex: POSITION;
    float3 normal : NORMAL;
    float2 uv: TEXCOORD0;
};

struct v2f {
    float4 vertex: SV_POSITION;
    float2 uv: TEXCOORD0;
    float4 worldPos : TEXCOORD1;
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
    float3 albedo;
    float alpha;
};


// ------------------------------------------------------------
// Sampler and Texture
// ------------------------------------------------------------
TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);


// ------------------------------------------------------------
// Properties
// ------------------------------------------------------------
CBUFFER_START(UnityPerMaterial)
float4 _MainTex_ST;
half4 _MainColor;

half _OutlineWidth;
half4 _OutlineColor;

half _IsFace;

half _CelShadowMidPoint;
half _CelShadowWidth;

half _ReceiveShadowMappingAmount;
half _ReceiveShadowMappingOffset;
half4 _ReceiveShadowMappingColor;

CBUFFER_END

#endif

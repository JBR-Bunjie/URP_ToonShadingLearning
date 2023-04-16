#pragma once

#ifndef REARCHIVING_SharedFunctions_SimpleToonShaderRemake_INCLUDED
#define REARCHIVING_SharedFunctions_SimpleToonShaderRemake_INCLUDED

// URP Packages
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

// Custom HLSL
#include "Input_SimpleToonShaderRemake.hlsl"


// ------------------------------------------------------------
// Init Functions
// ------------------------------------------------------------
SimpleToonObjectData InitSimpleToonObjectData(v2f i) {
    SimpleToonObjectData simpleToonObjectData;

    simpleToonObjectData.worldPos = i.worldPosWithFog.xyz;
    simpleToonObjectData.worldNormalDir = normalize(i.worldNormalDir);
    simpleToonObjectData.worldViewDir = normalize(GetCameraPositionWS() - i.worldPosWithFog.xyz);

    return simpleToonObjectData;
}

SimpleToonSurfaceData InitSimpleToonSurfaceData(v2f i) {
    SimpleToonSurfaceData simpleToonSurfaceData;

    simpleToonSurfaceData.light_albedo = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv).rgb * _MainColor.rgb;
    simpleToonSurfaceData.dark_albedo = SAMPLE_TEXTURE2D(_MainTexDark, sampler_MainTexDark, i.uv).rgb *
        _ReceiveShadowMappingColor.rgb;

    simpleToonSurfaceData.alpha = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv).a * _MainColor.a;
    
    simpleToonSurfaceData.occlusion = 1;

    return simpleToonSurfaceData;
}


// ------------------------------------------------------------
// Shading Contribution Calculating Functions
// ------------------------------------------------------------
half3 ShadeSingleLight(Light light, SimpleToonSurfaceData simpleToonSurfaceData,
                       SimpleToonObjectData simpleToonObjectData, bool isAdditionalLight = false) {
    // Step-Diffuse for every single light
    half NdotL = dot(simpleToonObjectData.worldNormalDir, light.direction);
    // Do the value cut
    half diffuseControl = smoothstep(_CelShadowMidPoint - _CelShadowWidth, _CelShadowMidPoint + _CelShadowWidth, NdotL);
    
    // add occlusion
    // diffuseControl = lerp(0, diffuseControl, simpleToonSurfaceData.occlusion);
    // add face-ignoring
    diffuseControl = _IsFace ? lerp(0.5, 1, diffuseControl) : diffuseControl;
    // add light's shadow to result
    diffuseControl *= lerp(1, light.shadowAttenuation, _ReceiveShadowMappingAmount);

    // 
    half3 color = lerp(simpleToonSurfaceData.dark_albedo.rgb, simpleToonSurfaceData.light_albedo.rgb, diffuseControl);
    
    half distanceAttention = min(4, light.distanceAttenuation);
    color = color * distanceAttention;
    
    color = color * saturate(light.color) * (isAdditionalLight ? 0.25 : 1);
    // half3 diffuse = simpleToonSurfaceData.albedo * diffuseControl * distanceAttention;
    return color;
}

void DoClipTestToTargetAlphaTest(float i) {
    clip(i - 0.5);
}

#endif

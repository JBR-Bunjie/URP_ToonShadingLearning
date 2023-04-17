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

half3 TransformPositionWSToOutlinePositionWS (float3 worldPos, float3 viewPos, float3 worldNormalDir) {
    // https://stackoverflow.com/questions/44491379/accessing-members-of-a-matrix-in-hlsl
    float fovCot = unity_CameraProjection._m11;

    float fov = atan(1.0 / fovCot) * 2.0 * (180 / 3.1415);

    // float vSZClamp = clamp(abs(viewPos.z), 0, 1) * fov;
    float vSZClamp = saturate(abs(viewPos.z)) * fov;

    float outlineExpandAmount = vSZClamp * 0.0005 * _OutlineWidth;
    
    return worldPos + worldNormalDir * outlineExpandAmount;
}

#endif

#pragma once

#ifndef REARCHIVING_SharedFunctions_SimpleToonShaderRemake_INCLUDED
#define REARCHIVING_SharedFunctions_SimpleToonShaderRemake_INCLUDED

// URP
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"


// Custom HLSL
#include "Assets/ReArchiving/Include/SimpleToonShaderRemake_R/Input_SimpleToonShaderRemake.hlsl"

SimpleToonObjectData InitSimpleToonObjectData (v2f i) {
    SimpleToonObjectData simpleToonObjectData;

    simpleToonObjectData.worldPos = i.worldPos.xyz;
    simpleToonObjectData.worldNormalDir = normalize(i.worldNormalDir);
    simpleToonObjectData.worldViewDir = normalize(GetCameraPositionWS() - i.worldPos.xyz);

    return simpleToonObjectData;
}

SimpleToonSurfaceData InitSimpleToonSurfaceData (v2f i) {
    SimpleToonSurfaceData simpleToonSurfaceData;

    half4 base = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv) * _MainColor;
    simpleToonSurfaceData.albedo = base.rgb;
    simpleToonSurfaceData.alpha = base.a;

    return simpleToonSurfaceData;
}

half3 ShadeSingleLight(Light light, SimpleToonSurfaceData simpleToonSurfaceData,
                       SimpleToonObjectData simpleToonObjectData, bool isAdditionalLight = false) {
    // Cel-Diffuse for every single light
    // basic diffuse part
    half distanceAttention = min(4, light.distanceAttenuation);
    half NdotL = dot(simpleToonObjectData.worldNormalDir, normalize(light.direction));

    half diffuseControl = smoothstep(_CelShadowMidPoint - _CelShadowWidth, _CelShadowMidPoint + _CelShadowWidth, NdotL);
    

    // add occlusion
    // add face-ignoring
    diffuseControl = _IsFace ? diffuseControl : 1;
    
    // add light's shadow to result
    diffuseControl *= lerp(1, light.shadowAttenuation, _ReceiveShadowMappingAmount);
    half3 color = lerp(_ReceiveShadowMappingColor, 1, diffuseControl);
    color = color * distanceAttention;
    
    // half3 diffuse = simpleToonSurfaceData.albedo * diffuseControl * distanceAttention;
    return color * saturate(light.color) * (isAdditionalLight ? 0.25 : 1);
}

// Functions
v2f vert(appdata v) {
    v2f o;
    VertexPositionInputs vertexPos = GetVertexPositionInputs(v.vertex.xyz);
    VertexNormalInputs vertexNormal = GetVertexNormalInputs(v.normal);
    
    o.vertex = vertexPos.positionCS;
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.worldNormalDir = TransformObjectToWorldNormal(vertexNormal.normalWS);
    o.worldPos.xyz = vertexPos.positionWS;

    return o;
}

half4 frag(v2f i): SV_Target {
    SimpleToonObjectData simpleToonObjectData = InitSimpleToonObjectData(i);

    SimpleToonSurfaceData simpleToonSurfaceData = InitSimpleToonSurfaceData(i);

    half3 mainLightResult = 0;
    Light mainLight = GetMainLight();
    float3 shadowCoordWorldPos = i.worldPos.xyz + mainLight.direction * (_IsFace);

    #ifdef _MAIN_LIGHT_SHADOWS
        half4 shadowCoord = TransformWorldToShadowCoord(shadowCoordWorldPos);
        mainLight.shadowAttenuation = MainLightRealtimeShadow(shadowCoord);
    #endif
    mainLightResult = ShadeSingleLight(mainLight, simpleToonSurfaceData, simpleToonObjectData);

    half3 additionLightSumResult = 0;
    #ifdef _ADDITIONAL_LIGHTS
    half lightCount = GetAdditionalLightsCount();
    for (int it = 0; it < lightCount; it++) {
        int perObjectLightIndex = GetPerObjectLightIndex(it);
        Light additionalLight = GetAdditionalLight(perObjectLightIndex, simpleToonObjectData.worldPos);
        // attention here:
        // In `AdditionalLightRealtimeShadow` function, we use "shadowCoordWorldPos" rather than shadowCoord
        additionalLight.shadowAttenuation = AdditionalLightRealtimeShadow(perObjectLightIndex, shadowCoordWorldPos);
        
        additionLightSumResult += ShadeSingleLight(additionalLight, simpleToonSurfaceData, simpleToonObjectData, true);
    }
    #endif
    
    return half4((mainLightResult + additionLightSumResult) * simpleToonSurfaceData.albedo, simpleToonSurfaceData.alpha);
}

#endif

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

    simpleToonObjectData.worldPos = i.worldPosWithFog.xyz;
    simpleToonObjectData.worldNormalDir = normalize(i.worldNormalDir);
    simpleToonObjectData.worldViewDir = normalize(GetCameraPositionWS() - i.worldPosWithFog.xyz);

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
    half NdotL = dot(simpleToonObjectData.worldNormalDir, light.direction);

    half diffuseControl = smoothstep(_CelShadowMidPoint - _CelShadowWidth, _CelShadowMidPoint + _CelShadowWidth, NdotL);
    

    // add occlusion
    // add face-ignoring
    diffuseControl = _IsFace ? lerp(0.5, 1, diffuseControl) : diffuseControl;
    
    // add light's shadow to result
    diffuseControl *= lerp(1, light.shadowAttenuation, _ReceiveShadowMappingAmount);
    half3 color = lerp(_ReceiveShadowMappingColor, 1, diffuseControl);
    color = color * distanceAttention;
    color = color * saturate(light.color) * (isAdditionalLight ? 0.25 : 1);
    // half3 diffuse = simpleToonSurfaceData.albedo * diffuseControl * distanceAttention;
    return color;
}

// Functions
v2f vert(appdata v) {
    v2f o;
    VertexPositionInputs vertexPos = GetVertexPositionInputs(v.vertex.xyz);
    // VertexNormalInputs vertexNormal = GetVertexNormalInputs(v.normal);
    VertexNormalInputs vertexNormal = GetVertexNormalInputs(v.normal, v.tangent);
    
    o.vertex = vertexPos.positionCS;
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.worldNormalDir = vertexNormal.normalWS;
    o.worldPosWithFog.xyz = vertexPos.positionWS;

    o.worldPosWithFog.w = ComputeFogFactor(vertexPos.positionCS);

    return o;
}

half4 frag(v2f i): SV_Target {
    SimpleToonObjectData simpleToonObjectData = InitSimpleToonObjectData(i);

    SimpleToonSurfaceData simpleToonSurfaceData = InitSimpleToonSurfaceData(i);


    // half3 averageSH = SampleSH(0);
    //
    // // can prevent result becomes completely black if lightprobe was not baked 
    // averageSH = max(_IndirectLightMinColor, averageSH);
    //
    // // occlusion (maximum 50% darken for indirect to prevent result becomes completely black)
    // half indirectOcclusion = lerp(1, simpleToonSurfaceData.occlusion, 0.5);
    // half3 indirectionalLight = averageSH * indirectOcclusion;

    
    half3 mainLightResult = 0;
    Light mainLight = GetMainLight();
    float3 shadowCoordWorldPos = i.worldPosWithFog.xyz + mainLight.direction * (_IsFace);

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

    half3 color = (mainLightResult + additionLightSumResult) * simpleToonSurfaceData.albedo;
    
    half fogFactor = i.worldPosWithFog.w;
    // Mix the pixel color with fogColor. You can optionaly use MixFogColor to override the fogColor
    // with a custom one.
    // color = MixFog(color, fogFactor);

    return half4(color, simpleToonSurfaceData.alpha);
    // return half4(simpleToonObjectData.worldNormkalDir, 1);
}

#endif

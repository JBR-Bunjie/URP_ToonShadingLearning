using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace ReArchiving.Editor {
    public class ReArchivingReArchivingToonShaderGUI : ReArchiving_ToonShaderPropertyData {
        #region GUI

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties) {
            m_SurfaceOptionsFoldout = GetFoldoutState(FoldoutName.SurfaceOptions);
            m_BaseFoldout = GetFoldoutState(FoldoutName.Base);
            m_AdvanceFoldout = GetFoldoutState(FoldoutName.Advance);

            // https://docs.unity.cn/cn/2021.3/ScriptReference/ShaderGUI.FindProperty.html
            // Surface Options
            m_WorkflowModeProp = FindProperty(InsideMaterialProperties.WorkflowMode, properties, false);

            // Base
            m_Test = FindProperty(InsideMaterialProperties.Test, properties, false);
            m_MainTex = FindProperty(InsideMaterialProperties.MainTex, properties, false);
            m_MainColor = FindProperty(InsideMaterialProperties.MainColor, properties, false);

            // Advance
            m_RenderQueue = FindProperty(InsideMaterialProperties.RenderQueue, properties, false);
            m_IsFace = FindProperty(InsideMaterialProperties.IsFace, properties, false);
            
            // Draw
            EditorGUI.BeginChangeCheck();
            DrawProperties(materialEditor);
            if (EditorGUI.EndChangeCheck()) SetMaterialKeywords(materialEditor.target as Material);
        }

        #endregion

        // 设定决定 Shader 变体的关键字

        #region Keywords

        private void SetKeyword(Material material, string keyword, bool value) {
            if (value) material.EnableKeyword(keyword);
            else material.DisableKeyword(keyword);
        }

        private void SetMaterialKeywords(Material material) {
            // https://docs.unity3d.com/ScriptReference/Material-shaderKeywords.html
            material.shaderKeywords = null;

            // SetKeyword(material, "_SPECULAR_SETUP", material.GetFloat(InsideMaterialProperties.Test) == 0);
        }

        #endregion

        #region Properties

        private void DrawProperties(MaterialEditor materialEditor) {
            // Surface Options
            var surfaceOptionsFoldout =
                EditorGUILayout.BeginFoldoutHeaderGroup(m_SurfaceOptionsFoldout, GUIContentStruct.SurfaceOptionFoldout);
            SetFoldoutState(FoldoutName.SurfaceOptions, m_SurfaceOptionsFoldout, surfaceOptionsFoldout);
            if (surfaceOptionsFoldout) {
                EditorGUILayout.Space();
                DrawSurfaceOption(materialEditor);
                EditorGUILayout.Space();
            }
            EditorGUILayout.EndFoldoutHeaderGroup();

            // Base
            var baseFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(m_BaseFoldout, GUIContentStruct.BaseFoldout);
            if (baseFoldout) {
                EditorGUILayout.Space();
                DrawBaseOption(materialEditor);
                EditorGUILayout.Space();
            }
            SetFoldoutState(FoldoutName.Base, m_BaseFoldout, baseFoldout);
            EditorGUILayout.EndFoldoutHeaderGroup();
            
            // Advance
            var advanceFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(m_AdvanceFoldout, GUIContentStruct.AdvanceFoldout);
            if (advanceFoldout) {
                EditorGUILayout.Space();
                DrawAdvanceOption(materialEditor);
                EditorGUILayout.Space();
            }
            SetFoldoutState(FoldoutName.Advance, m_AdvanceFoldout, advanceFoldout);
            EditorGUILayout.EndFoldoutHeaderGroup();
        }

        private void DrawSurfaceOption(MaterialEditor materialEditor) {
            Material material = materialEditor.target as Material;

            if (material) {
                // Workflow
                if (material.HasProperty(InsideMaterialProperties.WorkflowMode)) {
                    // materialEditor
                    EditorGUI.showMixedValue = m_WorkflowModeProp.hasMixedValue;
                    EditorGUI.BeginChangeCheck();
                    var workflow = EditorGUILayout.Popup(GUIContentStruct.WorkflowMode, (int)m_WorkflowModeProp.floatValue,
                        Enum.GetNames(typeof(WorkflowModeEnum)));
                    if (EditorGUI.EndChangeCheck()) {
                        materialEditor.RegisterPropertyChangeUndo(InsideMaterialProperties.WorkflowMode);
                        m_WorkflowModeProp.floatValue = workflow;
                        
                    }
                    EditorGUI.showMixedValue = false;

                }

                // Transparent
            }
        }

        private void DrawBaseOption(MaterialEditor materialEditor) {
            materialEditor.TexturePropertySingleLine(GUIContentStruct.MainColor, m_MainTex, m_MainColor);
        }
        
        private void DrawAdvanceOption(MaterialEditor materialEditor) {
            Material material = materialEditor.target as Material;
            
            if (material) {
                if (material.HasProperty(InsideMaterialProperties.RenderQueue)) {
                    EditorGUI.showMixedValue = m_RenderQueue.hasMixedValue;
                    EditorGUI.BeginChangeCheck();
                    var renderQueue = EditorGUILayout.IntSlider(GUIContentStruct.RenderQueue,
                        (int)m_RenderQueue.floatValue, (int)RenderQueueSize.Background, (int)RenderQueueSize.Overlay);
                    if (EditorGUI.EndChangeCheck()) {
                        materialEditor.RegisterPropertyChangeUndo(InsideMaterialProperties.RenderQueue);
                        m_RenderQueue.floatValue = renderQueue;
                    }

                    EditorGUI.showMixedValue = false;
                }
                
                if (material.HasProperty(InsideMaterialProperties.IsFace)) {
                    EditorGUI.showMixedValue = m_IsFace.hasMixedValue;
                    Debug.Log(m_IsFace.floatValue);
                    var isFace = EditorGUILayout.Toggle(GUIContentStruct.IsFace, m_IsFace.floatValue == 0.0f);
                    if (EditorGUI.EndChangeCheck()) {
                        materialEditor.RegisterPropertyChangeUndo(InsideMaterialProperties.IsFace);
                        m_IsFace.floatValue = isFace ? 0 : 1;
                    }
                    
                    EditorGUI.showMixedValue = false;
                }
            }
        }
        

        #endregion

        #region EditorPrefs

        private bool GetFoldoutState(string name) {
            return EditorPrefs.GetBool($"{EditorPreKey}.{name}");
        }

        private void SetFoldoutState(string name, bool field, bool value) {
            if (field == value) return;
            EditorPrefs.SetBool($"{EditorPreKey}.{name}", value);
        }

        #endregion
    }
}
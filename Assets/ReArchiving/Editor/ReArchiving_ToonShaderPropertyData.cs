using UnityEditor;
using UnityEngine;

namespace ReArchiving.Editor {
    public class ReArchiving_ToonShaderPropertyData : ShaderGUI {
        protected const string EditorPreKey = "ReArchiving:ShaderGUI:";

        protected struct GUIContentStruct {
            // Fold
            public static readonly GUIContent SurfaceOptionFoldout = new GUIContent("Surface Option Foldout");
            public static readonly GUIContent BaseFoldout = new GUIContent("Base Foldout");
            public static readonly GUIContent AdvanceFoldout = new GUIContent("Advance");

            // Surface Options Properties
            public static readonly GUIContent WorkflowMode = new GUIContent("Workflow Mode");

            // Base Properties
            public static readonly GUIContent Test = new GUIContent("Test");
            public static readonly GUIContent MainTex = new GUIContent("Main Texture");
            public static readonly GUIContent MainColor = new GUIContent("Main Color");


            // Advance Properties
            public static readonly GUIContent RenderQueue = new GUIContent("Render Queue");
            public static readonly GUIContent IsFace = new GUIContent("Is Face");
        }

        protected struct InsideMaterialProperties {
            // Surface Options Properties
            public static readonly string WorkflowMode = "_WorkflowMode";

            // Base Properties
            public static readonly string Test = "_Test";
            public static readonly string MainTex = "_MainTex";
            public static readonly string MainColor = "_MainColor";

            // Advance Properties
            public static readonly string RenderQueue = "_RenderQueue";
            public static readonly string IsFace = "_IsFace";
        }

        protected struct FoldoutName {
            public static readonly string SurfaceOptions = "SurfaceOptions";
            public static readonly string Base = "Base";
            public static readonly string Advance = "Advance";
        }
        
        #region Data for OnGUI

        // Foldouts
        protected bool m_SurfaceOptionsFoldout;
        protected bool m_BaseFoldout;
        protected bool m_AdvanceFoldout;

        // Surface Options Properties
        protected MaterialProperty m_WorkflowModeProp;

        // Base
        protected MaterialProperty m_Test;
        protected MaterialProperty m_MainTex;
        protected MaterialProperty m_MainColor;

        // Advance
        protected MaterialProperty m_RenderQueue;
        protected MaterialProperty m_IsFace;

        #endregion

        #region ENUM

        public enum WorkflowModeEnum {
            Specular,
            Metallic
        };

        public enum RenderQueueSize {
            Background = 1000,
            Geometry = 2000,
            AlphaTest = 2450,
            Transparent = 3000,
            Overlay = 4000
        }

        #endregion
    }
}
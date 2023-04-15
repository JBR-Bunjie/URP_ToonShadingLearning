using UnityEditor;
using UnityEngine;

namespace ReArchiving.Editor {
    public class CreateHLSLFiles : CreateCustomItemInMenu {
        private const string TemplatePath = "Assets/ReArchiving/Editor/Template/HLSLTemplate.hlsl";

        [MenuItem("Assets/Create/Shader/Single HLSL File")]
        public static void CreateFileFromTemplate() {
            ProjectWindowUtil.StartNameEditingIfProjectWindowExists(
                0, 
                ScriptableObject.CreateInstance<EndAction>(),
                GetSelectedPathOrFallback() + "/HLSLTemplate.hlsl", 
                null, 
                TemplatePath
            );
        }
    }
}
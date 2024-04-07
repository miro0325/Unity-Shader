Shader "Unlit/CellShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Brightness("Brightness", Range(0,1)) = 0.3
        _Strength("Strength", Range(0,1)) = 0.5
        _Color("Color", COLOR) = (1,1,1,1)
        [HDR] _BaseColor("BaseColor",COLOR) = (1,1,1,1)
        _Outline_Bold ("Outline Bold", float) = 0
        _OutlineColor("Outline Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        cull front
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float _Outline_Bold;
            float4 _OutlineColor;
                
            struct appdata
            {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float4 color : COLOR;
            }; 
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            }; 
            v2f vert(appdata o) 
            {
                v2f v;
                v.color = _OutlineColor;

                float3 fNormalized_Normal = normalize(o.normal);
                float3 fOutline_Position = o.vertex + fNormalized_Normal * (_Outline_Bold * 0.1f);

                v.vertex = UnityObjectToClipPos(fOutline_Position);
                v.color = o.color;
                return v;
                    
            }


            float4 frag(v2f i) : SV_Target
            {
                return i.color; 
            }

            
            ENDCG
        }
        cull back
        Pass
        {
           
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
               // UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                half3 worldNormal: NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Brightness;
            float4 _BaseColor;  
            float _Strength;
            float4 _Color;


            float Toon(float3 normal, float3 lightDir) {
                float NdotL =  max(0.0,dot(normalize(normal),normalize(lightDir))); 

                return floor(NdotL/0.3);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal)
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv); 
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                col *= (Toon(i.worldNormal,_WorldSpaceLightPos0.xyz)*_Strength*_Color+_Brightness)*_BaseColor;
                
                return col;
            }
            ENDCG
        }
    }
}

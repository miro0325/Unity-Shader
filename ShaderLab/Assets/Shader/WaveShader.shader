Shader "Custom/WaveShader"
{
    Properties
    {
        _MainTex("Main Texture",2D) = "white" {}
        _Tint("Colour Tint", Color) = (1,1,1,1)
        _Freq("Frequency", Range(0,10)) = 3
        _Speed("Speed", Range(0,100)) = 10
        _Amp("Amplitude", Range(0,1)) = 0.5
    }
    SubShader
    {
       
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert 

        struct Input 
        {
            float2 uv_MainTex;
            float3 vertexColor;
        };

        struct appdata 
        {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
            float4 texcoord : TEXCOORD0;
            float4 texcoord1 : TEXCOORD1;
            float4 texcoord2 : TEXCOORD2;
        };

        float4 _Tint;
        float _Freq;
        float _Speed;
        float _Amp;

        sampler2D _MainTex;

        void vert(inout appdata v, out Input o) 
        {
            UNITY_INITIALIZE_OUTPUT(Input,o);
            float t = _Time * _Speed;
            float waveHeightX = cos(t + v.vertex.x * _Freq) * _Amp;
            float waveHeightZ = cos(t + v.vertex.z * _Freq) * _Amp;
            float waveHeight = (waveHeightX + waveHeightZ)/2;
            v.vertex.y = v.vertex.y + waveHeight;
            v.normal = normalize(float3(v.normal.x + waveHeight,v.normal.y,v.normal.z + waveHeight));
            o.vertexColor = waveHeight + 2;
        }

        void surf(Input IN, inout SurfaceOutput o) 
        {
            float4 col = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = col * IN.vertexColor.rgb * _Tint;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

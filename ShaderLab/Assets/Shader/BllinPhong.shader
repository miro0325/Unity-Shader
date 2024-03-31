Shader "Custom/BlinnPhong"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        
    }
    SubShader
    {
        Tags { "Queue"="Geometry" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Blinn

        #pragma target 3.0

        half4 LightingBlinn (SurfaceOutput s, half3 lightDir,half3 viewDir, half atten) 
        {
            half3 h = normalize(lightDir + viewDir);
            half diff  = max(0,dot(s.Normal,lightDir));
            //diff = floor(diff / 0.3);
            float nh = max(0,dot(s.Normal,h));
            float spec = pow(nh,48);
            //spec = smoothstep(0.005, 0.1,spec);
            //spec = floor(spec / 0.3);

            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
            c.a = s.Alpha;
            return c;
        }

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

      
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            //o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

Shader "Custom/Rotate"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed ("SPEED", Float) = 5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define PI 3.14159

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4x4 rotate(float angle)
            {
                // この軸を少しいじると面白い曲がり方をする
                return float4x4(
                    cos(angle), -sin(angle), 0, 0,
                    sin(angle), cos(angle), 0, 0,
                    0, 0, 1, 0,
                    0, 0, 0, 1
                );
            }

            float _Speed;

            v2f vert (appdata v)
            {
                v2f o;
                
                float x = sin(_Time * _Speed) * PI;
                float4x4 v4 = rotate(x);
                float4 result = mul(v4, v.vertex);
                
                o.vertex = UnityObjectToClipPos(result);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/DeformationShader"
{
	Properties
	{
		_ImpactPosition ("Impact Position",Vector) = (0,0,0)
        _ImpactForce ("Impact Force", float) = 0
		_Color("Color",Color) = (0,0,0,1)
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
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			//struct appdata
			//{
				//float4 vertex : POSITION;
			//};

			struct v2f
			{
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
			};

			float4 _ImpactPosition;
			float4 _CollisionDirection;
            		float _ImpactForce;
			float4 _Color;
            		sampler2D _MainTex;
            		float4 _MainTex_ST;
			
			v2f vert (appdata_base v)
			{
				v2f o;
				//o.vertex = UnityObjectToClipPos(v.vertex);
				float4 worldVertex = mul(unity_ObjectToWorld, v.vertex);
                float4 newWorldVertex = worldVertex;
				//float4 windDirection = worldVertex - _ImpactPosition;
                if(_ImpactForce > 0){
				    float distance = length(worldVertex- _ImpactPosition);
            
				    //float crossProduct = dot(windDirection, -v.normal);
				    float force = _ImpactForce*exp(-(distance*distance));

				    newWorldVertex = newWorldVertex - ((force)*_CollisionDirection);
                    }
				
				o.vertex = mul(UNITY_MATRIX_VP, newWorldVertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				//UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = _Color;
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}

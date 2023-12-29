using UnityEngine;

public class MobileLightRotation : MonoBehaviour
{
    private bool gyroEnabled;
    private Gyroscope gyro;

    void Start()
    {
        gyroEnabled = EnableGyro();
    }

    bool EnableGyro()
    {
        if (SystemInfo.supportsGyroscope)
        {
            gyro = Input.gyro;
            gyro.enabled = true;
            return true;
        }
        return false;
    }

    void Update()
    {
        if (gyroEnabled)
        {
            Quaternion deviceRotation = gyro.attitude;

            // 调整光源的方向来匹配设备的旋转
            Vector3 lightDirection = deviceRotation * Vector3.forward;
            // 使用lightDirection来更新Directional Light的方向
            GameObject directionalLightObject = GameObject.Find("Directional Light");
            if (directionalLightObject != null)
            {
                Light directionalLight = directionalLightObject.GetComponent<Light>();
                if (directionalLight != null)
                {
                    directionalLight.transform.forward = lightDirection;
                }
            }
        }
    }
}

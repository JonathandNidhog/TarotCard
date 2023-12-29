using UnityEngine;

public class RotateAroundZ : MonoBehaviour
{
    public float speed = 10f; // 旋转速度

    void Update()
    {
        // 绕Z轴旋转，使用Time.deltaTime确保平滑旋转
        transform.Rotate(0, 0, speed * Time.deltaTime);
    }
}
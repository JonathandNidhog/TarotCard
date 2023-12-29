using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    // Start is called before the first frame update
    public float speed = 10f; // 旋转速度

    void Update()
    {
        // 绕Z轴旋转，使用Time.deltaTime确保平滑旋转
        transform.Rotate(0, speed * Time.deltaTime, 0);
    }
}

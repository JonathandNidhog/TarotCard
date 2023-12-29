using UnityEngine;

public class RotateMouseDrag : MonoBehaviour
{
    private Vector3 _initialMousePosition;
    private Quaternion _initialRotation;
    private bool _isDragging = false;

    void Update()
    {
        if (Input.GetKey(KeyCode.Escape))
        {
            // 如果按下"Esc"键，退出游戏
            Application.Quit();
        }

        if (Input.GetMouseButtonDown(0))
        {
            // 鼠标左键按下时开始拖拽
            _isDragging = true;
            _initialMousePosition = Input.mousePosition;
            _initialRotation = transform.rotation;
        }

        if (Input.GetMouseButtonUp(0))
        {
            // 鼠标左键松开时停止拖拽
            _isDragging = false;
        }

        if (_isDragging)
        {
            // 计算鼠标拖拽的偏移量
            Vector3 deltaMousePosition = Input.mousePosition - _initialMousePosition;

            // 根据偏移量旋转物体
            Quaternion deltaRotation = Quaternion.Euler(deltaMousePosition.y, -deltaMousePosition.x, 0);
            transform.rotation = _initialRotation * deltaRotation;
        }
    }
}